import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/account/main/group_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/create_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/delete_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_group_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_group_usecase.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase createGroupUseCase;
  final GetGroupUseCase getGroupUseCase;
  final UpdateGroupUseCase updateGroupUseCase;
  final DeleteGroupUseCase deleteGroupUseCase;

  GroupBloc({
    required this.createGroupUseCase,
    required this.getGroupUseCase,
    required this.updateGroupUseCase,
    required this.deleteGroupUseCase,
  }) : super(GroupInitial()) {
    on<CreateGroupEvent>((event, emit) async {
      emit(GroupCreateLoading());
      final result = await createGroupUseCase(
        name: event.name,
        privacy: event.privacy,
        avatar: event.avatar,
        bio: event.bio,
      );
      result.fold(
        (failure) => emit(GroupCreateFailure(failure.message)),
        (group) => emit(GroupCreateSuccess(group)),
      );
    });

    on<GetGroupEvent>((event, emit) async {
      emit(GroupLoading());
      final result = await getGroupUseCase(groupId: event.groupId);
      result.fold(
        (failure) => emit(GroupFailure(failure.message)),
        (group) => emit(GroupLoaded(group)),
      );
    });

    on<UpdateGroupEvent>((event, emit) async {
      emit(GroupLoading());
      final result = await updateGroupUseCase(
        groupId: event.groupId,
        name: event.name,
        privacy: event.privacy,
        avatar: event.avatar,
        bio: event.bio,
      );
      result.fold(
        (failure) => emit(GroupUpdateFailure(failure.message)),
        (_) => emit(GroupUpdateSuccess()),
      );
    });

    on<DeleteGroup>((event, emit) async {
      emit(GroupDeleteInProgress());
      final result = await deleteGroupUseCase(groupId: event.groupId);
      result.fold(
        (failure) => emit(GroupDeleteFailure(failure.message)),
        (_) => emit(GroupDeleteSuccess()),
      );
    });
  }
}
