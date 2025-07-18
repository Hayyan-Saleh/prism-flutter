part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class ToggleLikeEvent extends LikeEvent {
  final int statusId;

  const ToggleLikeEvent({
    required this.statusId,
  });

  @override
  List<Object> get props => [statusId];
}