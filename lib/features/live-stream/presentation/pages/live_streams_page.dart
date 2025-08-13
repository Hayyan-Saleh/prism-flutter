import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/sevices/assets.dart';
import 'package:prism/core/util/widgets/profile_picture.dart';
import 'package:prism/features/account/presentation/bloc/account/groups_bloc/groups_bloc.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';
import 'package:prism/features/live-stream/domain/entities/live_stream_entity.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_bloc.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_event.dart';
import 'package:prism/features/live-stream/presentation/bloc/live_stream_bloc/live_stream_state.dart';

class LiveStreamsPage extends StatefulWidget {
  const LiveStreamsPage({super.key});

  @override
  State<LiveStreamsPage> createState() => _LiveStreamsPageState();
}

class _LiveStreamsPageState extends State<LiveStreamsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildAppBar(context),
      body: const _LiveStreamGrid(),
    );
  }

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.co_present_rounded),
              title: Text(AppLocalizations.of(context)!.accountSettings),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.accountSettings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: Text(
                AppLocalizations.of(context)?.myOwnedGroups ?? 'Owned Groups',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.myFollowedGroups,
                  arguments: {
                    'trigger': (BuildContext context) {
                      context.read<GroupsBloc>().add(GetOwnedGroupsEvent());
                    },
                    'title': AppLocalizations.of(context)?.myOwnedGroups,
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups_2),
              title: Text(
                AppLocalizations.of(context)?.myFollowedGroups ??
                    'Followed Groups',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.myFollowedGroups,
                  arguments: {
                    'trigger': (BuildContext context) {
                      context.read<GroupsBloc>().add(GetFollowedGroupsEvent());
                    },
                    'title': AppLocalizations.of(context)?.myFollowedGroups,
                    'applyJoin': true,
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed:
              () => Navigator.pushNamed(context, AppRoutes.createLiveStream),
          icon: const Icon(Icons.camera_alt_outlined),
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _showSettingsBottomSheet(context);
          },
        ),
      ],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Assets.walkThrough1, height: 46),
          Text(
            AppLocalizations.of(context)!.prism,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}

class _LiveStreamGrid extends StatelessWidget {
  const _LiveStreamGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveStreamBloc, LiveStreamState>(
      builder: (context, state) {
        if (state is LiveStreamLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LiveStreamError) {
          return Center(child: Text(state.failure.message));
        } else if (state is LiveStreamLoaded) {
          if (state.paginatedLiveStreams.streams.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)?.noLiveStreamsAvailable ??
                    'No live streams available at the moment.',
              ),
            );
          }
          return RefreshIndicator(
            color: Colors.pink,
            onRefresh: () async {
              context.read<LiveStreamBloc>().add(
                GetActiveStreamsEvent(page: 1, limit: 10),
              );
            },
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: state.paginatedLiveStreams.streams.length,
              itemBuilder: (context, index) {
                final stream = state.paginatedLiveStreams.streams[index];
                return _LiveStreamCard(stream: stream);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LiveStreamCard extends StatelessWidget {
  final LiveStreamEntity stream;
  const _LiveStreamCard({required this.stream});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final account = context.read<PAccountBloc>().pAccount;
        if (account != null && account.id == stream.creator.id) {
          Navigator.pushNamed(
            context,
            AppRoutes.myLiveStream,
            arguments: {'stream': stream},
          );
        } else {
          Navigator.pushNamed(
            context,
            AppRoutes.liveStream,
            arguments: {'stream': stream},
          );
        }
      },
      child: Card(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(stream.creator.avatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.25, 0.75, 1.0],
                      colors: [
                        Colors.black,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                children: [
                  const Icon(Icons.visibility, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    stream.views.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Text(
                _formatTimeElapsed(context, stream.createdAt),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  ProfilePicture(
                    link: stream.creator.avatar,
                    radius: 26,
                    live: true,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stream.creator.fullName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeElapsed(BuildContext context, DateTime createdAt) {
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
}
