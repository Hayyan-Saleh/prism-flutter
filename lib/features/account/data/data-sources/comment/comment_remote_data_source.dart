// lib/features/comments/data/data-sources/comment_remote_data_source.dart
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/features/account/data/models/comment/paginated_comments_model.dart';
import 'package:prism/features/account/data/models/comment/comment_model.dart';

abstract class CommentRemoteDataSource {
  Future<PaginatedCommentsModel> getComments({
    required String token,
    required int page,
    int? postId,
    int? adId,
    int? commentId,
  });

  Future<CommentModel> addComment({
    required String token,
    required String text,
    required String commentableType,
    required int commentableId,
  });

  Future<CommentModel> updateComment({
    required String token,
    required int id,
    required String text,
  });

  Future<void> deleteComment({required String token, required int id});

  Future<void> toggleLikeComment({
    required String token,
    required int commentId,
  });
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final ApiClient apiClient;

  const CommentRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _authHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  Future<PaginatedCommentsModel> getComments({
    required String token,
    required int page,
    int? postId,
    int? adId,
    int? commentId,
  }) async {
    try {
      String url = '${ApiEndpoints.comments}?page=$page';

      if (postId != null) {
        url += '&post_id=$postId';
      } else if (adId != null) {
        url += '&ad_id=$adId';
      } else if (commentId != null) {
        url += '&comment_id=$commentId';
      } else {
        throw ServerException(
          'You must provide either post_id, ad_id, or comment_id.',
        );
      }

      final response = await apiClient.get(url, headers: _authHeaders(token));

      return PaginatedCommentsModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to get comments: ${e.toString()}');
    }
  }

  @override
  Future<CommentModel> addComment({
    required String token,
    required String text,
    required String commentableType,
    required int commentableId,
  }) async {
    try {
      final body = {
        'text': text,
        'commentable_type': commentableType, // Post | Ad | Comment
        'commentable_id': commentableId,
      };

      final response = await apiClient.post(
        ApiEndpoints.comments,
        body,
        headers: _authHeaders(token),
      );

      final commentJson = (response['comment'] as Map<String, dynamic>);
      return CommentModel.fromJson(commentJson);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to add comment: ${e.toString()}');
    }
  }

  @override
  Future<CommentModel> updateComment({
    required String token,
    required int id,
    required String text,
  }) async {
    try {
      final response = await apiClient.post('${ApiEndpoints.comments}/$id', {
        'text': text,
      }, headers: _authHeaders(token));

      if (response['comment'] != null) {
        return CommentModel.fromJson(
          response['comment'] as Map<String, dynamic>,
        );
      } else {
        final show = await apiClient.get(
          '${ApiEndpoints.comments}/$id',
          headers: _authHeaders(token),
        );
        return CommentModel.fromJson(show['comment'] as Map<String, dynamic>);
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update comment: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment({required String token, required int id}) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.comments}/$id',
        headers: _authHeaders(token),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete comment: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleLikeComment({
    required String token,
    required int commentId,
  }) async {
    try {
      await apiClient.post(ApiEndpoints.likes, {
        'comment_id': commentId,
      }, headers: _authHeaders(token));
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to toggle like: ${e.toString()}');
    }
  }
}
