import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/comments/presentation/bloc/comment_bloc.dart';
import 'package:your_app/features/comments/presentation/widgets/comment_card.dart';

class CommentList extends StatelessWidget {
  final String postId;
  final ScrollController scrollController;

  const CommentList({
    Key? key,
    required this.postId,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading && state is! CommentLoaded) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CommentError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CommentBloc>().add(LoadComments(postId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is CommentLoaded) {
          if (state.comments.isEmpty) {
            return const Center(
              child: Text('No comments yet', style: TextStyle(fontSize: 16)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CommentBloc>().add(
                LoadComments(postId, refresh: true),
              );
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.comments.length,
              itemBuilder: (context, index) {
                return CommentCard(comment: state.comments[index]);
              },
            ),
          );
        }
        return const Center(child: Text('Load comments'));
      },
    );
  }
}
