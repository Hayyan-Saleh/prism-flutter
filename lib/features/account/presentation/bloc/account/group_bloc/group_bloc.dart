import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/account/group/group_account_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/create_group_usecase.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase createGroupUseCase;
  GroupBloc({required this.createGroupUseCase}) : super(GroupInitial()) {
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
  }
}
