part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupEvent extends GroupEvent {
  final String name;
  final String privacy;
  final File? avatar;
  final String? bio;

  const CreateGroupEvent({
    required this.name,
    required this.privacy,
    this.avatar,
    this.bio,
  });

  @override
  List<Object> get props => [name, privacy, avatar ?? '', bio ?? ''];
}
