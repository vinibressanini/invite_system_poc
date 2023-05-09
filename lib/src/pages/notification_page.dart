import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invite_system_poc/get_it.dart';
import 'package:invite_system_poc/src/models/custom_notification.dart';
import 'package:invite_system_poc/src/services/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final notificationService = getIt.get<NotificationService>();

  final _db = FirebaseFirestore.instance;

  late final Stream<QuerySnapshot> _invitesStream;


  @override
  void initState() {
    _invitesStream = _db
        .collection('users')
        .where("email", isEqualTo: "vinimarcus41@gmail.com")
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _invitesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          List<dynamic> invites = snapshot.data!.docs.first.get("invites");
          return ListView.builder(
            itemCount: invites.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(invites[index]['sender']),
                subtitle: Text(invites[index]['team']),
                trailing: Text(invites[index]['status']),
              );
            },
          );
        },
      ),
    );
  }
}
