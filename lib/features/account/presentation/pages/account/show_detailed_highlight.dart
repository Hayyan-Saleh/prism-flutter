import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/cached_network_video.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/detailed_highlight_entity.dart';
import 'package:prism/features/account/domain/enitities/account/highlight/highlight_status_entity.dart';
import 'package:prism/features/account/domain/enitities/account/main/account_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/highlight_bloc/highlight_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowDetailedHighlight extends StatefulWidget {
  final int highlightId;
  final VoidCallback? onFinished;
  final VoidCallback? onStart;
  final bool isMyHighlight;
  final AccountEntity account;

  const ShowDetailedHighlight({
    super.key,
    required this.highlightId,
    this.onFinished,
    this.onStart,
    required this.isMyHighlight,
    required this.account,
  });

  @override
  State<ShowDetailedHighlight> createState() => _ShowDetailedHighlightState();
}

class _ShowDetailedHighlightState extends State<ShowDetailedHighlight>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  double _progress = 0.0;
  DetailedHighlightEntity? _highlight;
  bool _isTextExpanded = false;
  CachedNetworkVideoState? _videoController;
  double? _videoDuration;
  bool _isNavigating = false;

  bool updatedCover = false;

  @override
  void initState() {
    super.initState();
    context.read<HighlightBloc>().add(
      GetDetailedHighlight(highlightId: widget.highlightId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePop,
      child: BlocConsumer<HighlightBloc, HighlightState>(
        listener: _handleBlocListener,
        builder: _buildContent,
      ),
    );
  }

  Future<bool> _handlePop() async {
    _pauseContent();
    return true;
  }

  void _handleBlocListener(BuildContext context, HighlightState state) {
    if (state is DetailedHighlightLoaded) {
      if (mounted) {
        setState(() {
          _highlight = state.highlight;
        });
        if (state.highlight.statuses.isNotEmpty && _currentPage == 0) {
          if (state.highlight.statuses[0].media == null ||
              state.highlight.statuses[0].type == 'image') {
            _progress = 0.0;
            _startTimer(5.0, state.highlight.statuses.length, 0);
          }
        }
      }
    } else if (state is HighlightDeleted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true); // Return true to indicate deletion
      }
    }
  }

  Widget _buildContent(BuildContext context, HighlightState state) {
    if (state is HighlightLoading) {
      return _buildLoading();
    }
    if (state is DetailedHighlightLoaded && _highlight != null) {
      return Hero(tag: _highlight!.id, child: _buildLoaded());
    }
    if (state is HighlightFailure) {
      return _buildError(state.message);
    }
    return Container();
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text(message)),
    );
  }

  Widget _buildLoaded() {
    if (_highlight!.statuses.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(AppLocalizations.of(context)!.noStatusesAvailable),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _buildPageView(),
            Column(
              children: [
                _buildProgressIndicators(_highlight!.statuses),
                _buildTopBar(_highlight!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _highlight!.statuses.length,
      onPageChanged: (index) => _handlePageChange(index),
      itemBuilder:
          (context, index) => _buildStatusPage(
            _highlight!.statuses[index],
            _highlight!.statuses.length,
            index,
          ),
    );
  }

  void _handlePageChange(int index) {
    if (mounted) {
      _isNavigating = false;
      setState(() {
        _currentPage = index;
        _progress = 0.0;
        _isTextExpanded = false;
        _videoController = null;
        _videoDuration = null;
      });
      if (_highlight!.statuses.isNotEmpty &&
          (_highlight!.statuses[index].media == null ||
              _highlight!.statuses[index].type == 'image')) {
        _startTimer(5.0, _highlight!.statuses.length, index);
      }
    }
  }

  void _startTimer(double duration, int totalStatuses, int currentIndex) {
    _timer?.cancel();
    if (mounted) {
      const updateInterval = Duration(milliseconds: 50);
      _timer = Timer.periodic(updateInterval, (timer) {
        if (mounted) {
          setState(() {
            _progress += updateInterval.inMilliseconds / 1000 / duration;
            if (_progress >= 1.0) {
              timer.cancel();
              _navigateNext(totalStatuses, currentIndex);
            }
          });
        }
      });
    }
  }

  void _pauseContent() {
    _timer?.cancel();
    _videoController?.pause();
  }

  void _resumeContent() {
    if (!mounted) return;
    final status = _highlight!.statuses[_currentPage];
    if (status.media == null || status.type == 'image') {
      _startTimer(5.0, _highlight!.statuses.length, _currentPage);
    } else if (status.type == 'video') {
      _videoController?.resume();
      if (_videoDuration != null) {
        _startTimer(_videoDuration!, _highlight!.statuses.length, _currentPage);
      }
    }
  }

  void _navigatePrevious() {
    if (_currentPage != 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else if (widget.onStart != null) {
      widget.onStart!();
    }
  }

  void _navigateNext(int totalStatuses, int currentIndex) {
    if (_isNavigating) return;
    _isNavigating = true;

    if (currentIndex < totalStatuses - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else if (widget.onFinished != null) {
      widget.onFinished!();
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context, updatedCover);
      }
    }
  }

  Widget _buildStatusPage(
    HighlightStatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    return GestureDetector(
      onLongPressStart: (_) => _pauseContent(),
      onLongPressEnd: (_) => _resumeContent(),
      child: Stack(
        children: [
          _buildStatusContent(status, totalStatuses, currentIndex),
          _buildNavigationOverlay(totalStatuses),
        ],
      ),
    );
  }

  Widget _buildStatusContent(
    HighlightStatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    final hasMediaWithText =
        status.media != null && status.text != null && status.text!.isNotEmpty;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (status.media == null)
          _buildTextStatus(status)
        else if (status.type == 'image')
          _buildImageStatus(status)
        else
          _buildVideoStatus(status, totalStatuses, currentIndex),
        if (hasMediaWithText)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _isTextExpanded = !_isTextExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxHeight:
                      _isTextExpanded
                          ? 0.6 * getHeight(context)
                          : 3 * 18.0 * 1.2,
                ),
                decoration: BoxDecoration(
                  color:
                      _isTextExpanded
                          ? Colors.black.withAlpha(125)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  physics:
                      _isTextExpanded
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                  child: Text(
                    status.text!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: _isTextExpanded ? null : 3,
                    overflow: _isTextExpanded ? null : TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextStatus(HighlightStatusEntity status) {
    return Container(
      color: Theme.of(context).colorScheme.secondary.withAlpha(200),
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isTextExpanded = !_isTextExpanded;
            });
          },
          child: Container(
            constraints: BoxConstraints(
              maxHeight:
                  _isTextExpanded ? 0.6 * getHeight(context) : 15 * 24.0 * 1.3,
            ),
            decoration: BoxDecoration(
              color:
                  _isTextExpanded
                      ? Colors.black.withAlpha(125)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              physics:
                  _isTextExpanded
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
              child: Text(
                status.text ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: _isTextExpanded ? null : 15,
                overflow: _isTextExpanded ? null : TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageStatus(HighlightStatusEntity status) {
    final imgWidget = CustomCachedNetworkImage(
      isRounded: false,
      imageUrl: status.media!,
      radius: 0,
    );
    return Stack(
      children: [
        SizedBox(
          height: getHeight(context),
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                imgWidget,
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withAlpha(150)),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: getHeight(context),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              stops: [0, 0.25, 0.75, 1],
            ),
          ),
        ),
        Center(child: SizedBox(width: getWidth(context), child: imgWidget)),
      ],
    );
  }

  Widget _buildVideoStatus(
    HighlightStatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    final vidWidget = CachedNetworkVideo(
      key: ValueKey(status.media!),
      videoUrl: status.media!,
      showControls: false,
      onEnd: () => setState(() => _navigateNext(totalStatuses, currentIndex)),
      onDurationLoaded: (duration) {
        _videoDuration = duration;
        _startTimer(duration, totalStatuses, currentIndex);
      },
    );
    return Stack(
      children: [
        Container(
          color: Colors.black.withAlpha(220),
          height: getHeight(context),
          width: double.infinity,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                vidWidget,
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(color: Colors.black.withAlpha(100)),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Builder(
            builder: (context) {
              final controller =
                  context.findAncestorStateOfType<CachedNetworkVideoState>();
              if (controller != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _videoController = controller;
                    });
                  }
                });
              }
              return vidWidget;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationOverlay(int totalStatuses) {
    return Container(
      margin: const EdgeInsets.only(
        top: 102,
        bottom: 102 + 16 + 3 * 18.0 * 1.2,
      ),
      height: 0.9 * getHeight(context) - (102 + 16 + 3 * 18.0 * 1.2),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _navigatePrevious,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap:
                  () => setState(
                    () => _navigateNext(totalStatuses, _currentPage),
                  ),
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(DetailedHighlightEntity highlight) {
    final account = widget.account;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ProfilePicture(link: account.picUrl ?? '', radius: 32),
            const SizedBox(width: 16),
            Expanded(child: _buildUserInfo(highlight, account)),
            if (widget.isMyHighlight)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    context.read<HighlightBloc>().add(
                      DeleteHighlight(highlightId: highlight.id),
                    );
                  } else if (value == 'update_cover') {
                    Navigator.of(context)
                        .pushNamed(
                          AppRoutes.updateHighlightCover,
                          arguments: {
                            'highlightId': highlight.id,
                            'coverUrl': highlight.cover,
                          },
                        )
                        .then((isUpdated) {
                          if (mounted && isUpdated is bool && isUpdated) {
                            updatedCover = true;
                          }
                        });
                  }
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'update_cover',
                        child: Text(AppLocalizations.of(context)!.updateCover),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context, updatedCover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(
    DetailedHighlightEntity highlight,
    AccountEntity account,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          account.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTimeElapsed(highlight.statuses[_currentPage].addedAt),
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  String _formatTimeElapsed(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    final localizations = AppLocalizations.of(context)!;
    if (difference.inMinutes < 60) {
      return difference.inMinutes == 0
          ? localizations.justNow
          : localizations.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return localizations.hoursAgo(difference.inHours);
    }
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  Widget _buildProgressIndicators(List<HighlightStatusEntity> statuses) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(
          statuses.length,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              child:
                  index == _currentPage
                      ? LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      )
                      : Container(
                        color:
                            index < _currentPage
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.grey,
                      ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
