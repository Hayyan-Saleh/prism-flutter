part of 'highlight_bloc.dart';

abstract class HighlightEvent extends Equatable {
  const HighlightEvent();

  @override
  List<Object?> get props => [];
}

class CreateHighlight extends HighlightEvent {
  final List<int> statusIds;
  final String? text;
  final File? cover;

  const CreateHighlight({
    required this.statusIds,
    this.text,
    this.cover,
  });

  @override
  List<Object?> get props => [statusIds, text, cover];
}
