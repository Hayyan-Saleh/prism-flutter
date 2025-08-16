// comment_event.dart
part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();
  @override
  List<Object?> get props => [];
}

class LoadComments extends CommentEvent {
  final int pageNum;
  final int? postId;
  final int? adId;
  final int? commentId; // لجلب الردود لتطبيق التداخل

  const LoadComments({
    this.pageNum = 1,
    this.postId,
    this.adId,
    this.commentId,
  });

  @override
  List<Object?> get props => [pageNum, postId, adId, commentId];
}

class RefreshComments extends CommentEvent {
  final int? postId;
  final int? adId;
  final int? commentId;

  const RefreshComments({this.postId, this.adId, this.commentId});

  @override
  List<Object?> get props => [postId, adId, commentId];
}

class AddCommentEvent extends CommentEvent {
  final String text;
  final String commentableType; // Post | Ad | Comment
  final int commentableId;

  const AddCommentEvent({
    required this.text,
    required this.commentableType,
    required this.commentableId,
  });

  @override
  List<Object?> get props => [text, commentableType, commentableId];
}

class UpdateCommentEvent extends CommentEvent {
  final int id;
  final String text;

  const UpdateCommentEvent({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];
}

class DeleteCommentEvent extends CommentEvent {
  final int id;
  const DeleteCommentEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ToggleLikeCommentEvent extends CommentEvent {
  final int id;
  const ToggleLikeCommentEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
