import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:prism/core/errors/exceptions/account_exception.dart';
import 'package:prism/core/errors/exceptions/network_exception.dart';
import 'package:prism/core/errors/exceptions/server_exception.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/core/network/api_client.dart';
import 'package:prism/core/util/constants/strings.dart';
import 'package:prism/core/util/sevices/api_endpoints.dart';
import 'package:prism/features/account/data/models/account/main/other_account_model.dart';
import 'package:prism/features/account/data/models/account/main/personal_account_model.dart';
import 'package:prism/features/account/data/models/account/simplified/simplified_account_model.dart';
import 'package:prism/features/account/data/models/account/status/status_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';

abstract class AccountRemoteDataSource {
  Future<bool> checkAccountName({
    required String token,
    required String accountName,
  });

  Future<Map<String, dynamic>> editPersonalAccount({
    required String token,
    required File? profilePic,
    required PersonalAccountModel personalAccount,
  });

  Future<PersonalAccountModel> getRemotePersonalAccount({
    required String token,
    required int id,
  });

  Future<List<SimplifiedAccountModel>> getFollowers({
    required String token,
    required int accountId,
  });

  Future<List<SimplifiedAccountModel>> getFollowings({
    required String token,
    required int accountId,
  });

  Future<void> createStatus({
    required String token,
    required String privacy,
    String? text,
    File? media,
  });

  Future<Either<AccountFailure, OtherAccountModel>> getOtherAccount({
    required String token,
    required int id,
  });

  Future<FollowStatus> updateAccountFollowingStatus({
    required String token,
    required int targetId,
    required bool newStatus,
  });

  Future<List<StatusModel>> getStatuses({
    required String token,
    required int accountId,
  });

  Future<List<SimplifiedAccountModel>> getFollowingStatuses({
    required String token,
  });

  Future<void> deleteStatus({required String token, required int statusId});

  Future<void> deleteAccount({required String token});

  Future<void> blockUser({required String token, required int targetId});

  Future<void> unblockUser({required String token, required int targetId});
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final ApiClient apiClient;

  const AccountRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<bool> checkAccountName({
    required String token,
    required String accountName,
  }) async {
    final response = await apiClient.get(
      "${ApiEndpoints.checkUserName}?username=$accountName",
      headers: _authHeaders(token),
    );
    return response['valid'] as bool;
  }

