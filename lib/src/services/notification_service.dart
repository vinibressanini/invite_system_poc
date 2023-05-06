import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:invite_system_poc/src/models/custom_notification.dart';

import '../../routes.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;
  late String fmcToken;

  _retrieveUserToken() async {
    fmcToken = await FirebaseMessaging.instance.getToken() ?? "";
    print(fmcToken);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    _onMessege();
    _onTerminated();
  }

  _onMessege() async {
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;

      if (notification != null && android != null) {
        showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
          ),
        );
      }
    });
  }

  _onTerminated() async {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        showLocalNotification(
          CustomNotification(
            id: value.notification!.android.hashCode,
            title: value.notification!.title!,
            body: value.notification!.body!,
          ),
        );
      }
    });
  }

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _retrieveUserToken();
    _setupAndroidDetails();
    _setupNotifications();
  }

  _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'invite_notification_details',
      'Invites',
      channelDescription: 'This channel is for users invites!',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
        const InitializationSettings(
          android: android,
        ),
        onDidReceiveNotificationResponse: (details) =>
            _onSelectNotification(details.payload));
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
    }
  }

  showLocalNotification(CustomNotification notification) {
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
      ),
      payload: notification.payload,
    );
  }
}
