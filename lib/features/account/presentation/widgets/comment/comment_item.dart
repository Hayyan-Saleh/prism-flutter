import 'package:flutter/material.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final int depth;
  final bool isRepliesVisible; // إضافة جديدة
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReply;
  final VoidCallback? onShowReplies;

  const CommentItem({
    super.key,
    required this.comment,
    this.depth = 0,
    this.isRepliesVisible = false, // القيمة الافتراضية
    this.onLike,
    this.onDelete,
    this.onEdit,
    this.onReply,
    this.onShowReplies,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double horizontalPadding = 12 + (depth > 2 ? 2 * 16.0 : depth * 16.0);

    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: horizontalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfilePicture(link: comment.user.avatar, radius: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم + الوقت
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.user.fullName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _fmtDate(comment.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // النص
                    Text(comment.text, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 8),

                    // أزرار التفاعل
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          onPressed: onLike,
                          icon: Icon(
                            comment.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        ),
                        Text('${comment.likesCount}'),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: onReply,
                          icon: const Icon(Icons.reply_outlined, size: 20),
                        ),
                        const SizedBox(width: 4),
                        Text('${comment.repliesCount}'),
                        const Spacer(),
                        if (onEdit != null)
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, size: 20),
                          ),
                        if (onDelete != null)
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete_outline, size: 20),
                          ),
                      ],
                    ),

                    // زر عرض الردود - يظهر فقط إذا كانت الردود غير ظاهرة
                    if (comment.repliesCount > 0 && !isRepliesVisible)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextButton(
                          onPressed: onShowReplies,
                          child: Text(
                            'Show ${comment.repliesCount} replies',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }
}
