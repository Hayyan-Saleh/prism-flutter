part of 'highlight_bloc.dart';

abstract class HighlightState extends Equatable {
  const HighlightState();

  @override
  List<Object> get props => [];
}

class HighlightInitial extends HighlightState {}

class HighlightLoading extends HighlightState {}

class HighlightCreated extends HighlightState {}

class HighlightsLoaded extends HighlightState {
  final List<HighlightEntity> highlights;

  const HighlightsLoaded({required this.highlights});

  @override
  List<Object> get props => [highlights];
}

class DetailedHighlightLoaded extends HighlightState {
  final DetailedHighlightEntity highlight;

  const DetailedHighlightLoaded({required this.highlight});

  @override
  List<Object> get props => [highlight];
}

class HighlightDeleted extends HighlightState {}

class HighlightCoverUpdated extends HighlightState {}

class HighlightFailure extends HighlightState {
  final String message;

  const HighlightFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class HighlightAddedTo extends HighlightState {}
