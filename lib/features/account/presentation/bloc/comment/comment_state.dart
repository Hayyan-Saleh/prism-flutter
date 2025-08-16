// comment_state.dart
part of 'comment_bloc.dart';

abstract class CommentState extends Equatable {
  const CommentState();
  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentsLoaded extends CommentState {
  final PaginatedCommentsEntity paginated;

  const CommentsLoaded({required this.paginated});

  @override
  List<Object?> get props => [paginated];
}

class CommentOperationSuccess extends CommentState {
  final String message;
  final PaginatedCommentsEntity? paginated;
  const CommentOperationSuccess(this.message, {this.paginated});

  @override
  List<Object?> get props => [message, paginated];
}

class CommentError extends CommentState {
  final AccountFailure failure;
  const CommentError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
