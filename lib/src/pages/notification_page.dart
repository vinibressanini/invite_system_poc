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

  showNotification() {
    _invitesStream.listen((event) {
      notificationService.showLocalNotification(
        CustomNotification(
            id: 1,
            title: 'You have a new invite',
            body:
                '${event.docs.last.get('sender')} wants you to join ${event.docs.last.get('team')}'),
      );
    });
  }

  @override
  void initState() {
    _invitesStream = _db
        .collection('invites')
        .where("destiny", isEqualTo: "Teste")
        .orderBy("timestamp")
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

          showNotification();
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['sender']),
                    subtitle: Text(data['team']),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
