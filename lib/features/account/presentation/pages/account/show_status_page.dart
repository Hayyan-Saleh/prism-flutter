import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/widgets/cached_network_video.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/main/follow_status_enum.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowStatusPage extends StatefulWidget {
  final int userId;
  final VoidCallback? onFinished;
  final bool personalStatuses;
  final FollowStatus followStatus;

  const ShowStatusPage({
    super.key,
    required this.userId,
    this.onFinished,
    required this.personalStatuses,
    required this.followStatus,
  });

  @override
  State<ShowStatusPage> createState() => _ShowStatusPageState();
}

class _ShowStatusPageState extends State<ShowStatusPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocConsumer<StatusBloc, StatusState>(
        listener: _handleBlocListener,
        builder: _buildContent,
      ),
    );
  }

  void _handleBlocListener(BuildContext context, StatusState state) {
    if (state is StatusDeleted) {
      context.read<StatusBloc>().add(
        GetStatusesEvent(accountId: widget.userId),
      );
      return;
    }

    if (state is StatusLoaded) {
      if (state.statuses.isEmpty) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        widget.onFinished?.call();
        return;
      }

      if (state.statuses.isNotEmpty && _currentPage == 0) {
        if (state.statuses[0].media == null ||
            state.statuses[0].media!.type == MediaType.image) {
          _startTimer(5.0, state.statuses.length, 0);
        }
      }
    }
  }

  Widget _buildContent(BuildContext context, StatusState state) {
    if (state is StatusLoading) return _buildLoading();
    if (state is StatusLoaded) {
      return Hero(tag: 'showStatusTag', child: _buildLoaded(state));
    }
    if (state is StatusFailure) return _buildError(state.error);
    return _buildError(AppLocalizations.of(context)!.somethingWentWrong);
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(child: Text(message));
  }

  Widget _buildLoaded(StatusLoaded state) {
    if (state.statuses.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noStatusesAvailable),
      );
    }
    return SafeArea(
      child: Stack(
        children: [
          _buildPageView(state),
          Column(
            children: [
              _buildProgressIndicators(state.statuses),
              _buildTopBar(state.statuses[_currentPage]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageView(StatusLoaded state) {
    List<StatusEntity> statuses = [];
    final bool hidePrivateStatuses =
        !widget.personalStatuses &&
        widget.followStatus == FollowStatus.notFollowing;
    if (hidePrivateStatuses) {
      statuses =
          state.statuses
              .where((status) => status.privacy != 'private')
              .toList();
    } else {
      statuses = state.statuses;
    }
    return PageView.builder(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.statuses.length,
      onPageChanged: (index) => _handlePageChange(index, statuses),
      itemBuilder:
          (context, index) => _buildStatusPage(
            state.statuses[index],
            state.statuses.length,
            index,
          ),
    );
  }

  void _handlePageChange(int index, List<StatusEntity> statuses) {
    setState(() {
      _currentPage = index;
      _progress = 0.0;
    });
    if (statuses[index].media == null ||
        statuses[index].media!.type == MediaType.image) {
      _startTimer(5.0, statuses.length, index);
    }
  }

  void _startTimer(double duration, int totalStatuses, int currentIndex) {
    _timer?.cancel();
    _progress = 0.0;
    const updateInterval = Duration(milliseconds: 50);
    _timer = Timer.periodic(updateInterval, (timer) {
      setState(() {
        _progress += updateInterval.inMilliseconds / 1000 / duration;
        if (_progress >= 1.0) {
          timer.cancel();
          _navigateNext(totalStatuses, currentIndex);
        }
      });
    });
  }

  void _navigateNext(int totalStatuses, int currentIndex) {
    if (currentIndex < totalStatuses - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else if (widget.onFinished != null) {
      widget.onFinished!();
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _buildStatusPage(
    StatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    return Stack(
      children: [
        _buildStatusContent(status, totalStatuses, currentIndex),
        _buildNavigationOverlay(totalStatuses),
      ],
    );
  }

  Widget _buildStatusContent(
    StatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (status.media == null)
          _buildTextStatus(status)
        else if (status.media!.type == MediaType.image)
          _buildImageStatus(status)
        else
          _buildVideoStatus(status, totalStatuses, currentIndex),
        if (status.media != null &&
            status.text != null &&
            status.text!.isNotEmpty)
          _buildTextOverlay(status.text!),
      ],
    );
  }

  Widget _buildTextStatus(StatusEntity status) {
    return Container(
      color: Theme.of(context).colorScheme.secondary.withAlpha(200),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            status.text ?? '',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildImageStatus(StatusEntity status) {
    final imgWidget = CustomCachedNetworkImage(
      isRounded: false,
      imageUrl: status.media!.url,
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
    StatusEntity status,
    int totalStatuses,
    int currentIndex,
  ) {
    final vidWidget = CachedNetworkVideo(
      videoUrl: status.media!.url,
      showControls: false,
      onEnd: () => setState(() => _navigateNext(totalStatuses, currentIndex)),
      onDurationLoaded:
          (duration) => _startTimer(duration, totalStatuses, currentIndex),
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
                AspectRatio(aspectRatio: 16 / 9, child: vidWidget),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(color: Colors.black.withAlpha(100)),
                ),
              ],
            ),
          ),
        ),
        Center(child: vidWidget),
      ],
    );
  }

  Widget _buildTextOverlay(String text) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNavigationOverlay(int totalStatuses) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 102),
      height: 0.9 * getHeight(context),
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

  void _navigatePrevious() {
    if (_currentPage != 0) {
      setState(() {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
    }
  }

  Widget _buildTopBar(StatusEntity status) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ProfilePicture(link: status.user.avatar, radius: 32),
            const SizedBox(width: 16),
            Expanded(child: _buildUserInfo(status)),
            if (widget.personalStatuses)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    context.read<StatusBloc>().add(
                      DeleteStatusEvent(statusId: status.id),
                    );
                  }
                },
                itemBuilder:
                    (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(StatusEntity status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      spacing: 4,
      children: [
        Text(
          status.user.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          _formatTimeElapsed(status.createdAt),
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  String _formatTimeElapsed(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    if (difference.inMinutes < 60) {
      return difference.inMinutes == 0
          ? AppLocalizations.of(context)!.justNow
          : AppLocalizations.of(context)!.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return AppLocalizations.of(context)!.hoursAgo(difference.inHours);
    }
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  Widget _buildProgressIndicators(List<StatusEntity> statuses) {
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
  void initState() {
    super.initState();
    context.read<StatusBloc>().add(GetStatusesEvent(accountId: widget.userId));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
