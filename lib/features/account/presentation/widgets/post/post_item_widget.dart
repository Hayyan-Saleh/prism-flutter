import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/cached_network_video.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';

class PostItemWidget extends StatefulWidget {
  final PostEntity post;
  final int currentUserId;

  const PostItemWidget({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  State<PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  late bool _isLiked;
  late bool _isSaved;
  late int _commentsCount;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isLiked = widget.post.isLiked;
    _isSaved = widget.post.isSaved;
    _commentsCount = widget.post.commentsCount;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _onEdit() {
    Navigator.pushNamed(context, AppRoutes.createPostPage);
  }

  Future<void> _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      context.read<PostBloc>().add(
        DeletePost(postId: widget.post.id, userId: widget.post.user.id),
      );
    }
  }

  void _toggleLike() {
    context.read<PostBloc>().add(TogglePostLike(postId: widget.post.id));
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleMedia = widget.post.media.length > 1;
    final isOwner = widget.post.user.id == widget.currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ProfilePicture(
                  link: widget.post.user.avatar,
                  radius: 20,
                  hasStatus: false,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(widget.post.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _onEdit();
                    } else if (value == 'delete') {
                      _onDelete();
                    }
                  },
                  itemBuilder:
                      (context) =>
                          isOwner
                              ? [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit Post'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete Post'),
                                ),
                              ]
                              : [
                                const PopupMenuItem(
                                  value: 'cancel',
                                  child: Text('Cancel'),
                                ),
                              ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.post.text != null && widget.post.text!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 50, bottom: 8, top: 8),
                child: Text(widget.post.text!),
              ),
            if (widget.post.media.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 50, top: 8, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: widget.post.media.length,
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemBuilder: (context, index) {
                            final media = widget.post.media[index];
                            if (media.type == MediaType.image) {
                              return CustomCachedNetworkImage(
                                imageUrl: media.url,
                                isRounded: false,
                                radius: 0,
                              );
                            } else {
                              return CachedNetworkVideo(
                                videoUrl: media.url,
                                showControls: true,
                              );
                            }
                          },
                        ),
                        if (hasMultipleMedia)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_currentPage + 1} / ${widget.post.media.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : null,
                    ),
                    onPressed: _toggleLike,
                  ),
                  Text(
                    '${widget.post.likesCount + (_isLiked && !widget.post.isLiked ? 1 : 0) - (!_isLiked && widget.post.isLiked ? 1 : 0)}',
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.mode_comment_outlined),
                    onPressed: () async {
                      final updatedCommentsCount =
                          await Navigator.pushNamed(
                                context,
                                AppRoutes.commentsPage,
                                arguments: {
                                  'postId': widget.post.id,
                                  'currentUserId': widget.currentUserId,
                                  'post': widget.post,
                                },
                              )
                              as int?;

                      if (updatedCommentsCount != null) {
                        setState(() {
                          _commentsCount = updatedCommentsCount;
                        });
                      }
                    },
                  ),
                  Text('$_commentsCount'),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: _isSaved ? Colors.blue : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSaved = !_isSaved;
                      });
                      if (_isSaved) {
                        context.read<PostBloc>().add(
                          PostSave(postId: widget.post.id),
                        );
                      } else {
                        context.read<PostBloc>().add(
                          PostUnsave(postId: widget.post.id),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
