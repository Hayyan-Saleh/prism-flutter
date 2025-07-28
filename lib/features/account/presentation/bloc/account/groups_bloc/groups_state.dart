part of 'groups_bloc.dart';

sealed class GroupsState extends Equatable {
  const GroupsState();

  @override
  List<Object> get props => [];
}

final class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final PaginatedGroupsEntity paginatedGroups;

  const GroupsLoaded(this.paginatedGroups);
}

class GroupsFailure extends GroupsState {
  final String message;

  const GroupsFailure(this.message);
}

class ExploreGroupsSuccess extends GroupsState {
  final PaginatedGroupsEntity paginatedGroups;

  const ExploreGroupsSuccess(this.paginatedGroups);

  @override
  List<Object> get props => [paginatedGroups];
}
