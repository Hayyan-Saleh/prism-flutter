import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';
import 'package:prism/features/account/presentation/widgets/post/post_item_widget.dart';

class PostsListWidget extends StatefulWidget {
  final List<PostEntity> posts;
  final String? emptyMessage;
  final String? errorMessage;
  final bool showLoadingIndicator;

  const PostsListWidget({
    super.key,
    required this.posts,
    this.emptyMessage = 'No posts available.',
    this.errorMessage = 'An error occurred. Please try again.',
    this.showLoadingIndicator = true,
  });

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_resetLoadingOnScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetLoadingOnScroll() {
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 120) {
      if (isLoading) setState(() => isLoading = false);
    }
  }

  Widget _buildLoading() =>
      widget.showLoadingIndicator && isLoading
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink();

  Widget _buildError(String message) => Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );

  Widget _buildEmpty(String message) => Center(child: Text(message));

  void _maybeLoadMorePosts(BuildContext context, PostState postState, dynamic paginatedPosts, int currentUserId) {
    if (!isLoading && paginatedPosts != null) {
      // استخدم addPostFrameCallback لتأجيل setState بعد انتهاء البناء الحالي
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => isLoading = true);

        final nextPage = paginatedPosts.pagination.currentPage + 1;
        if (postState is PersonalPostsLoadedSuccess) {
          context.read<PostBloc>().add(
            LoadPersonalPosts(
                userId: currentUserId,
                pageNum: nextPage,
            ),
          );
        } else if (postState is FeedPostsLoadedSuccess) {
          context.read<PostBloc>().add(
            LoadFeedPosts(pageNum: nextPage),
          );
        } else if (postState is SavedPostsLoadedSuccess) {
          context.read<PostBloc>().add(
            LoadSavedPosts(pageNum: nextPage),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PAccountBloc, PAccountState>(
      builder: (context, accountState) {
        if (accountState is LoadingPAccountState) {
          return _buildLoading();
        }

        if (accountState is LoadedPAccountState) {
          final currentUserId = accountState.personalAccount.id;

          return BlocBuilder<PostBloc, PostState>(
            builder: (context, postState) {
              dynamic paginatedPosts;
              bool canLoadMore = false;

              if (postState is PersonalPostsLoadedSuccess ||
                  postState is FeedPostsLoadedSuccess ||
                  postState is SavedPostsLoadedSuccess) {
                paginatedPosts = postState is PersonalPostsLoadedSuccess
                    ? postState.paginatedPosts
                    : postState is FeedPostsLoadedSuccess
                        ? postState.paginatedPosts
                        : postState is SavedPostsLoadedSuccess
                            ? postState.paginatedPosts
                            : null;

                if (paginatedPosts != null) {
                  canLoadMore = paginatedPosts.pagination.currentPage < paginatedPosts.pagination.lastPage;
                }
              }

              final posts = widget.posts;

              if (postState is PostLoading && !isLoading) {
                return _buildLoading();
              }
              if (postState is PostError) {
                return _buildError(postState.failure.message);
              }
              if (paginatedPosts == null) {
                return const SizedBox.shrink();
              }
              if (posts.isEmpty) {
                return _buildEmpty(widget.emptyMessage!);
              }

              return ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: posts.length + (canLoadMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == posts.length && canLoadMore) {
                    _maybeLoadMorePosts(context, postState, paginatedPosts, currentUserId);
                    return _buildLoading();
                  }

                  final post = posts[index];
                  return PostItemWidget(
                    post: post,
                    currentUserId: currentUserId,
                  );
                },
              );
            },
          );
        }

        return const Center(child: Text('User data not uploaded'));
      },
    );
  }
}
