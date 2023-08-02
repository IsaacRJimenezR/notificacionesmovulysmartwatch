import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final TextEditingController username = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // TOKEN DE FIREBASE API de Cloud Messaging (heredada) // ESTA ES LA CLAVE DEL SERVIDOR DE FIRESTORE
          'Authorization':
              'key=AAAA3v7dZnk:APA91bE2cxHk7BZCPKcttWTdnoBsQiuG9MEzxMEdS3oznPJlfUTly6OiMcf5pbOsw0Y7rpkCkcStOtuj7BtjnjtbtfzueYS6d1ksLwRDQCVE0XQ5frNVpJMS28YaHzuNE1NtPbPhZqwi'
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "dbfood"
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print("ERROR PUSH NOTIFICATION");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     // title: const Text(
      //     //   'Enviar Notificación',
      //     //   style: TextStyle(fontSize: 14),
      //     // ), // Tamaño del texto ajustado a 16
      //     ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: username,
                style: const TextStyle(
                    fontSize: 8), // Tamaño de texto ajustado a 4
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  labelStyle: TextStyle(fontSize: 8),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal:
                          10), // Alineación vertical y horizontal del contenido
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: title,
                style: const TextStyle(
                    fontSize: 8), // Tamaño de texto ajustado a 12
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(fontSize: 8),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: body,
                // maxLines: 2,
                style: const TextStyle(
                    fontSize: 8), // Tamaño de texto ajustado a 12
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  labelStyle: TextStyle(fontSize: 8),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    String name = username.text.trim();
                    String titeText = title.text;
                    String bodyText = body.text;

                    // CADENA DE EVENTOS
                    if (name != "") {
                      DocumentSnapshot snap = await FirebaseFirestore.instance
                          .collection("UserTokens")
                          .doc(name)
                          .get();

                      String token = snap['token'];
                      print(token);

                      sendPushMessage(token, titeText, bodyText);
                    }
                  },
                  child: const Text(
                    'ENVIAR',
                    style: TextStyle(
                        fontSize: 12), // Tamaño del texto ajustado a 12
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