  @override
  Future<Map<String, dynamic>> editPersonalAccount({
    required String token,
    required PersonalAccountModel personalAccount,
    required File? profilePic,
  }) async {
    try {
      if (profilePic != null && await profilePic.exists()) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            '${ApiEndpoints.baseUrl}${ApiEndpoints.updatePersonalAccount}',
          ),
        );
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        });

        final fields =
            personalAccount.toJson()
              ..removeWhere(
                (key, value) =>
                    value == null || (value is String && value.isEmpty),
              )
              ..remove('avatar')
              ..remove('personal_info');
        request.fields.addAll(
          fields.map(
            (key, value) => MapEntry(
              key,
              value is bool ? (value ? '1' : '0') : value.toString(),
            ),
          ),
        );

        if (personalAccount.personalInfos.isNotEmpty) {
          personalAccount.personalInfos.forEach((key, values) {
            values.asMap().forEach((index, value) {
              request.fields['personal_info[$key][$index]'] = value;
            });
          });
        }

        final imageFile = await http.MultipartFile.fromPath(
          'avatar',
          profilePic.path,
          filename: path.basename(profilePic.path),
        );
        request.files.add(imageFile);

        final response = await request.send();
        final responseBody = await http.Response.fromStream(response);

        if (responseBody.statusCode == 302) {
          throw Exception(
            'Redirect detected. Check authentication or middleware.',
          );
        }

        return ApiClient.handleResponse(responseBody);
      } else {
        final data =
            personalAccount.toJson()
              ..removeWhere(
                (key, value) =>
                    value == null || (value is String && value.isEmpty),
              )
              ..remove('avatar')
              ..remove('personal_info');

        if (personalAccount.personalInfos.isNotEmpty) {
          data['personal_info'] = personalAccount.personalInfos;
        }

        return await apiClient.post(
          ApiEndpoints.updatePersonalAccount,
          data,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<PersonalAccountModel> getRemotePersonalAccount({
    required String token,
    required int id,
  }) async {
    final response =
        (await apiClient.get(
          '${ApiEndpoints.fetchUserAccount}/$id',
          headers: _authHeaders(token),
        ))['user'];
    if (response['username'] == null) {
      throw AccountException(AccountErrorMessages.accountNotFound);
    }
    return PersonalAccountModel.fromJson(response);
  }

  @override
  Future<Either<AccountFailure, OtherAccountModel>> getOtherAccount({
    required String token,
    required int id,
  }) async {
    try {
      final response =
          (await apiClient.get(
            '${ApiEndpoints.fetchUserAccount}/$id',
            headers: _authHeaders(token),
          ))['user'];
      return Right(OtherAccountModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(AccountFailure(e.message));
    } on NetworkException catch (e) {
      return Left(AccountFailure(e.message));
    }
  }

  @override
  Future<FollowStatus> updateAccountFollowingStatus({
    required String token,
    required int targetId,
    required bool newStatus,
  }) async {
    try {
      if (newStatus) {
        final response = await apiClient.post(ApiEndpoints.followUser, {
          'targetId': targetId,
        }, headers: _authHeaders(token));

        if (response['message'] == 'You cannot follow yourself.') {
          throw AccountException(response['message']);
        }
        if (response['message'].contains('request sent')) {
          return FollowStatus.pending;
        }
        if (response['message'].contains('request withdrawn')) {
          return FollowStatus.notFollowing;
        }
        return FollowStatus.following;
      } else {
        await apiClient.delete(
          '${ApiEndpoints.usersPrefix}/$targetId/${ApiEndpoints.unfollow}',
          headers: _authHeaders(token),
        );
        return FollowStatus.notFollowing;
      }
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    } catch (e) {
      throw AccountException("Failed to update follow status");
    }
  }

  @override
  Future<List<SimplifiedAccountModel>> getFollowers({
    required String token,
    required int accountId,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersPrefix}/$accountId/${ApiEndpoints.followers}',
        headers: _authHeaders(token),
      );

      final followersList = response['followers'] as List;
      final accounts =
          followersList
              .map(
                (json) => SimplifiedAccountModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
      return accounts;
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<List<SimplifiedAccountModel>> getFollowings({
    required String token,
    required int accountId,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.usersPrefix}/$accountId/${ApiEndpoints.following}',
        headers: _authHeaders(token),
      );

      final followingList = response['following'] as List;
      final accounts =
          followingList
              .map(
                (json) => SimplifiedAccountModel.fromJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
      return accounts;
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<List<StatusModel>> getStatuses({
    required String token,
    required int accountId,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.getUserStatuses}?user_id=$accountId',
        headers: _authHeaders(token),
      );

      return (response['statuses'] as List)
          .map((json) => StatusModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> createStatus({
    required String token,
    required String privacy,
    String? text,
    File? media,
  }) async {
    try {
      if (media != null && await media.exists()) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.createStatus}'),
        );
        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        });

        request.fields['privacy'] = privacy;
        if (text != null) request.fields['text'] = text;

        final mediaFile = await http.MultipartFile.fromPath(
          'media',
          media.path,
          filename: path.basename(media.path),
        );
        request.files.add(mediaFile);

        final response = await request.send();
        final responseBody = await http.Response.fromStream(response);

        ApiClient.handleResponse(responseBody);
      } else {
        final data = {'privacy': privacy};
        if (text != null) data['text'] = text;

        await apiClient.post(
          ApiEndpoints.createStatus,
          data,
          headers: _authHeaders(token),
        );
      }
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> deleteStatus({
    required String token,
    required int statusId,
  }) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.getUserStatuses}/$statusId',
        headers: _authHeaders(token),
      );
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> deleteAccount({required String token}) async {
    try {
      await apiClient.delete(
        ApiEndpoints.deletePersonalAccount,
        headers: _authHeaders(token),
      );
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> blockUser({required String token, required int targetId}) async {
    try {
      await apiClient.post(ApiEndpoints.blockOtherUser, {
        'targetId': targetId,
      }, headers: _authHeaders(token));
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<void> unblockUser({
    required String token,
    required int targetId,
  }) async {
    try {
      await apiClient.post(ApiEndpoints.unblockOtherUser, {
        'targetId': targetId,
      }, headers: _authHeaders(token));
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  @override
  Future<List<SimplifiedAccountModel>> getFollowingStatuses({
    required String token,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.getFollowingWithStatus,
        headers: _authHeaders(token),
      );

      final accounts =
          (response['followings'] as List)
              .map((json) => SimplifiedAccountModel.fromJson(json))
              .toList();
      return accounts;
    } on ServerException catch (e) {
      throw AccountException(e.message);
    } on NetworkException catch (e) {
      throw AccountException(e.message);
    }
  }

  Map<String, String> _authHeaders(String token) => {
    'Authorization': 'Bearer $token',
  };
}
