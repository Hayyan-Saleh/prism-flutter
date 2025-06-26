import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_app/core/errors/failures.dart';
import 'package:your_app/core/usecases/usecase.dart';
import 'package:your_app/core/utils/constants.dart';
import 'package:your_app/features/comments/domain/entities/comment_entity.dart';
import 'package:your_app/features/comments/domain/usecases/add_comment.dart';
import 'package:your_app/features/comments/domain/usecases/delete_comment.dart';
import 'package:your_app/features/comments/domain/usecases/get_comments.dart';
import 'package:your_app/features/comments/domain/usecases/like_comment.dart';
import 'package:your_app/features/comments/domain/usecases/unlike_comment.dart';
import 'package:your_app/features/comments/domain/usecases/update_comment.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments getComments;
  final AddComment addComment;
  final UpdateComment updateComment;
  final DeleteComment deleteComment;
  final LikeComment likeComment;
  final UnlikeComment unlikeComment;
  
  CommentBloc({
    required this.getComments,
    required this.addComment,
    required this.updateComment,
    required this.deleteComment,
    required this.likeComment,
    required this.unlikeComment,
  }) : super(CommentInitial()) {
    on<LoadComments>(_onLoadComments);
    on<AddComment>(_onAddComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
    on<LikeComment>(_onLikeComment);
    on<UnlikeComment>(_onUnlikeComment);
  }
  
  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    
    final result = await getComments(GetCommentsParams(postId: event.postId));
    
    result.fold(
      (failure) => emit(CommentError(_mapFailureToMessage(failure))),
      (comments) => emit(CommentLoaded(comments)),
    );
  }
  
  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is CommentLoaded) {
      final newComment = CommentEntity(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        postId: event.postId,
        userId: Constants.currentUserId,
        content: event.content,
        createdAt: DateTime.now(),
        likes: [],
        parentCommentId: event.parentCommentId,
      );
      
      emit(CommentLoaded([newComment, ...currentState.comments]));
      
      final result = await addComment(newComment);
      
      result.fold(
        (failure) {
          emit(CommentError(_mapFailureToMessage(failure)));
          emit(CommentLoaded(currentState.comments));
        },
        (addedComment) {
          emit(CommentOperationSuccess('Comment added successfully'));
          add(LoadComments(event.postId, refresh: true));
        },
      );
    }
  }
  
  Future<void> _onUpdateComment(
    UpdateComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is CommentLoaded) {
      final commentToUpdate = currentState.comments.firstWhere(
        (comment) => comment.id == event.commentId,
      );
      
      final updatedComment = commentToUpdate.copyWith(content: event.newContent);
      
      final updatedComments = currentState.comments.map((comment) {
        return comment.id == event.commentId ? updatedComment : comment;
      }).toList();
      
      emit(CommentLoaded(updatedComments));
      
      final result = await updateComment(updatedComment);
      
      result.fold(
        (failure) {
          emit(CommentError(_mapFailureToMessage(failure)));
          emit(CommentLoaded(currentState.comments));
        },
        (_) => emit(CommentOperationSuccess('Comment updated successfully')),
      );
    }
  }
  
  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is CommentLoaded) {
      final updatedComments = currentState.comments
          .where((comment) => comment.id != event.commentId)
          .toList();
      
      emit(CommentLoaded(updatedComments));
      
      final result = await deleteComment(event.commentId);
      
      result.fold(
        (failure) {
          emit(CommentError(_mapFailureToMessage(failure)));
          emit(CommentLoaded(currentState.comments));
        },
        (_) => emit(CommentOperationSuccess('Comment deleted successfully')),
      );
    }
  }
  
  Future<void> _onLikeComment(
    LikeComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is CommentLoaded) {
      final updatedComments = currentState.comments.map((comment) {
        if (comment.id == event.commentId) {
          return comment.copyWith(
            likes: [...comment.likes, event.userId],
          );
        }
        return comment;
      }).toList();
      
      emit(CommentLoaded(updatedComments));
      
      final result = await likeComment(
        LikeCommentParams(
          commentId: event.commentId,
          userId: event.userId,
        ),
      );
      
      result.fold(
        (failure) {
          emit(CommentError(_mapFailureToMessage(failure)));
          emit(CommentLoaded(currentState.comments));
        },
        (_) => emit(CommentOperationSuccess('Comment liked successfully')),
      );
    }
  }
  
  Future<void> _onUnlikeComment(
    UnlikeComment event,
    Emitter<CommentState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is CommentLoaded) {
      final updatedComments = currentState.comments.map((comment) {
        if (comment.id == event.commentId) {
          return comment.copyWith(
            likes: comment.likes.where((id) => id != event.userId).toList(),
          );
        }
        return comment;
      }).toList();
      
      emit(CommentLoaded(updatedComments));
      
      final result = await unlikeComment(
        UnlikeCommentParams(
          commentId: event.commentId,
          userId: event.userId,
        ),
      );
      
      result.fold(
        (failure) {
          emit(CommentError(_mapFailureToMessage(failure)));
          emit(CommentLoaded(currentState.comments));
        },
        (_) => emit(CommentOperationSuccess('Comment unliked successfully')),
      );
    }
  }
  
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case NoConnectionFailure:
        return 'No internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }
}