import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/notification/follow_request_entity.dart';
import 'package:prism/features/account/domain/use-cases/notification/get_follow_requests_usecase.dart';
import 'package:prism/features/account/domain/use-cases/notification/respond_to_follow_request_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetFollowRequestsUseCase getFollowRequestsUseCase;
  final RespondToFollowRequestUseCase respondToFollowRequestUseCase;

  NotificationBloc({
    required this.getFollowRequestsUseCase,
    required this.respondToFollowRequestUseCase,
  }) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {
      if (event is GetFollowRequestsEvent) {
        emit(NotificationLoading());
        final result = await getFollowRequestsUseCase();
        result.fold(
          (failure) => emit(NotificationError(message: failure.message)),
          (requests) => emit(NotificationLoaded(followRequests: requests)),
        );
      } else if (event is RespondToFollowRequestEvent) {
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
    });
  }
}
