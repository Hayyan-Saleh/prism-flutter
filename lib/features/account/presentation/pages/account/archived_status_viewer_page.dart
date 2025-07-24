import 'package:flutter/material.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/presentation/pages/account/single_status_page.dart';

class ArchivedStatusViewerPage extends StatefulWidget {
  final List<StatusEntity> statuses;
  final int initialIndex;

  const ArchivedStatusViewerPage({
    super.key,
    required this.statuses,
    required this.initialIndex,
  });

  @override
  State<ArchivedStatusViewerPage> createState() =>
      _ArchivedStatusViewerPageState();
}

class _ArchivedStatusViewerPageState extends State<ArchivedStatusViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statuses.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: Text(
            'No statuses to display.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.statuses.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return SingleStatusPage(
            status: widget.statuses[index],
            isArchived: true,
          );
        },
      ),
    );
  }
}
