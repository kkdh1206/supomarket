
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/firebase_options.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/page/welcome_page.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';
import '../notification.dart';
import '../provider/socket_provider.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  //firebase 사용을 위한 호출들
  print("main start");
  WidgetsFlutterBinding.ensureInitialized();
  //    안드로이드 권한 허용
  // flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.requestPermission();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Future.delayed(Duration(seconds: 1)); //이거 안해주면 흰색화면뜸

  FirebaseMessaging.instance..requestPermission(badge: true, alert: true, sound: true);

  if (!Platform.isAndroid){
    FirebaseMessaging.instance.deleteToken();
  }

  FirebaseMessaging fbMsg = FirebaseMessaging.instance;
  fcmToken = await fbMsg.getToken();
  print("fcmToken : ${fcmToken}을 받았습니다");
  // if (firebaseAuth.currentUser != null) {
  await patchToken(fcmToken!); //서버에 해당 토큰을 저장 및 수정하는 로직 구현
  // }

  //IOS 알람 권한 요청
  if(Platform.isIOS) await reqIOSPermission(fbMsg);
  mainPageBuilder = assignTrue();

  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }
  //알림 받기 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {

    if (message != null) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["screen"]);
        print(message.data["param"]);
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          const NotificationDetails(
              android: AndroidNotificationDetails('channelId', 'channelName',
                  icon: "ic_notification")),
        );
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    _handleMessage(message!);
  });

  runApp(const MyApp());
  print("runApp");
}

void _handleMessage(RemoteMessage message) {
  final String targetPage = message.data['screen'];
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification!.title,
    message.notification!.body,
    NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            icon: "ic_notification")),
  );
}