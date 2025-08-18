import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/enitities/comment/paginated_comment_entity.dart';
import 'package:prism/features/account/domain/use-cases/comment/add_comment_usecase.dart';
import 'package:prism/features/account/domain/use-cases/comment/delete_comment_usecase.dart';
import 'package:prism/features/account/domain/use-cases/comment/get_comments_usecase.dart';
import 'package:prism/core/errors/failures/account_failure.dart';
import 'package:prism/features/account/domain/use-cases/comment/toggle_like_comment_usecase.dart';
import 'package:prism/features/account/domain/use-cases/comment/update_comment_usecase.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetCommentsUseCase getComments;
  final AddCommentUseCase addComment;
  final UpdateCommentUseCase updateCommentUC;
  final DeleteCommentUseCase deleteCommentUC;
  final ToggleLikeCommentUseCase toggleLikeCommentUC;

  CommentBloc({
    required this.getComments,
    required this.addComment,
    required this.updateCommentUC,
    required this.deleteCommentUC,
    required this.toggleLikeCommentUC,
  }) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments, transformer: droppable());
    on<RefreshComments>(_onRefreshComments);
    on<AddCommentEvent>(_onAddComment);
    on<UpdateCommentEvent>(_onUpdateComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<ToggleLikeCommentEvent>(_onToggleLikeComment);
  }

  List<CommentEntity> _updateCommentRepliesRecursive(
    List<CommentEntity> comments,
    int targetCommentId,
    List<CommentEntity> newReplies,
  ) {
    return comments.map((comment) {
      if (comment.id == targetCommentId) {
        final existingReplies = List<CommentEntity>.from(comment.replies);

        for (final newReply in newReplies) {
          final exists = existingReplies.any(
            (existing) => existing.id == newReply.id,
          );
          if (!exists) {
            existingReplies.add(newReply);
          }
        }


        return comment.copyWith(
          replies: existingReplies,
          repliesCount: existingReplies.length,
          areRepliesVisible: true,
        );
      }

      if (comment.replies.isNotEmpty) {
        final updatedNestedReplies = _updateCommentRepliesRecursive(
          comment.replies,
          targetCommentId,
          newReplies,
        );

        bool hasChanged = false;
        if (updatedNestedReplies.length != comment.replies.length) {
          hasChanged = true;
        } else {
          for (int i = 0; i < updatedNestedReplies.length; i++) {
            if (updatedNestedReplies[i] != comment.replies[i]) {
              hasChanged = true;
              break;
            }
          }
        }

        if (hasChanged) {
          return comment.copyWith(replies: updatedNestedReplies);
        }
      }

      return comment;
    }).toList();
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {

    if (state is CommentInitial ||
        (state is CommentLoading && event.pageNum == 1)) {
      emit(CommentLoading());
    }

    final result = await getComments(
      pageNum: event.pageNum,
      postId: event.postId,
      adId: event.adId,
      commentId: event.commentId,
    );

    result.fold(
      (failure) {
        emit(CommentError(failure: failure));
      },
      (paginated) {
        if (state is CommentsLoaded) {
          final current = state as CommentsLoaded;

          if (event.commentId != null) {
            final updatedComments = _updateCommentRepliesRecursive(
              current.paginated.comments,
              event.commentId!,
              paginated.comments,
            );

            bool hasRealChange = false;
            if (updatedComments.length != current.paginated.comments.length) {
              hasRealChange = true;
            } else {
              for (int i = 0; i < updatedComments.length; i++) {
                if (updatedComments[i] != current.paginated.comments[i]) {
                  hasRealChange = true;
                  break;
                }
              }
            }

            if (hasRealChange) {
              final newPaginated = PaginatedCommentsEntity(
                comments: updatedComments,
                pagination: current.paginated.pagination,
              );

              emit(CommentsLoaded(paginated: newPaginated));
            }
          } else {
            // دمج التعليقات الرئيسية (pagination)
            final existingIds =
                current.paginated.comments.map((c) => c.id).toSet();
            final newComments =
                paginated.comments
                    .where((c) => !existingIds.contains(c.id))
                    .toList();

            if (newComments.isNotEmpty) {
              final merged = [...current.paginated.comments, ...newComments];

              final newPaginated = current.paginated.copyWith(
                comments: merged,
                pagination: paginated.pagination,
              );

              emit(CommentsLoaded(paginated: newPaginated));
            }
          }
        } else {
          emit(CommentsLoaded(paginated: paginated));
        }
      },
    );
  }

  Future<void> _onRefreshComments(
    RefreshComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());

    final result = await getComments(
      pageNum: 1,
      postId: event.postId,
      adId: event.adId,
      commentId: event.commentId,
    );

    result.fold(
      (failure) {
        emit(CommentError(failure: failure));
      },
      (paginated) {
        emit(CommentsLoaded(paginated: paginated));
      },
    );
  }

  List<CommentEntity> _addReplyToComment(
    List<CommentEntity> comments,
    int parentCommentId,
    CommentEntity newReply,
  ) {
    return comments.map((comment) {
      if (comment.id == parentCommentId) {
        final updatedReplies = [newReply, ...comment.replies];
        return comment.copyWith(
          replies: updatedReplies,
          repliesCount: comment.repliesCount + 1,
          areRepliesVisible: true,
        );
      }

      if (comment.replies.isNotEmpty) {
        final updatedNestedReplies = _addReplyToComment(
          comment.replies,
          parentCommentId,
          newReply,
        );

        if (updatedNestedReplies != comment.replies) {
          return comment.copyWith(replies: updatedNestedReplies);
        }
      }

      return comment;
    }).toList();
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CommentsLoaded) {
      final res = await addComment(
        text: event.text,
        commentableType: event.commentableType,
        commentableId: event.commentableId,
      );

      res.fold(
        (failure) => emit(CommentError(failure: failure)),
        (created) =>
            emit(CommentOperationSuccess('Comment added successfully')),
      );
      return;
    }

    final current = currentState.paginated;

    final res = await addComment(
      text: event.text,
      commentableType: event.commentableType,
      commentableId: event.commentableId,
    );

    res.fold((failure) => emit(CommentError(failure: failure)), (created) {
      List<CommentEntity> updatedComments;
      String successMessage;

      if (event.commentableType == 'Comment') {
        updatedComments = _addReplyToComment(
          current.comments,
          event.commentableId,
          created,
        );
        successMessage = 'Reply added successfully';
      } else {
        updatedComments = [created, ...current.comments];
        successMessage = 'Comment added successfully';
      }

      final newPaginated = current.copyWith(comments: updatedComments);

      emit(CommentOperationSuccess(successMessage, paginated: newPaginated));
      emit(CommentsLoaded(paginated: newPaginated));
    });
  }

  Future<void> _onUpdateComment(
    UpdateCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) return;

    final current = (state as CommentsLoaded).paginated;

    List<CommentEntity> updateCommentsText(List<CommentEntity> comments) {
      return comments.map((c) {
        if (c.id == event.id) {
          return c.copyWith(text: event.text);
        }
        if (c.replies.isNotEmpty) {
          return c.copyWith(replies: updateCommentsText(c.replies));
        }
        return c;
      }).toList();
    }

    final locallyUpdated = updateCommentsText(current.comments);
    final newPaginated = current.copyWith(comments: locallyUpdated);

    emit(CommentsLoaded(paginated: newPaginated));

    final res = await updateCommentUC(id: event.id, text: event.text);
    res.fold(
      (failure) {
        emit(CommentError(failure: failure));
        emit(CommentsLoaded(paginated: current)); // rollback
      },
      (serverUpdated) {
        List<CommentEntity> fixServerUpdated(List<CommentEntity> comments) {
          return comments.map((c) {
            if (c.id == serverUpdated.id) return serverUpdated;
            if (c.replies.isNotEmpty) {
              return c.copyWith(replies: fixServerUpdated(c.replies));
            }
            return c;
          }).toList();
        }

        final fixed = fixServerUpdated(locallyUpdated);
        final finalPaginated = current.copyWith(comments: fixed);
        emit(CommentsLoaded(paginated: finalPaginated));
      },
    );
  }

  Future<void> _onDeleteComment(
    DeleteCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) return;

    final current = (state as CommentsLoaded).paginated;

    List<CommentEntity> removeCommentById(
      List<CommentEntity> comments,
      int id,
    ) {
      return comments.where((c) => c.id != id).map((c) {
        if (c.replies.isNotEmpty) {
          return c.copyWith(replies: removeCommentById(c.replies, id));
        }
        return c;
      }).toList();
    }

    final filtered = removeCommentById(current.comments, event.id);
    final newPaginated = current.copyWith(comments: filtered);

    emit(CommentsLoaded(paginated: newPaginated));

    final res = await deleteCommentUC(id: event.id);
    res.fold(
      (failure) {
        emit(CommentError(failure: failure));
        emit(CommentsLoaded(paginated: current)); // rollback
      },
      (_) {
        emit(
          CommentOperationSuccess(
            'Comment deleted successfully',
            paginated: newPaginated,
          ),
        );
        emit(CommentsLoaded(paginated: newPaginated));
      },
    );
  }

  Future<void> _onToggleLikeComment(
    ToggleLikeCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    if (state is! CommentsLoaded) return;

    final current = (state as CommentsLoaded).paginated;

    List<CommentEntity> toggleLikeInComments(List<CommentEntity> comments) {
      return comments.map((c) {
        if (c.id == event.id) {
          final nowLiked = !c.isLiked;
          return c.copyWith(
            isLiked: nowLiked,
            likesCount: nowLiked ? c.likesCount + 1 : c.likesCount - 1,
          );
        }
        if (c.replies.isNotEmpty) {
          return c.copyWith(replies: toggleLikeInComments(c.replies));
        }
        return c;
      }).toList();
    }

    final locallyUpdated = toggleLikeInComments(current.comments);
    final newPaginated = current.copyWith(comments: locallyUpdated);

    emit(CommentsLoaded(paginated: newPaginated));

    final res = await toggleLikeCommentUC(commentId: event.id);
    res.fold(
      (failure) {
        emit(CommentError(failure: failure));
        emit(CommentsLoaded(paginated: current)); // rollback
      },
      (_) {
        emit(CommentsLoaded(paginated: newPaginated));
      },
    );
  }
}
