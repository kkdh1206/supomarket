import 'dart:ffi';

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
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';
import '../notification.dart';
import '../provider/socket_provider.dart';
import 'control_page.dart';
import 'log_in_page/log_in_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  //firebase 사용을 위한 호출들

  WidgetsFlutterBinding.ensureInitialized();
  //안드로이드 권한 허용
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.instance..requestPermission(
    badge: true,
    alert: true,
    sound: true
  );

  FirebaseMessaging fbMsg = FirebaseMessaging.instance;
  fcmToken = await fbMsg.getToken();
  print("fcmToken : ${fcmToken}을 받았습니다");
  if(firebaseAuth.currentUser != null){
    await patchToken(fcmToken!); //서버에 해당 토큰을 저장 및 수정하는 로직 구현
  }

  //IOS 알람 권한 요청
  await reqIOSPermission(fbMsg);

  runApp(const MyApp());

  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if(initialMessage != null) {
    _handleMessage(initialMessage);
  }
  //알림 받기 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {

    print("실행됨?");

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
              android: AndroidNotificationDetails('channelId', 'channelName', icon: "ic_notification")
          ),
        );
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    _handleMessage(message!);
  });

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
        android: AndroidNotificationDetails(
          'channelId', 'channelName', icon: "ic_notification")
        ),
      );
}

class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/main_logo_2.png"),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(postechRed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {


  @override
  void initState() {
    //값 받아오기 전 초기값
    //initNotification();

    myUserInfo.imagePath = "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96";
    myUserInfo.password = "";
    myUserInfo.isUserLogin = false;

    //firebase 유저 정보 불러오기
    super.initState();
    debugPrint("welcomePage initiate");

    //로그인 여부 판단
    if (firebaseAuth.currentUser != null) {
      myUserInfo.isUserLogin = true;
      debugPrint("로그인 상태입니다");
      fetchMyInfo();
    }
    else {
      debugPrint("로그아웃 상태입니다");
    }
  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black45),
          fontFamily: 'Nanum',
        ),
        home: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 3), ()=> "completed"),
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: SplashConditionWidget(snapshot),
            );
          },
        ),
        initialRoute: '/',
        routes: {'/control': (context) => ControlPage(),
          //'/subHome': (context) => const SubHomePage()
        },
      ),
    );
  }

  Widget SplashConditionWidget(AsyncSnapshot<Object?> snapshot) {
    if(snapshot.hasError) {
      return const Text("Error!!");
    }
    else if(snapshot.hasData) {
      if((myUserInfo.isUserLogin == true) && (firebaseAuth.currentUser?.emailVerified == true)){
        if(myUserInfo.userStatus == UserStatus.BANNED){
          return WelcomePage();
        }
        else{
          return ControlPage();
        }
      }
      else{
        return WelcomePage();
      }
    }
    else {
      return SplashScreen();
    }
  }

}


class WelcomePage extends StatelessWidget {

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
      fontFamily: 'Nanum'
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body : Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child : Image.asset('assets/images/main_logo_2.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child : MaterialButton(
                      height: 60,
                      minWidth: 180,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                      color: const Color(0xffac145a),
                      elevation: 5,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
                      },
                      child: const Text("시작하기", textScaleFactor: 2.0, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

