import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_role.dart';
import 'package:prism/features/account/domain/use-cases/account/update_group_member_role_usecase.dart';

part 'update_group_member_role_event.dart';
part 'update_group_member_role_state.dart';

class UpdateGroupMemberRoleBloc
    extends Bloc<UpdateGroupMemberRoleEvent, UpdateGroupMemberRoleState> {
  final UpdateGroupMemberRoleUseCase updateGroupMemberRoleUseCase;

  UpdateGroupMemberRoleBloc({required this.updateGroupMemberRoleUseCase})
    : super(UpdateGroupMemberRoleInitial()) {
    on<UpdateRole>((event, emit) async {
      emit(UpdateGroupMemberRoleLoading());
      final failureOrSuccess = await updateGroupMemberRoleUseCase(
        UpdateGroupMemberRoleParams(
          groupId: event.groupId,
          userId: event.userId,
          role: event.role,
        ),
      );
      failureOrSuccess.fold(
        (failure) => emit(UpdateGroupMemberRoleFailure(failure: failure)),
        (_) => emit(UpdateGroupMemberRoleSuccess()),
      );
    });
  }
}
