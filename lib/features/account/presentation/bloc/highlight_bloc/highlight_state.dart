part of 'highlight_bloc.dart';

abstract class HighlightState extends Equatable {
  const HighlightState();

  @override
  List<Object> get props => [];
}

class HighlightInitial extends HighlightState {}

class HighlightLoading extends HighlightState {}

class HighlightCreated extends HighlightState {}

class HighlightFailure extends HighlightState {
  final String message;

  const HighlightFailure({required this.message});

  @override
  List<Object> get props => [message];
}
