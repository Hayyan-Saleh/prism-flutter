import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/simplified/paginated_groups_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/explore_groups_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_owned_groups_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_followed_groups_usecase.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GetOwnedGroupsUseCase getOwnedGroupsUseCase;
  final GetFollowedGroupsUseCase getFollowedGroupsUseCase;
  final ExploreGroupsUseCase exploreGroupsUseCase;
  GroupsBloc({
    required this.getOwnedGroupsUseCase,
    required this.getFollowedGroupsUseCase,
    required this.exploreGroupsUseCase,
  }) : super(GroupsInitial()) {
    on<GetOwnedGroupsEvent>((event, emit) async {
      final currentState = state;
      if (event.page == 1) {
        emit(GroupsLoading());
      }
      final result = await getOwnedGroupsUseCase(page: event.page);
      result.fold((failure) => emit(GroupsFailure(failure.message)), (
        paginatedGroups,
      ) {
        if (currentState is GroupsLoaded) {
          final updatedGroups =
              currentState.paginatedGroups.groups + paginatedGroups.groups;
          emit(
            GroupsLoaded(
              PaginatedGroupsEntity(
                groups: updatedGroups,
                pagination: paginatedGroups.pagination,
              ),
            ),
          );
        } else {
          emit(GroupsLoaded(paginatedGroups));
        }
      });
    });

    on<GetFollowedGroupsEvent>((event, emit) async {
      final currentState = state;
      if (event.page == 1) {
        emit(GroupsLoading());
      }
      final result = await getFollowedGroupsUseCase(page: event.page);
      result.fold((failure) => emit(GroupsFailure(failure.message)), (
        paginatedGroups,
      ) {
        if (currentState is GroupsLoaded) {
          final updatedGroups =
              currentState.paginatedGroups.groups + paginatedGroups.groups;
          emit(
            GroupsLoaded(
              PaginatedGroupsEntity(
                groups: updatedGroups,
                pagination: paginatedGroups.pagination,
              ),
            ),
          );
        } else {
          emit(GroupsLoaded(paginatedGroups));
        }
      });
    });

    on<ExploreGroupsEvent>((event, emit) async {
      final currentState = state;
      if (event.page == 1) {
        emit(GroupsLoading());
      }
      final result = await exploreGroupsUseCase(page: event.page);
      result.fold((failure) => emit(GroupsFailure(failure.message)), (
        paginatedGroups,
      ) {
        if (currentState is GroupsLoaded) {
          final updatedGroups =
              currentState.paginatedGroups.groups + paginatedGroups.groups;
          emit(
            GroupsLoaded(
              PaginatedGroupsEntity(
                groups: updatedGroups,
                pagination: paginatedGroups.pagination,
              ),
            ),
          );
        } else {
          emit(GroupsLoaded(paginatedGroups));
        }
      });
    });

    on<GroupsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
