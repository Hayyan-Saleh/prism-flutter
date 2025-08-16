import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/use-cases/account/check_account_name_usecase.dart';

part 'account_name_event.dart';
part 'account_name_state.dart';

class AccountNameBloc extends Bloc<AccountNameEvent, AccountNameState> {
  final CheckAccountNameUsecase checkAccountName;
  Timer? _debounceTimer;

  AccountNameBloc({required this.checkAccountName})
    : super(AccountNameInitial()) {
    on<AccountNameEvent>(_onCheckAccountName, transformer: restartable());
  }

  Future<void> _onCheckAccountName(
    AccountNameEvent event,
    Emitter<AccountNameState> emit,
  ) async {
    if (event is CheckAccountNameEvent) {
      _debounceTimer?.cancel();
      emit(LoadingAccountNameState());
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {});
      await Future.delayed(const Duration(milliseconds: 500));
      if (_debounceTimer!.isActive) return;

      final result = await checkAccountName(accountName: event.accountName);
      result.fold(
        (failure) => emit(FailedAccountNameState(failure: failure)),
        (isAvailable) => emit(
          isAvailable
              ? AvailableAccountNameState()
              : UnavailableAccountNameState(),
        ),
      );
    } else if (event is ResetEvent) {
      emit(AccountNameInitial());
    }
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    await super.close();
  }
}
