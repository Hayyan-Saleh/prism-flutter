import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/core/utils/constants.dart';
import 'package:your_app/features/comments/presentation/bloc/comment_bloc.dart';
import '../../domain/entities/comment_entity.dart';

class CommentCard extends StatelessWidget {
  final CommentEntity comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = Constants.currentUserId;
    final isCurrentUserComment = comment.userId == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=${comment.userId.hashCode % 70}',
                  ),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'User ${comment.userId.substring(0, 5)}',
                  style: Theme.of(
                    context,
                  ).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatTime(comment.createdAt),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(comment.content, style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    comment.isLikedByUser(currentUserId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        comment.isLikedByUser(currentUserId)
                            ? Colors.red
                            : null,
                  ),
                  onPressed: () {
                    if (comment.isLikedByUser(currentUserId)) {
                      context.read<CommentBloc>().add(
                        UnlikeComment(comment.id, currentUserId),
                      );
                    } else {
                      context.read<CommentBloc>().add(
                        LikeComment(comment.id, currentUserId),
                      );
                    }
                  },
                ),
                Text('${comment.likes.length}'),
                const Spacer(),
                if (isCurrentUserComment)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showEditDialog(context, comment),
                  ),
                if (isCurrentUserComment)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, comment.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showEditDialog(BuildContext context, CommentEntity comment) {
    final textController = TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Comment'),
            content: TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Edit your comment...',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    context.read<CommentBloc>().add(
                      UpdateComment(comment.id, textController.text.trim()),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Comment'),
            content: const Text(
              'Are you sure you want to delete this comment?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<CommentBloc>().add(DeleteComment(commentId));
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
