import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirebaseNotification {
  void firebaseMesseging(BuildContext context, Widget screen) async {
    // initialize
    FirebaseMessaging messaging = await FirebaseMessaging.instance;

    String? token = await messaging.getToken();

    print("TOKEN $token");

    // foregraound notificaitn
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "NA";
      final body = message.notification?.body ?? "NA";

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(title),
              content: Text(
                body,
                maxLines: 1,
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel),
                ),
              ],
            ),
      );
    });

    // Background State open but not in use
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? "NA";
      final body = message.notification?.body ?? "NA";
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    });

    // App is close or terminated
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        final title = message.notification?.title ?? "NA";
        final body = message.notification?.body ?? "NA";
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
    });
  }
}
