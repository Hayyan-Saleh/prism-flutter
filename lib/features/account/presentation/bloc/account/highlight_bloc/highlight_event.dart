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

class GetHighlights extends HighlightEvent {
  final int? accountId;

  const GetHighlights({this.accountId});

  @override
  List<Object?> get props => [accountId];
}

class GetDetailedHighlight extends HighlightEvent {
  final int highlightId;

  const GetDetailedHighlight({required this.highlightId});

  @override
  List<Object?> get props => [highlightId];
}

class DeleteHighlight extends HighlightEvent {
  final int highlightId;

  const DeleteHighlight({required this.highlightId});

  @override
  List<Object> get props => [highlightId];
}

class UpdateHighlightCover extends HighlightEvent {
  final int highlightId;
  final File cover;

  const UpdateHighlightCover({required this.highlightId, required this.cover});

  @override
  List<Object> get props => [highlightId, cover];
}

class AddToHighlight extends HighlightEvent {
  final int highlightId;
  final int statusId;

  const AddToHighlight({required this.highlightId, required this.statusId});

  @override
  List<Object> get props => [highlightId, statusId];
}

