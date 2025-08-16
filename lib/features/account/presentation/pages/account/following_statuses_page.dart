import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:prism/features/account/presentation/widgets/show_status_widget.dart';

class FollowingStatusesPage extends StatefulWidget {
  final List<int> userIds;
  final int initialUserIndex;

  const FollowingStatusesPage({
    super.key,
    required this.userIds,
    required this.initialUserIndex,
  });

  @override
  State<FollowingStatusesPage> createState() => _FollowingStatusesPageState();
}

class _FollowingStatusesPageState extends State<FollowingStatusesPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialUserIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.userIds.length,
        itemBuilder: (context, index) {
          return BlocProvider<StatusBloc>(
            create: (context) => sl<StatusBloc>(),
            child: ShowStatusWidget(
              userId: widget.userIds[index],
              onFinished: () {
                if (index < widget.userIds.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              onStart: () {
                if (index != 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
