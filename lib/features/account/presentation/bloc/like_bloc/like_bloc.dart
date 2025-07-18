import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/use-cases/account/toggle_like_status_usecase.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final ToggleLikeStatusUseCase toggleLikeStatusUseCase;

  LikeBloc({
    required this.toggleLikeStatusUseCase,
    required bool isLiked,
    required int likesCount,
  }) : super(LikeInitial(isLiked: isLiked, likesCount: likesCount)) {
    on<ToggleLikeEvent>(_onToggleLike);
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<LikeState> emit,
  ) async {
    emit(LikeInProgress(isLiked: state.isLiked, likesCount: state.likesCount));
    final result = await toggleLikeStatusUseCase(event.statusId);
    result.fold(
      (failure) => emit(
        LikeFailure(
          failure.message,
          isLiked: state.isLiked,
          likesCount: state.likesCount,
        ),
      ),
      (_) {
        final newLikesCount =
            state.isLiked ? state.likesCount - 1 : state.likesCount + 1;
        emit(LikeSuccess(isLiked: !state.isLiked, likesCount: newLikesCount));
      },
    );
  }
}
