// lib/features/account/data/datasources/post_remote_data_source.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:prism/core/util/models/pagination_model.dart';

import '../../../../../core/errors/exceptions/network_exception.dart';
import '../../../../../core/errors/exceptions/server_exception.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/util/sevices/api_endpoints.dart';
import '../../models/post/paginated_posts_model.dart';
import '../../models/post/post_model.dart';

abstract class PostRemoteDataSource {
  Future<PaginatedPostsModel> getFeedPosts({
    required String token,
    int page = 1,
  });

  Future<PaginatedPostsModel> getPersonalPosts({
    required String token,
    int? userId,
    int page = 1,
  });

  Future<PaginatedPostsModel> getSavedPosts({
    required String token,
    int page = 1,
  });

  Future<PostModel> getPostDetails({
    required String token,
    required int postId,
  });

  Future<PostModel> createPost({
    required String token,
    String? text,
    required String privacy,
    List<File>? mediaFiles,
    int? groupId,
  });

  Future<void> updatePost({
    required String token,
    required int postId,
    String? text,
    String? privacy,
    List<File>? mediaFiles,
    List<int>? removedMediaIds,
  });

  Future<void> deletePost({required String token, required int postId});

  Future<void> savePost({required String token, required int postId});

  Future<void> unsavePost({required String token, required int postId});

  Future<void> toggleLikePost({required String token, required int postId});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ApiClient apiClient;

  const PostRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _authHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  Future<PaginatedPostsModel> getFeedPosts({
    required String token,
    int page = 1,
  }) async {
    try {
      final url = '${ApiEndpoints.posts}/feed?page=$page';

      final response = await apiClient.get(url, headers: _authHeaders(token));
      debugPrint(response.toString());
      return PaginatedPostsModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get feed posts: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedPostsModel> getPersonalPosts({
    required String token,
    int? userId,
    int page = 1,
  }) async {
    try {
      String url = '${ApiEndpoints.posts}?page=$page';
      if (userId != null) {
        url += '&user_id=$userId';
      }

      final response = await apiClient.get(url, headers: _authHeaders(token));
      return PaginatedPostsModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get all posts: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedPostsModel> getSavedPosts({
    required String token,
    int page = 1,
  }) async {
    try {
      final url = '${ApiEndpoints.savedPosts}?page=$page';
      final response = await apiClient.get(url, headers: _authHeaders(token));

      if (response.containsKey('saved_posts') &&
          response.containsKey('pagination')) {
        // إذا الريسبونس يحتوي على saved_posts و pagination
        return PaginatedPostsModel.fromJson({
          'posts': response['saved_posts'],
          'pagination': response['pagination'],
        });
      } else if (response.containsKey('message') &&
          response['message'] == 'No saved posts found.') {
        // إعادة كائن فارغ مع pagination افتراضية
        return PaginatedPostsModel(
          posts: const [],
          pagination: PaginationModel(
            currentPage: page,
            perPage: 0,
            total: 0,
            lastPage: 1,
          ),
        );
      } else {
        throw ServerException('Invalid response format for saved posts.');
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get saved posts: ${e.toString()}');
    }
  }

  @override
  Future<PostModel> getPostDetails({
    required String token,
    required int postId,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.posts}/$postId',
        headers: _authHeaders(token),
      );

      if (response.isEmpty || !response.containsKey('post')) {
        throw ServerException(
          'Post details response is empty or missing "post" key.',
        );
      }
      return PostModel.fromJson(response['post'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get post details: ${e.toString()}');
    }
  }

  @override
  Future<PostModel> createPost({
    required String token,
    String? text,
    required String privacy,
    List<File>? mediaFiles,
    int? groupId,
  }) async {
    try {
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        final uri = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.posts}');
        var request = http.MultipartRequest('POST', uri);
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });

        if (text != null) request.fields['text'] = text;
        request.fields['privacy'] = privacy;
        if (groupId != null) request.fields['group_id'] = groupId.toString();

        for (var file in mediaFiles) {
          final multipartFile = await http.MultipartFile.fromPath(
            'media[]',
            file.path,
            filename: path.basename(file.path),
          );
          request.files.add(multipartFile);
        }

        final streamedResponse = await request.send();
        final responseBody = await http.Response.fromStream(streamedResponse);
        debugPrint('rafat :${responseBody.toString()}');
        final data = ApiClient.handleResponse(responseBody);
        if (data.containsKey('post') && data['post'] is Map<String, dynamic>) {
          return PostModel.fromJson(data['post'] as Map<String, dynamic>);
        } else {
          throw ServerException(
            'Invalid response format for create post: Expected a post object under "post" key.',
          );
        }
      } else {
        final bodyData = {'privacy': privacy};
        if (text != null) bodyData['text'] = text;
        if (groupId != null) bodyData['group_id'] = groupId.toString();

        final response = await apiClient.post(
          ApiEndpoints.posts,
          bodyData,
          headers: _authHeaders(token),
        );
        debugPrint('rafat :${response.toString()}');
        if (response.containsKey('post') &&
            response['post'] is Map<String, dynamic>) {
          return PostModel.fromJson(response['post'] as Map<String, dynamic>);
        } else {
          throw ServerException(
            'Invalid response format for create post: Expected a post object under "post" key.',
          );
        }
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to create post: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePost({
    required String token,
    required int postId,
    String? text,
    String? privacy,
    List<File>? mediaFiles,
    List<int>? removedMediaIds,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.posts}/$postId',
      );
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (text != null) request.fields['text'] = text;
      if (privacy != null) request.fields['privacy'] = privacy;

      if (removedMediaIds != null && removedMediaIds.isNotEmpty) {
        for (var id in removedMediaIds) {
          request.fields['removedMedia[]'] = id.toString();
        }
      }

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          final multipartFile = await http.MultipartFile.fromPath(
            'media[]',
            file.path,
            filename: path.basename(file.path),
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      final responseBody = await http.Response.fromStream(streamedResponse);
      final data = ApiClient.handleResponse(responseBody);

      debugPrint('Updated post response: $data');
    } catch (e) {
      throw ServerException('Failed to update post: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePost({required String token, required int postId}) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.posts}/$postId',
        headers: _authHeaders(token),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete post: ${e.toString()}');
    }
  }

  @override
  Future<void> savePost({required String token, required int postId}) async {
    try {
      await apiClient.post(
        '${ApiEndpoints.savedPosts}/$postId',
        {},
        headers: _authHeaders(token),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle save status: ${e.toString()}');
    }
  }

  @override
  Future<void> unsavePost({required String token, required int postId}) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.unsavedPosts}/$postId',
        headers: _authHeaders(token),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle save status: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleLikePost({
    required String token,
    required int postId,
  }) async {
    try {
      await apiClient.post(ApiEndpoints.likes, {
        'post_id': postId,
      }, headers: _authHeaders(token));
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle like status: ${e.toString()}');
    }
  }
}
