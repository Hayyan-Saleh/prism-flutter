import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/features/account/domain/enitities/account/main/other_account_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/block_user_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_other_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/unblock_user_usecase.dart';

part 'other_account_event.dart';
part 'other_account_state.dart';

class OAccountBloc extends Bloc<OAccountEvent, OAccountState> {
  final GetOtherAccountUsecase getOtherAccount;
  final BlockUserUsecase blockUser;
  final UnblockUserUseCase unblockUser;
  OtherAccountEntity? oAccount;
  OAccountBloc({
    required this.getOtherAccount,
    required this.blockUser,
    required this.unblockUser,
  }) : super(OAccountInitial()) {
    on<OAccountEvent>((event, emit) async {
      if (event is LoadOAccountEvent) {
        emit(LoadingOAccountState());
        final loadedRemoteRes = await getOtherAccount(id: event.id);
        loadedRemoteRes.fold(
          (failure) => emit(FailedOAccountState(failure: failure)),
          (loadedOtherAccount) {
            oAccount = loadedOtherAccount;
            emit(LoadedOAccountState(otherAccount: loadedOtherAccount));
          },
        );
      } else if (event is BlockUserEvent) {
        emit(LoadingOAccountState());
        final either = await blockUser(event.targetId);
        either.fold(
          (failure) => emit(FailedOAccountState(failure: failure)),
          (_) => emit(UserBlockedState()),
        );
      } else if (event is UnblockUserEvent) {
        emit(LoadingOAccountState());
        final either = await unblockUser(targetId: event.targetId);
        either.fold((failure) => emit(FailedOAccountState(failure: failure)), (
          _,
        ) {
          !event.fromDetailedPage
              ? emit(UserUnblockedState())
              : add(LoadOAccountEvent(id: event.targetId));
        });
      }
    });
  }
}
