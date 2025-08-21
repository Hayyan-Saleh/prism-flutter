import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/widgets/custom_text_form_field.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/presentation/bloc/comment/comment_bloc.dart';
import 'package:prism/features/account/presentation/widgets/comment/comment_list.dart';
import 'package:prism/features/account/domain/enitities/comment/comment_entity.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  final PostEntity? post;
  final int? currentUserId;
  
  const CommentsPage({
    super.key,
    required this.postId,
    this.post,
    this.currentUserId,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  int _commentsCount = 0;
  int _currentPage = 1;
  int _lastPage = 1;
  CommentEntity? _replyingTo;

  @override
  void initState() {
    super.initState();
    _commentsCount = widget.post?.commentsCount ?? 0;
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    if (_replyingTo != null) {
      context.read<CommentBloc>().add(
        AddCommentEvent(
          text: text,
          commentableType: 'Comment',
          commentableId: _replyingTo!.id,
        ),
      );
    } else {
      context.read<CommentBloc>().add(
        AddCommentEvent(
          text: text,
          commentableType: 'Post',
          commentableId: widget.postId,
        ),
      );
    }
    setState(() {
      _replyingTo = null;
    });
  }

  Future<void> _loadMore() async {
    if (_currentPage < _lastPage) {
      final nextPage = _currentPage + 1;
      context.read<CommentBloc>().add(
        LoadComments(pageNum: nextPage, postId: widget.postId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Navigator.pop(context, _commentsCount);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Comments')),
        body: BlocConsumer<CommentBloc, CommentState>(
          listener: (context, state) {
            if (state is CommentOperationSuccess) {
              _controller.clear();
              if (state.paginated != null) {
                _commentsCount = state.paginated!.pagination.total;
                _currentPage = state.paginated!.pagination.currentPage;
                _lastPage = state.paginated!.pagination.lastPage;
              }
            } else if (state is CommentsLoaded) {
              _commentsCount = state.paginated.pagination.total;
              _currentPage = state.paginated.pagination.currentPage;
              _lastPage = state.paginated.pagination.lastPage;
            }
          },
          builder: (context, state) {
            if (state is CommentLoading || state is CommentInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CommentError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.failure.message),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CommentBloc>().add(
                          LoadComments(pageNum: 1, postId: widget.postId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CommentsLoaded || state is CommentOperationSuccess) {
              final paginated = (state is CommentsLoaded)
                  ? state.paginated
                  : (state as CommentOperationSuccess).paginated;
              if (paginated == null) {
                context.read<CommentBloc>().add(
                  LoadComments(pageNum: 1, postId: widget.postId),
                );
                return const Center(child: CircularProgressIndicator());
              }
              final comments = paginated.comments;
              return Column(
                children: [
                  Expanded(
                    child: CommentList(
                      post: widget.post,
                      currentUserId: widget.currentUserId,
                      comments: comments,
                      onRefresh: () async {
                        context.read<CommentBloc>().add(
                          RefreshComments(postId: widget.postId),
                        );
                      },
                      onLoadMore: _loadMore,
                      onLike: (CommentEntity c) {
                        context.read<CommentBloc>().add(
                          ToggleLikeCommentEvent(id: c.id),
                        );
                      },
                      onDelete: (CommentEntity c) async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Delete this comment?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          context.read<CommentBloc>().add(
                            DeleteCommentEvent(id: c.id),
                          );
                        }
                      },
                      onEdit: (CommentEntity c) async {
                        final newText = await showDialog<String?>(
                          context: context,
                          builder: (ctx) {
                            final txtCtrl = TextEditingController(text: c.text);
                            return AlertDialog(
                              title: const Text('Edit comment'),
                              content: TextField(controller: txtCtrl),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, null),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(
                                    ctx,
                                    txtCtrl.text.trim(),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (newText != null && newText.isNotEmpty) {
                          context.read<CommentBloc>().add(
                            UpdateCommentEvent(id: c.id, text: newText),
                          );
                        }
                      },
                      onReply: (CommentEntity c) {
                        setState(() {
                          _replyingTo = c;
                        });
                        _controller.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onShowReplies: (CommentEntity c) {
                        context.read<CommentBloc>().add(
                          LoadComments(pageNum: 1, commentId: c.id),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          if (_replyingTo != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Replying to: ${_replyingTo!.user.fullName}',
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _replyingTo = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  formkey: _formKey,
                                  obsecure: false,
                                  textEditingController: _controller,
                                  errorMessage: 'Comment cannot be empty',
                                  hintText: _replyingTo != null
                                      ? 'Write a reply...'
                                      : 'Add a comment...',
                                  validator: (val) => val == null || val.isEmpty
                                      ? 'Cannot be empty'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _submitComment,
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
