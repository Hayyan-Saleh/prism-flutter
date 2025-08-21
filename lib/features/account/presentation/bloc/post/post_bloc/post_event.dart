part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeedPosts extends PostEvent {
  final int pageNum;

  const LoadFeedPosts({this.pageNum = 1});

  @override
  List<Object?> get props => [pageNum];
}

class LoadPersonalPosts extends PostEvent {
  final int userId;
  final int pageNum;

  const LoadPersonalPosts({required this.userId, required this.pageNum});

  @override
  List<Object?> get props => [userId, pageNum];
}

class LoadSavedPosts extends PostEvent {
  final int pageNum;

  const LoadSavedPosts({required this.pageNum});

  @override
  List<Object?> get props => [pageNum];
}

class AddNewPost extends PostEvent {
  final String? text;
  final String privacy;
  final int? groupId;
  final List<String>? mediaPaths;

  const AddNewPost({
    this.text,
    required this.privacy,
    this.groupId,
    this.mediaPaths,
  });

  @override
  List<Object?> get props => [text, privacy, groupId, mediaPaths];
}

class UpdateExistingPost extends PostEvent {
  final int userId;

  final int postId;
  final String? text;
  final String? privacy;
  final List<File>? mediaFiles;
  final List<int>? removedMediaIds;

  const UpdateExistingPost({
    required this.userId,
    required this.postId,
    this.text,
    this.privacy,
    this.mediaFiles,
    this.removedMediaIds,
  });

  @override
  List<Object?> get props => [
    postId,
    text,
    privacy,
    mediaFiles,
    removedMediaIds,
  ];
}

class TogglePostLike extends PostEvent {
  final int postId;

  const TogglePostLike({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class PostSave extends PostEvent {
  final int postId;

  const PostSave({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class PostUnsave extends PostEvent {
  final int postId;

  const PostUnsave({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class DeletePost extends PostEvent {
  final int postId;
  final int userId;

  const DeletePost({required this.postId, required this.userId});

  @override
  List<Object?> get props => [postId];
}
