part of 'like_bloc.dart';

abstract class LikeState extends Equatable {
  final bool isLiked;
  final int likesCount;

  const LikeState({required this.isLiked, required this.likesCount});

  @override
  List<Object> get props => [isLiked, likesCount];
}

class LikeInitial extends LikeState {
  const LikeInitial({required super.isLiked, required super.likesCount});
}

class LikeInProgress extends LikeState {
  const LikeInProgress({required super.isLiked, required super.likesCount});
}

class LikeSuccess extends LikeState {
  const LikeSuccess({required super.isLiked, required super.likesCount});
}

class LikeFailure extends LikeState {
  final String message;

  const LikeFailure(this.message,
      {required super.isLiked, required super.likesCount});

  @override
  List<Object> get props => [message, isLiked, likesCount];
}