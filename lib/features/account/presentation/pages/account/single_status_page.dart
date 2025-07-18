import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/di/injection_container.dart';
import 'package:prism/core/util/entities/media_entity.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/cached_network_video.dart';
import 'package:prism/core/util/widgets/custom_cached_network_image.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/domain/enitities/account/status/status_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/status_bloc/status_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prism/features/account/presentation/bloc/account/users_bloc/accounts_bloc.dart';
import 'package:prism/features/account/presentation/bloc/like_bloc/like_bloc.dart';

class SingleStatusPage extends StatefulWidget {
  final bool isArchived;
  final StatusEntity status;

  const SingleStatusPage({
    super.key,
    required this.status,
    required this.isArchived,
  });

  @override
  State<SingleStatusPage> createState() => _SingleStatusPageState();
}

class _SingleStatusPageState extends State<SingleStatusPage>
    with TickerProviderStateMixin {
  Timer? _timer;
  double _progress = 0.0;
  bool _isTextExpanded = false;
  CachedNetworkVideoState? _videoController;
  late StatusEntity _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
    if (_status.media == null || _status.media!.type == MediaType.image) {
      _startTimer(5.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePop,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocListener<StatusBloc, StatusState>(
          listener: (context, state) {
            if (state is StatusDeleted) {
              Navigator.of(context).pop(true);
            }
          },
          child: _buildLoaded(),
        ),
      ),
    );
  }

  Future<bool> _handlePop() async {
    _pauseContent();
    return true;
  }

  Widget _buildLoaded() {
    return SafeArea(
      child: Stack(
        children: [
          _buildStatusPage(_status),
          Column(children: [_buildProgressIndicator(), _buildTopBar(_status)]),
        ],
      ),
    );
  }

  void _startTimer(double duration) {
    _timer?.cancel();
    _progress = 0.0;
    const updateInterval = Duration(milliseconds: 50);
    _timer = Timer.periodic(updateInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _progress += updateInterval.inMilliseconds / 1000 / duration;
        if (_progress >= 1.0) {
          timer.cancel();
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  void _pauseContent() {
    _timer?.cancel();
    _videoController?.pause();
  }

  void _resumeContent() {
    if (_status.media == null || _status.media!.type == MediaType.image) {
      _startTimer(5.0);
    } else if (_status.media!.type == MediaType.video) {
      _videoController?.resume();
    }
  }

  void _navigateNext() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildStatusPage(StatusEntity status) {
    return Stack(
      children: [_buildStatusContent(status), _buildNavigationOverlay()],
    );
  }

  Widget _buildLikeWidget(StatusEntity status) {
    return BlocBuilder<LikeBloc, LikeState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                state.isLiked ? Icons.favorite : Icons.favorite_border,
                color: state.isLiked ? Colors.pink : Colors.white,
                size: 32,
              ),
              onPressed: () {
                if (state is! LikeInProgress) {
                  context.read<LikeBloc>().add(
                    ToggleLikeEvent(statusId: status.id),
                  );
                }
              },
            ),
            state.likesCount > 0
                ? GestureDetector(
                  onTap: () {
                    _pauseContent();
                    Navigator.of(context)
                        .pushNamed(
                          AppRoutes.accounts,
                          arguments: {
                            'appBarTitle': AppLocalizations.of(context)!.likers,
                            'triggerEvent': (BuildContext blocContext) {
                              blocContext.read<AccountsBloc>().add(
                                GetStatusLikersEvent(statusId: status.id),
                              );
                            },
                          },
                        )
                        .then((_) => _resumeContent());
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Text(
                      state.likesCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
                : Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Text(
                    state.likesCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
          ],
        );
      },
    );
  }

  Widget _buildStatusContent(StatusEntity status) {
    final hasMediaWithText =
        status.media != null && status.text != null && status.text!.isNotEmpty;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (status.media == null)
          _buildTextStatus(status)
        else if (status.media!.type == MediaType.image)
          _buildImageStatus(status)
        else
          _buildVideoStatus(status),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasMediaWithText)
                Expanded(
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
                                ? Colors.black.withOpacity(0.5)
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
                          overflow:
                              _isTextExpanded ? null : TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!widget.isArchived)
                BlocProvider<LikeBloc>(
                  create:
                      (context) => LikeBloc(
                        toggleLikeStatusUseCase: sl(),
                        isLiked: status.isLiked,
                        likesCount: status.likesCount,
                      ),
                  child: BlocListener<LikeBloc, LikeState>(
                    listener: (context, state) {
                      if (state is LikeSuccess) {
                        setState(() {
                          _status = _status.copyWith(
                            isLiked: state.isLiked,
                            likesCount: state.likesCount,
                          );
                        });
                      }
                    },
                    child: _buildLikeWidget(status),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextStatus(StatusEntity status) {
    return Container(
      color: Theme.of(context).colorScheme.secondary.withAlpha(200),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    _isTextExpanded ? 0.6 * getHeight(context) : 3 * 24.0 * 1.2,
              ),
              decoration: BoxDecoration(
                color:
                    _isTextExpanded
                        ? Colors.black.withOpacity(0.5)
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
                  maxLines: _isTextExpanded ? null : 3,
                  overflow: _isTextExpanded ? null : TextOverflow.ellipsis,
                ),
              ),
            ),
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

  Widget _buildVideoStatus(StatusEntity status) {
    final vidWidget = CachedNetworkVideo(
      key: ValueKey(status.media!.url),
      videoUrl: status.media!.url,
      showControls: false,
      onEnd: () => setState(() => _navigateNext()),
      onDurationLoaded: (duration) => _startTimer(duration),
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

  Widget _buildNavigationOverlay() {
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
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _navigateNext()),
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
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
            if (!widget.isArchived)
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
      children: [
        Text(
          status.user.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
