import 'package:equatable/equatable.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class LoadComments extends CommentEvent {
  final String postId;
  final bool refresh;

  const LoadComments(this.postId, {this.refresh = false});

  @override
  List<Object> get props => [postId, refresh];
}

class AddComment extends CommentEvent {
  final String postId;
  final String content;
  final String? parentCommentId;

  const AddComment(this.postId, this.content, {this.parentCommentId});

  @override
  List<Object> get props => [postId, content, parentCommentId ?? ''];
}

class UpdateComment extends CommentEvent {
  final String commentId;
  final String newContent;

  const UpdateComment(this.commentId, this.newContent);

  @override
  List<Object> get props => [commentId, newContent];
}

class DeleteComment extends CommentEvent {
  final String commentId;

  const DeleteComment(this.commentId);

  @override
  List<Object> get props => [commentId];
}

class LikeComment extends CommentEvent {
  final String commentId;
  final String userId;

  const LikeComment(this.commentId, this.userId);

  @override
  List<Object> get props => [commentId, userId];
}

class UnlikeComment extends CommentEvent {
  final String commentId;
  final String userId;

  const UnlikeComment(this.commentId, this.userId);

  @override
  List<Object> get props => [commentId, userId];
}
