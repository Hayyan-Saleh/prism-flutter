import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/enitities/notification/join_request_entity.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_follow_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_join_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_follow_request_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_join_request_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetFollowRequestsUseCase getFollowRequestsUseCase;
  final RespondToFollowRequestUseCase respondToFollowRequestUseCase;
  final GetJoinRequestsUseCase getJoinRequestsUseCase;
  final RespondToJoinRequestUseCase respondToJoinRequestUseCase;

  NotificationBloc({
    required this.getFollowRequestsUseCase,
    required this.respondToFollowRequestUseCase,
    required this.getJoinRequestsUseCase,
    required this.respondToJoinRequestUseCase,
  }) : super(NotificationInitial()) {
    on<GetFollowRequestsEvent>(_onGetFollowRequests);
    on<RespondToFollowRequestEvent>(_onRespondToFollowRequest);
    on<GetJoinRequestsEvent>(_onGetJoinRequests);
    on<RespondToJoinRequestEvent>(_onRespondToJoinRequest);
  }

  Future<void> _onGetFollowRequests(
    GetFollowRequestsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getFollowRequestsUseCase();
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (requests) => emit(NotificationLoaded(followRequests: requests)),
    );
  }

  Future<void> _onRespondToFollowRequest(
    RespondToFollowRequestEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await respondToFollowRequestUseCase(
      RespondToFollowRequestParams(
        requestId: event.requestId,
        response: event.response,
      ),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) {
        emit(FollowRequestResponseSuccess());
        add(GetFollowRequestsEvent());
      },
    );
  }

  Future<void> _onGetJoinRequests(
    GetJoinRequestsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getJoinRequestsUseCase();
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (requests) => emit(JoinRequestsLoaded(joinRequests: requests)),
    );
  }

  Future<void> _onRespondToJoinRequest(
    RespondToJoinRequestEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await respondToJoinRequestUseCase(
      RespondToJoinRequestParams(
        groupId: event.groupId,
        requestId: event.requestId,
        response: event.response,
      ),
    );
    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (_) {
        emit(JoinRequestResponseSuccess());
        add(GetJoinRequestsEvent());
      },
    );
  }
}
