import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:utils/resources/storage.dart';
import 'package:utils/utils.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (!AppStorage.instance.isInitialize) await AppStorage.instance.initialize();
  await storeMessage(message);
}

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

Future<Chat?> storeMessage(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin?.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel!.id,
            channel!.name,
            channel!.description,
            icon: 'launch_background',
          ),
        ));

    final data = message.data;
    log("$data", name: "FCM");

    final chat = Chat.fromJson(data);
    chat.createdMillis ??= DateTime.now().millisecondsSinceEpoch;
    log("${chat.toJson()}", name: "FCM");

    await AppStorage.instance.addMessage(chat.senderId!, chat.toJson());

    return chat;
  }
}

Future initialiseFirebase() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

class FirebaseBloc extends Cubit<FirebaseState> {
  FirebaseBloc() : super(FirebaseState());

  subscibe(String senderId) async {
    await FirebaseMessaging.instance.deleteToken();
    FirebaseMessaging.instance.subscribeToTopic(senderId);
  }

  startListen([ValueChanged<Chat>? onMessageReceived]) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("onMessageOpenedApp", name: "FCM");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("onListenEvent", name: "FCM");

      storeMessage(message).then((chat) {
        if (chat != null) onMessageReceived?.call(chat);
      });
    });
  }
}

class FirebaseState {}
