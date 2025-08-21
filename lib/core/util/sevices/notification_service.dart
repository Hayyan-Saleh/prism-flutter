import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prism/core/util/functions/functions.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/top_notification.dart';
import 'package:prism/features/account/data/models/post/post_model.dart';
import 'package:prism/features/account/domain/enitities/account/main/personal_account_entity.dart';
import 'package:prism/features/account/domain/enitities/post/post_entity.dart';
import 'package:prism/features/account/presentation/bloc/account/personal_account_bloc/personal_account_bloc.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<int> _homeTabController =
      StreamController<int>.broadcast();
  int? personalAccountId;

  Stream<int> get homeTabStream => _homeTabController.stream;

  void navigateToHomeTab(int tabIndex) {
    _homeTabController.add(tabIndex);
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void _initializePersonalAccountId(BuildContext context) {
    BlocListener<PAccountBloc, PAccountState>(
      listener: (context, state) {
        PersonalAccountEntity? pAccount =
            state is LoadedPAccountState
                ? state.personalAccount
                : context.read<PAccountBloc>().pAccount;
        personalAccountId = pAccount?.id;
      },
    );
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void showTopNotification(BuildContext context, RemoteMessage message) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 0.1 * getHeight(context),
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TopNotification(
                title: message.notification?.title ?? '',
                body: message.notification?.body ?? '',
                onTap: () {
                  overlayEntry?.remove();
                  _handleMessage(context, message);
                },
              ),
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);
    // Remove after a delay
    Future.delayed(const Duration(seconds: 10), () {
      overlayEntry?.remove();
    });
  }

  void handleNotifications(BuildContext context) {
    // Handle terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && context.mounted) {
        _handleMessage(context, message);
      }
    });

    // Handle background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (context.mounted) {
        _handleMessage(context, message);
      }
    });

    // Handle foreground state
    FirebaseMessaging.onMessage.listen((message) {
      if (!context.mounted) return;
      showTopNotification(context, message);
    });
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
    if (personalAccountId == null) {
      _initializePersonalAccountId(context);
    }

    final route = message.data['route'];
    if (route != null) {
      final details =
          message.data['details'] != null
              ? jsonDecode(message.data['details'])
              : null;
      if (!context.mounted) return;
      switch (route) {
        case AppRoutes.otherAccPage:
          Navigator.of(context).pushNamed(
            AppRoutes.otherAccPage,
            arguments: {
              'personalAccountId':
                  personalAccountId ?? details['personal_account_id'],
              'otherAccountId': details['other_account_id'],
            },
          );
          break;
        case AppRoutes.home:
          final tabIndex = int.tryParse(details['tab_index']);
          if (tabIndex != null) {
            navigateToHomeTab(tabIndex);
          }
          break;
        case AppRoutes.showStatusPage:
          Navigator.of(context).pushNamed(
            AppRoutes.showStatusPage,
            arguments: {
              'userId': personalAccountId ?? details['personal_account_id'],
              'personalStatuses': true,
            },
          );
          break;
        case AppRoutes.groupJoinRequests:
          Navigator.of(context).pushNamed(
            AppRoutes.groupJoinRequests,
            arguments: {'groupId': details['group_id']},
          );
          break;
        case AppRoutes.groupPage:
          Navigator.of(context).pushNamed(
            AppRoutes.groupPage,
            arguments: {'groupId': details['group_id']},
          );
          break;
        case AppRoutes.commentsPage:
          if (details['post'] != null) {
            final PostEntity post = PostModel.fromJson(details['post']);
            Navigator.of(context).pushNamed(
              AppRoutes.commentsPage,
              arguments: {
                'postId': post.id,
                'post': post,
                'currentUserId':
                    personalAccountId ?? details['personal_account_id'],
              },
            );
          } else if (details['post_id'] != null) {
            Navigator.of(context).pushNamed(
              AppRoutes.commentsPage,
              arguments: {
                'postId': details['post_id'],
                'currentUserId':
                    personalAccountId ?? details['personal_account_id'],
              },
            );
          }
          break;
      }
    }
  }

  void dispose() {
    _homeTabController.close();
  }
}
