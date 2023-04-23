import 'package:flutter/material.dart';
import 'package:invite_system_poc/src/pages/home_page.dart';
import 'package:invite_system_poc/src/pages/notification_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/home': (_) => const HomePage(),
    '/notification': (_) => NotificationPage(),
  };

  static String initial = '/home';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
