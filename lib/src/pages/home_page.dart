import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invite_system_poc/src/pages/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final _db = FirebaseFirestore.instance;

sendInvite() {
  Map<String, dynamic> data = {
    "destiny": "Teste",
    "sender": "abc",
    "status": "pending",
    "team": "vasco",
    "timestamp": DateTime.now()
  };

  _db.collection('invites').add(data);
}

class _HomePageState extends State<HomePage> {
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
              builder: (context) => const NotificationPage(),
            )),
            child: const Center(child: Text("Go to Notifications")),
          ),
          ElevatedButton(
            onPressed: () => sendInvite(),
            child: const Center(child: Text("Send Invite")),
          ),
        ],
      ),
    );
  }
}
