import 'dart:async';
import 'dart:io';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prism/features/account/domain/enitities/post/post_pagination_entity.dart';
import 'package:prism/features/account/domain/use-cases/post/add_post_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/delete_post_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/get_personal_posts_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/get_feed_posts_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/get_saved_posts_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/toggle_like_post_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/save_post_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/unsave_post_usecase.dart';
import 'package:prism/features/account/domain/use-cases/post/update_post_usecase.dart';
import 'package:prism/core/errors/failures/account_failure.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPersonalPostsUseCase getPersonalPostsUseCase;
  final GetSavedPostsUseCase getSavedPostsUseCase;
  final AddPostUseCase addPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final ToggleLikePostUseCase toggleLikePostUseCase;
  final SavePostUseCase savePostUseCase;
  final UnsavePostUseCase unsavePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final GetFeedPostsUseCase getFeedPostsUseCase;

  PostBloc({
    required this.getPersonalPostsUseCase,
    required this.getSavedPostsUseCase,
    required this.addPostUseCase,
    required this.updatePostUseCase,
    required this.toggleLikePostUseCase,
    required this.savePostUseCase,
    required this.unsavePostUseCase,
    required this.deletePostUseCase,
    required this.getFeedPostsUseCase,
  }) : super(PostInitial()) {
    on<LoadFeedPosts>(_onLoadFeedPosts, transformer: droppable());
    on<LoadPersonalPosts>(_onLoadPersonalPosts, transformer: droppable());
    on<LoadSavedPosts>(_onLoadSavedPosts);
    on<AddNewPost>(_onAddNewPost);
    on<UpdateExistingPost>(_onUpdateExistingPost);
    on<TogglePostLike>(_onTogglePostLike);
    on<PostSave>(_onPostSave);
    on<PostUnsave>(_onPostUnsave);
    on<DeletePost>(_onDeletePost);
  }

  Future<void> _onLoadFeedPosts(
    LoadFeedPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    final result = await getFeedPostsUseCase(pageNum: event.pageNum);
    result.fold((failure) => emit(PostError(failure: failure)), (
      paginatedPosts,
    ) {
      if (state is FeedPostsLoadedSuccess) {
        final currentState = state as FeedPostsLoadedSuccess;
        final updatedPosts = [
          ...currentState.paginatedPosts.posts,
          ...paginatedPosts.posts,
        ];

        final updatedPagination = currentState.paginatedPosts.copyWith(
          posts: updatedPosts,
        );
        emit(FeedPostsLoadedSuccess(paginatedPosts: updatedPagination));
      } else {
        emit(FeedPostsLoadedSuccess(paginatedPosts: paginatedPosts));
      }
    });
  }

  Future<void> _onLoadPersonalPosts(
    LoadPersonalPosts event,
    Emitter<PostState> emit,
  ) async {
    if (state is PostInitial || state is PostLoading) {
      emit(PostLoading());
    }

    final result = await getPersonalPostsUseCase(
      accountId: event.userId,
      pageNum: event.pageNum,
    );

    result.fold(
      (failure) {
        emit(PostError(failure: failure));
      },
      (paginatedPosts) {
        if (state is PersonalPostsLoadedSuccess) {
          final currentState = state as PersonalPostsLoadedSuccess;
          final updatedPosts = [
            ...currentState.paginatedPosts.posts,
            ...paginatedPosts.posts.where(
              (newPost) =>
                  !currentState.paginatedPosts.posts.any(
                    (existingPost) => existingPost.id == newPost.id,
                  ),
            ),
          ];

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );

          emit(PersonalPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else {
          emit(PersonalPostsLoadedSuccess(paginatedPosts: paginatedPosts));
        }
      },
    );
  }

  Future<void> _onLoadSavedPosts(
    LoadSavedPosts event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    final result = await getSavedPostsUseCase(pageNum: event.pageNum);
    result.fold(
      (failure) {
        emit(PostError(failure: failure));
      },
      (paginatedPosts) {
        // لاحظ: paginatedPosts هو PaginatedPostsEntity وليس فقط قائمة
        emit(SavedPostsLoadedSuccess(paginatedPosts: paginatedPosts));
      },
    );
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await deletePostUseCase(postId: event.postId);
    result.fold((failure) => emit(PostError(failure: failure)), (_) {
      emit(const PostOperationSuccess(message: "Post deleted successfully!"));
      // إعادة تحميل المنشورات من الصفحة الأولى
      add(LoadPersonalPosts(userId: event.userId, pageNum: 1));
    });
  }

  Future<void> _onUpdateExistingPost(
    UpdateExistingPost event,
    Emitter<PostState> emit,
  ) async {
    emit(PostLoading());
    final result = await updatePostUseCase(
      postId: event.postId,
      text: event.text,
      privacy: event.privacy,
      mediaFiles: event.mediaFiles,
      removedMediaIds: event.removedMediaIds,
    );
    result.fold((failure) => emit(PostError(failure: failure)), (_) {
      emit(const PostOperationSuccess(message: "Post updated successfully!"));
      // إعادة تحميل المنشورات من الصفحة الأولى بعد التعديل
      add(LoadPersonalPosts(userId: event.userId, pageNum: 1));
    });
  }

  Future<void> _onAddNewPost(AddNewPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    final result = await addPostUseCase(
      text: event.text,
      privacy: event.privacy,
      groupId: event.groupId,
      mediaPaths: event.mediaPaths,
    );
    result.fold(
      (failure) => emit(PostError(failure: failure)),
      (_) =>
          emit(const PostOperationSuccess(message: "Post added successfully!")),
    );
  }

  Future<void> _onTogglePostLike(
    TogglePostLike event,
    Emitter<PostState> emit,
  ) async {
    if (state is FeedPostsLoadedSuccess ||
        state is PersonalPostsLoadedSuccess ||
        state is SavedPostsLoadedSuccess) {
      final currentState = state;
      final result = await toggleLikePostUseCase(postId: event.postId);
      result.fold((failure) => emit(PostError(failure: failure)), (_) {
        if (currentState is FeedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(
                    isLiked: !post.isLiked,
                    likesCount:
                        post.isLiked
                            ? post.likesCount - 1
                            : post.likesCount + 1,
                  );
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(FeedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is PersonalPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(
                    isLiked: !post.isLiked,
                    likesCount:
                        post.isLiked
                            ? post.likesCount - 1
                            : post.likesCount + 1,
                  );
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(PersonalPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is SavedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(
                    isLiked: !post.isLiked,
                    likesCount:
                        post.isLiked
                            ? post.likesCount - 1
                            : post.likesCount + 1,
                  );
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(SavedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        }
      });
    }
  }

  Future<void> _onPostSave(PostSave event, Emitter<PostState> emit) async {
    if (state is FeedPostsLoadedSuccess ||
        state is PersonalPostsLoadedSuccess ||
        state is SavedPostsLoadedSuccess) {
      final currentState = state;
      final result = await savePostUseCase(postId: event.postId);
      result.fold((failure) => emit(PostError(failure: failure)), (_) {
        if (currentState is FeedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: true);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(FeedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is PersonalPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: true);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(PersonalPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is SavedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: true);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(SavedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        }
      });
    }
  }

  Future<void> _onPostUnsave(PostUnsave event, Emitter<PostState> emit) async {
    if (state is FeedPostsLoadedSuccess ||
        state is PersonalPostsLoadedSuccess ||
        state is SavedPostsLoadedSuccess) {
      final currentState = state;
      final result = await unsavePostUseCase(postId: event.postId);
      result.fold((failure) => emit(PostError(failure: failure)), (_) {
        if (currentState is FeedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: false);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(FeedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is PersonalPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: false);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(PersonalPostsLoadedSuccess(paginatedPosts: updatedPagination));
        } else if (currentState is SavedPostsLoadedSuccess) {
          final updatedPosts =
              currentState.paginatedPosts.posts.map((post) {
                if (post.id == event.postId) {
                  return post.copyWith(isSaved: false);
                }
                return post;
              }).toList();

          final updatedPagination = currentState.paginatedPosts.copyWith(
            posts: updatedPosts,
          );
          emit(SavedPostsLoadedSuccess(paginatedPosts: updatedPagination));
        }
      });
    }
  }
}
