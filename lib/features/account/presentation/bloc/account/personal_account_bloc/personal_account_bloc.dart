import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/app_failure.dart';
import 'package:prism/core/util/constants/strings.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/use-cases/account/get_local_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/get_remote_personal_account_usecase.dart';
import 'package:prism/features/account/domain/use-cases/account/update_personal_account_usecase.dart';
import 'package:prism/features/auth/presentation/BLoC/auth_bloc/auth_bloc.dart';

part 'personal_account_event.dart';
part 'personal_account_state.dart';

class PAccountBloc extends Bloc<PAccountEvent, PAccountState> {
  final GetLocalPersonalAccountUsecase getLocalPersonalAccount;
  final GetRemotePersonalAccountUsecase getRemotePersonalAccount;
  final UpdatePersonalAccountUsecase updatePersonalAccount;
  PAccountBloc({
    required this.getLocalPersonalAccount,
    required this.getRemotePersonalAccount,
    required this.updatePersonalAccount,
  }) : super(AccountInitial()) {
    on<PAccountEvent>((event, emit) async {
      if (event is DefinePAccountCurrentStateEvent) {
        emit(LoadingPAccountState());

        PersonalAccountEntity? loadedLocalePersonalAccount;
        final loadedLocalRes = await getLocalPersonalAccount();
        loadedLocalRes.fold(
          (failure) => emit,
          (loadedLocalePersonal) =>
              loadedLocalePersonalAccount = loadedLocalePersonal,
        );
        if (loadedLocalePersonalAccount != null) {
          emit(
            LoadedPAccountState(personalAccount: loadedLocalePersonalAccount!),
          );
        } else {
          await _loadRemotePAccount(emit);
        }
      } else if (event is LoadRemotePAccountEvent) {
        await _loadRemotePAccount(emit);
      } else if (event is UpdatePAccountEvent) {
        emit(LoadingPAccountState());

        final either = await updatePersonalAccount(
          personalAccount: event.personalAccount,
          profilePic: event.profilePic,
        );

        either.fold(
          (failure) => FailedAuthState(failure: failure),
          (_) => emit(DoneUpdatePAccountState()),
        );
      }
    }, transformer: restartable());
  }

  Future<void> _loadRemotePAccount(Emitter<PAccountState> emit) async {
    emit(LoadingPAccountState());
    final loadedRemoteRes = await getRemotePersonalAccount();
    loadedRemoteRes.fold(
      (failure) {
        if (failure.message == AccountErrorMessages.accountNotFound) {
          emit(PAccountNotCreatedState());
        } else {
          emit(FailedPAccountState(failure: failure));
        }
      },
      (loadedRemotePersonal) =>
          emit(LoadedPAccountState(personalAccount: loadedRemotePersonal)),
    );
  }
}
