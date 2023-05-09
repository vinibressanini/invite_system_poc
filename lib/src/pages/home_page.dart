import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:invite_system_poc/get_it.dart';
import 'package:invite_system_poc/src/pages/notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final _db = FirebaseFirestore.instance;
final _destinyController = TextEditingController();
final _dio = getIt.get<Dio>();

sendInvite(BuildContext context) async {
  try {
    final response = await _db
        .collection("users")
        .where("email", isEqualTo: _destinyController.text)
        .get();

    final destiny = response.docs.first.data();

    Map<String, dynamic> data = {
      "to": destiny["token"],
      "notification": {
        "title": "You Have a new Invite",
        "body": "Vinicius wants you to join His Team"
      }
    };

    await _dio.post(
      "fcm/send",
      data: data,
      options: Options(
        headers: {
          "authorization":
              "Bearer AAAAhcmvhw4:APA91bHavEVl1JWYs502qFQxd2sbyj_sR9IDDH3VmrVXRO5Ct3TQC_LsR11rZernYM_I2CT0zXgvm96s11hMVDN_TnRmuxqXhed3AaBxmbpvjDMtJDyXBitVk6JW7RsNV_JZzF7Xr5PO"
        },
      ),
    );
  } on StateError {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Não existe nenhum usuário com o email informado"),
      ),
    );
  } on DioError catch (e) {
    print(e.message);
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: "Informe o email do usuário",
                  border: OutlineInputBorder(),
                ),
                controller: _destinyController,
              ),
            ),
            ElevatedButton(
              onPressed: () async => await sendInvite(context),
              child: const Center(child: Text("Send Invite")),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const NotificationPage()))),
              child: const Center(child: Text("My Notificarions")),
            ),
          ],
        ),
      ),
    );
  }
}
