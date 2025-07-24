import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:prism/features/account/presentation/pages/account/show_detailed_highlight.dart';

class ShowHighlightsPage extends StatefulWidget {
  final int initialHighlightIndex;
  final List<int> highlightIds;
  final bool isMyHighlight;
  final AccountEntity account;

  const ShowHighlightsPage({
    super.key,
    required this.initialHighlightIndex,
    required this.highlightIds,
    this.isMyHighlight = true,
    required this.account,
  });

  @override
  State<ShowHighlightsPage> createState() => _ShowHighlightsPageState();
}

class _ShowHighlightsPageState extends State<ShowHighlightsPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialHighlightIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.highlightIds.length,
        itemBuilder: (context, index) {
          return BlocProvider<HighlightBloc>(
            create: (context) => sl<HighlightBloc>(),
            child: ShowDetailedHighlight(
              highlightId: widget.highlightIds[index],
              isMyHighlight: widget.isMyHighlight,
              account: widget.account,
              onFinished: () {
                if (index < widget.highlightIds.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              onStart: () {
                if (index > 0) {
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
