part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class FeedPostsLoadedSuccess extends PostState {
  final PaginatedPostsEntity paginatedPosts;

  const FeedPostsLoadedSuccess({required this.paginatedPosts});

  @override
  List<Object?> get props => [paginatedPosts];
}

class PersonalPostsLoadedSuccess extends PostState {
  final PaginatedPostsEntity paginatedPosts;

  const PersonalPostsLoadedSuccess({required this.paginatedPosts});

  @override
  List<Object?> get props => [paginatedPosts];
}

class SavedPostsLoadedSuccess extends PostState {
  final PaginatedPostsEntity paginatedPosts;

  const SavedPostsLoadedSuccess({required this.paginatedPosts});

  @override
  List<Object?> get props => [paginatedPosts];
}

class PostOperationSuccess extends PostState {
  final String message;

  const PostOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostError extends PostState {
  final AccountFailure failure;

  const PostError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
