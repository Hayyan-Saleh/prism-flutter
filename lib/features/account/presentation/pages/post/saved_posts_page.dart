import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/localization/l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/bloc/post/post_bloc/post_bloc.dart';
import 'package:prism/features/account/presentation/widgets/post/posts_list_widget.dart';
import 'package:prism/main.dart' show routeObserver;

class SavedPostsPage extends StatefulWidget {
  const SavedPostsPage({super.key});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadSavedPosts(pageNum: 1));
  }

  ModalRoute? _modalRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modalRoute = ModalRoute.of(context);
    routeObserver.subscribe(this, _modalRoute!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  } 

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.savedPosts),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocListener<PostBloc, PostState>(
      listenWhen:
          (previous, current) =>
              current is PostError || current is PostOperationSuccess,
      listener: (context, state) {
        if (state is PostError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        } else if (state is PostOperationSuccess) {
          context.read<PostBloc>().add(LoadSavedPosts(pageNum: 1));
        }
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedPostsLoadedSuccess) {
            final posts = state.paginatedPosts.posts;
            if (posts.isEmpty) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.noSavedPostsFound,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }
            return PostsListWidget(
              posts: posts,
              emptyMessage: AppLocalizations.of(context)!.noSavedPostsFound,
            );
          } else if (state is PostError) {
            return Center(
              child: Text(
                state.failure.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }
}
