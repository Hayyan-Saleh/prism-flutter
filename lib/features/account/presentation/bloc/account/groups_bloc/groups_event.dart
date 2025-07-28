part of 'groups_bloc.dart';

sealed class GroupsEvent extends Equatable {
  const GroupsEvent();

  @override
  List<Object> get props => [];
}

class GetOwnedGroupsEvent extends GroupsEvent {
  final int page;

  const GetOwnedGroupsEvent({this.page = 1});
}

class GetFollowedGroupsEvent extends GroupsEvent {
  final int page;

  const GetFollowedGroupsEvent({this.page = 1});
}

class ExploreGroupsEvent extends GroupsEvent {
  final int page;

  const ExploreGroupsEvent({this.page = 1});
}
