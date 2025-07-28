import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/join_status_enum.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_group_membership_usecase.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  final ToggleGroupMembershipUseCase toggleGroupMembershipUseCase;

  JoinGroupBloc({required this.toggleGroupMembershipUseCase}) : super(JoinGroupInitial()) {
    on<ToggleJoinGroupEvent>((event, emit) async {
      emit(JoinGroupLoading());
      final either = await toggleGroupMembershipUseCase(
        groupId: event.groupId,
        join: event.join,
      );
      either.fold(
        (failure) => emit(JoinGroupFailure(failure: failure)),
        (newStatus) => emit(JoinGroupSuccess(newStatus: newStatus)),
      );
    });
  }
}