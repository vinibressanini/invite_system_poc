import 'package:flutter/material.dart';
import 'package:invite_system_poc/src/pages/notification_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NotificationPage(),
            )),
            child: const Center(child: Text("Go to Notifications")),
          ),
        ],
      ),
    );
  }
}
