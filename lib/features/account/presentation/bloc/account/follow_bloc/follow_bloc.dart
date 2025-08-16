import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_other_account_follow_use_case.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final ToggleOAccountFollowUseCase toggleOAccountFollow;
  FollowBloc({required this.toggleOAccountFollow}) : super(FollowInitial()) {
    on<FollowEvent>((event, emit) async {
      if (event is ToggleFollowEvent) {
        emit(LoadingFollowState());
        final either = await toggleOAccountFollow(
          newStatus: event.newStatus,
          targetId: event.targetId,
        );
        either.fold(
          (failure) => emit(FailedFollowState(failure: failure)),
          (newStatus) => emit(DoneFollowState(newStatus: newStatus)),
        );
      }
    });
  }
}
