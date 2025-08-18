import 'package:flutter/material.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart'; // استورد PostEntity
import 'package:prism/features/account/presentation/widgets/comment/comment_item.dart';
import 'package:prism/features/account/presentation/widgets/post/post_item_widget.dart'; // لاستعمال PostItemWidget

class CommentList extends StatefulWidget {
  final List<CommentEntity> comments;
  final PostEntity? post; // إضافة المنشور كاختياري
  final int? currentUserId; // لتمرير currentUserId إلى PostItemWidget
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final void Function(CommentEntity comment)? onLike;
  final void Function(CommentEntity comment)? onDelete;
  final void Function(CommentEntity comment)? onEdit;
  final void Function(CommentEntity comment)? onReply; // لإضافة رد
  final void Function(CommentEntity comment)? onShowReplies; // لتوسيع الردود

  const CommentList({
    super.key,
    required this.comments,
    this.post,
    this.currentUserId,
    this.onRefresh,
    this.onLoadMore,
    this.onLike,
    this.onDelete,
    this.onEdit,
    this.onReply,
    this.onShowReplies,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final _controller = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  void _handleScroll() async {
    if (widget.onLoadMore == null || _loadingMore) return;
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 100) {
      setState(() => _loadingMore = true);
      await widget.onLoadMore!();
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  // دالة مساعدة لبناء قائمة التعليقات والردود مع الإدارة الهيكلية (مستوى التداخل depth)
  List<Widget> _buildComments(List<CommentEntity> comments, int depth) {
    List<Widget> widgets = [];

    for (var comment in comments) {
      // تحديد ما إذا كانت الردود ظاهرة (إذا كان لديه ردود محملة)
      final isRepliesVisible = comment.replies.isNotEmpty;

      widgets.add(
        CommentItem(
          comment: comment,
          depth: depth,
          isRepliesVisible: isRepliesVisible, // تمرير الحالة
          onLike: widget.onLike != null ? () => widget.onLike!(comment) : null,
          onDelete:
              widget.onDelete != null ? () => widget.onDelete!(comment) : null,
          onEdit: widget.onEdit != null ? () => widget.onEdit!(comment) : null,
          
          onReply:
              widget.onReply != null ? () => widget.onReply!(comment) : null,
          onShowReplies:
              (comment.repliesCount > 0 && widget.onShowReplies != null)
                  ? () => widget.onShowReplies!(comment)
                  : null,
        ),
      );

      // عرض الردود المتداخلة إذا كانت موجودة
      if (comment.replies.isNotEmpty) {
        final nextDepth = (depth + 1) > 2 ? 2 : depth + 1;
        widgets.addAll(_buildComments(comment.replies, nextDepth));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final baseCommentsList = _buildComments(widget.comments, 0);

    // إضافة المنشور في البداية إن وجد
    final fullList = <Widget>[];
    if (widget.post != null) {
      fullList.add(
        PostItemWidget(
          post: widget.post!,
          currentUserId: widget.currentUserId ?? 0,
        ),
      );
    }
    fullList.addAll(baseCommentsList);

    // إضافة مؤشر التحميل في الأسفل إذا كان جاري تحميل المزيد
    if (_loadingMore) {
      fullList.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final listView = ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: fullList.length,
      itemBuilder: (context, index) => fullList[index],
    );

    if (widget.onRefresh != null) {
      return RefreshIndicator(onRefresh: widget.onRefresh!, child: listView);
    }
    return listView;
  }
}
