import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:prism/core/util/sevices/app_routes.dart';
import 'package:prism/core/util/widgets/app_button.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final StreamController<int> _tabController =
      StreamController<int>.broadcast();

  Stream<int> get tabStream => _tabController.stream;

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

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
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
      // In foreground, we can show a dialog or a snackbar
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(message.notification?.title ?? ''),
              content: Text(message.notification?.body ?? ''),
              actions: [
                AppButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _handleMessage(context, message);
                  },
                  child: const Text('Open'),
                ),
                AppButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
      );
    });
  }

  void _handleMessage(BuildContext context, RemoteMessage message) {
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
              'personalAccountId': details['personal_account_id'],
              'otherAccountId': details['other_account_id'],
            },
          );
          break;
        case AppRoutes.home:
          final tabIndex = int.tryParse(details['tab_index']);
          if (tabIndex != null) {
            _tabController.add(tabIndex);
          }
          break;
        case AppRoutes.showStatusPage:
          Navigator.of(context).pushNamed(
            AppRoutes.showStatusPage,
            arguments: {'personal_account_id': details['personal_account_id']},
          );
          break;
        case AppRoutes.groupJoinRequests:
          Navigator.of(context).pushNamed(
            AppRoutes.groupJoinRequests,
            arguments: {'group_id': details['group_id']},
          );
          break;
        case AppRoutes.groupPage:
          Navigator.of(context).pushNamed(
            AppRoutes.groupPage,
            arguments: {'group_id': details['group_id']},
          );
          break;
      }
    }
  }

  void dispose() {
    _tabController.close();
  }
}
