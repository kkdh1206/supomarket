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

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/main_logo.png'),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 140),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Image.asset("assets/images/main_logo_2.png"),
    //         CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation(postechRed),
    //         ),
    //       ],
    //     ),
    //   ),
    // )
    // ,
    // );
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

    myUserInfo.imagePath =
        "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96";
    myUserInfo.password = "";
    myUserInfo.isUserLogin = false;

    //firebase 유저 정보 불러오기
    super.initState();
    debugPrint("welcomePage initiate");

    //로그인 여부 판단
    if (firebaseAuth.currentUser != null) {
      myUserInfo.isUserLogin = true;
      debugPrint("로그인 상태입니다");

      checkBanned();
      print(myUserInfo.userStatus);
    } else {
      debugPrint("로그아웃 상태입니다");
    }
  }

  Future checkBanned() async {
    await getMyInfo();
    if (myUserInfo.userStatus == UserStatus.BANNED) {
      myUserInfo.isUserLogin = false; // 밴 당한 경우 다시 로그인으로 보내줘버림
      debugPrint("banned 된 유저입니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    // async 안써도 future builder 쓰면 checkebanned 처리 가능
    return FutureBuilder(
        future: checkBanned(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 기다리는 동안 로딩 표시
            return CircularProgressIndicator();
          } else {
            // checkBanned() 함수의 결과에 따라 다른 위젯 반환

            return MultiProvider(
              providers: [
                // ChangeNotifierProvider(create: (_)=> LoginModel()),
                ChangeNotifierProvider(create: (_) => SocketProvider()),
              ],
              child: MaterialApp(
                title: "슈포마켓",
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Color(0xFFB70001)),
                    fontFamily: 'KBO-M'),
                home:

                    // // ((myUserInfo.isUserLogin == true) &&
                    // //     (firebaseAuth.currentUser?.emailVerified == true) &&
                    // (myUserInfo.userStatus == UserStatus.BANNED))
                    // ? WelcomePage()
                    // :

                    ((myUserInfo.isUserLogin == true) &&
                            (firebaseAuth.currentUser?.emailVerified == true))
                        ? ControlPage()
                        : WelcomePage(),
                initialRoute: '/',
                routes: {
                  '/control': (context) => ControlPage(),
                  //'/subHome': (context) => const SubHomePage()
                },
              ),
            );
          }
        });
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'KBO-M'),
      home: Scaffold(
        backgroundColor: mainColor,
        body: Center(
          child: Stack(
            children: [
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           width: MediaQuery.of(context).size.width,
              //           height: MediaQuery.of(context).size.height,
              //             child: Image.asset('assets/images/main_logo.png')),
              //       ],
              //     ),
              //   ],
              // ),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.2,
                  right: MediaQuery.of(context).size.width * 0.01,
                  left: MediaQuery.of(context).size.width * 0.01,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Container(
                      child: Image.asset('assets/images/icons/explain.jpeg'),
                    ),
                  )),
              Positioned(
                bottom: MediaQuery.of(context).size.height *
                    0.35, // 화면 높이의 10% 위치에 배치
                right: MediaQuery.of(context).size.width * 0.3,
                left: MediaQuery.of(context).size.width * 0.3,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.white, width: 3)),
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInPage()));
                      },
                      child: const Text("시작하기",
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'KBO-B'))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
