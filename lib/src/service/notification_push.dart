// SHA1: 48:AD:6F:84:93:06:6C:3A:57:ED:43:81:13:E2:58:0F:82:70:C0:C4

// P8  Key ID:F5J43MKAL2    llave notific

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sincop_app/src/api/authentication_client.dart';
import 'package:sincop_app/src/controllers/home_controller.dart';
// import 'package:sincop_app/src/service/local_notificaciones.dart';
import 'package:sincop_app/src/service/local_notifications.dart';

class PushNotificationService extends ChangeNotifier {
  static final localNotification = LocalNotifications();
  static final homeController = HomeController();

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static final StreamController<String> _menssageStream =
      StreamController.broadcast();

  static Stream<String> get messageStream => _menssageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('backgroun APP');
    // print('backgroun APP: ${message.data['notification']}');

// homeController.setPayloadAlerta(message);

    //  await LocalNotifications.showNotification(
    //           id: 0,
    //           title: ' sssss${message.notification!.title}',
    //           body: '${message.notification!.body}',
    //           payload: '${message.data}',
    //         );

    // print('holAAAA');
    // print('hola ssssss${message.notification!.title}');
    _menssageStream.sink.add(message.data['informacion'] ?? 'No data');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print('MESSAGE APPsss');
    _menssageStream.sink.add(message.data['informacion'] ?? 'No data');
    // homeController.setPayloadAlerta(message);
    LocalNotifications.showNotification(
      id: 0,
      title: ' sssss${message.notification!.title}',
      body: ' BODY  ${message.notification!.body}',
      payload: 'PAYLOAD ${message.data}',
    );

    // print('title ${message.notification!.title}');
    // print('body ${message.notification!.body}');
    // print('titlesss ${message.data}');
    // yuyuyu();
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    
    //  homeController.setPayloadAlerta(message);
    _menssageStream.sink.add(message.data['informacion'] ?? 'No data');
    LocalNotifications.showNotification(
      id: 0,
      title: 'title OPEN APP',
      body: '${message.data}',
      payload: '${message.data}',
    );
    // print('OPEN APP');
    // print('OPEN APPSSSS: ${message.data}');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    //  options: DefaultFirebaseOptions.currentPlatform,
    await requestPermission();
    token = await FirebaseMessaging.instance.getToken();
    // print('Token FIREBASE ID: $token');

    // // GUARDO EL TOKEN EL EL DISPOSITIVO//
    await Auth.instance.saveTokenFireBase(token!);

    final tokenId = HomeController();
    tokenId.setTokennotificacion(token);
    await tokenId.sentToken();

    // Handler
    FirebaseMessaging.onBackgroundMessage(
        _backgroundHandler); // Local Notification
    FirebaseMessaging.onMessage.listen(_onMessageHandler); // Local Notification
    FirebaseMessaging.onMessageOpenedApp
        .listen(_onMessageOpenApp); // Local Notification
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStrems() {
    _menssageStream.close();
  }
}
