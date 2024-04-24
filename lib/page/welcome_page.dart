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
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

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

      print(myUserInfo.userStatus);
    } else {
      debugPrint("로그아웃 상태입니다");
    }
  }

  Future<bool> checkBanAndVersion() async {
    await getMyInfo();
    if (myUserInfo.userStatus == UserStatus.BANNED) {
      myUserInfo.isUserLogin = false; // 밴 당한 경우 다시 로그인으로 보내줘버림
      debugPrint("banned 된 유저입니다");
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    String latest_version = await getAppVersion();
    if(latest_version != version){
      print(latest_version);
      print(version);
      print("버전이 달라요!!");
      return true; // 안되는 경우
    }
    return false;
  }

  Future<String> getAppVersion() async {
    FirebaseRemoteConfig remoteConfig = await FirebaseRemoteConfig.instance;

    remoteConfig.setConfigSettings(
        RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 0),
            minimumFetchInterval: Duration.zero));
    await remoteConfig.fetch(); // 서버에서 값을 받아옴
    await remoteConfig.activate(); // 서버에서 값을 받아온거로 사용한다고 설정함

    // String minAppVersion = remoteConfig.getString('min_version');
    String latestAppVersion = remoteConfig.getString('latest_version');
    return latestAppVersion;
  }



  //
  //
  // void clearSpecificData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('key_to_remove'); // 'key_to_remove'에 해당하는 데이터를 지웁니다.
  // }

  Future<void> showUpdateDialog(BuildContext context) async{
    bool determine = await getPlatform();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새로운 버전이 출시되었어요!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('슈포마켓이 새로운 버전이 나왔어요.\n더 좋은 서비스로 바뀐 슈포마켓을 업데이트 해!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('다음에 할게요'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('업데이트 하기'),
              onPressed: () {
                if(determine){
                  // ios 인 경우
                  _launchStoreURL("https://apps.apple.com/kr/app/supomarket/id6477733742?platform=iphone"); // 앱스토어 이동
                }else{
                  // 안드로이드 인 경우
                }
                _launchStoreURL("https://play.google.com/store/apps/details?id=com.supomarket.supo_market"); // 플레이 스토어 이동
              },
            ),
          ],
        );
      },
    );


  }
  void _launchStoreURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  Future <bool> getPlatform() async{
    if (Platform.isIOS) {
      return true;
    } else   {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // async 안써도 future builder 쓰면 checkebanned 처리 가능
    return MaterialApp(
      title: "슈포마켓",
      debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFB70001)),
      fontFamily: 'KBO-M',
    ),
    home: FutureBuilder(
        future: checkBanAndVersion(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 기다리는 동안 로딩 표시
            print("ssibal");
            print(snapshot.data);
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            );

            /// 이거 좀더 예쁜 화면으로 바꾸기!!!
          }
          else if (snapshot.data) { /// --->>>>> 새로짠 페이지     ---> 여기에 showUpdateDialog 함수의 팝업 창을 녹여내기 --.> 디자인까지 슈포마켓 로고랑 막 만들기 ---. 이것도 좀 예쁘게 ㅗㅋ드 짤려면 차라리 페이지 를 새로파서 만드는게 깔끔함
            return _UpdatePage();
          }

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

            // checkBanned() 함수의 결과에 따라 다른 위젯 반환

        }
        ),
    );
  }
}

class _UpdatePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return UpdatePage();
  }
}

class UpdatePage extends State<_UpdatePage>{
  //const UpdatePage({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'KBO-M'),
    home:
    Scaffold(
      body:
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("새로운 버전이 출시되었어요!",style: TextStyle(color: Colors.white,fontSize: 30),), // Tenada 체로 바꾸기!!!
            Text("슈포마켓이 새로운 버전이 나왔어요.\n더 좋은 서비스로 바뀐 슈포마켓을 업데이트 해!",style: TextStyle(color: Colors.white,fontSize: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('다음에 할게요'),
                  onPressed: () {
                    if((myUserInfo.isUserLogin == true) &&
                        (firebaseAuth.currentUser?.emailVerified == true)){
                      // control page 로 이동
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new ControlPage()),
                      );
                    }else{
                      // loginpage로 이동
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new WelcomePage()),
                      );

                    }
                    setState(() {});

                  },
                ),
                ElevatedButton(
                  child: Text('업데이트 하기'),
                  onPressed: () async {
                    bool determine = await getPlatform();
                    if(determine){
                      // ios 인 경우
                      _launchStoreURL("https://apps.apple.com/kr/app/supomarket/id6477733742?platform=iphone"); // 앱스토어 이동
                    }else{
                      // 안드로이드 인 경우
                    }
                    _launchStoreURL("https://play.google.com/store/apps/details?id=com.supomarket.supo_market"); // 플레이 스토어 이동
                  },
                ),
              ],)
          ],
        ),
        color: Color(0xFFB70001),
        // 시작하기가 아니라 - 팝업 에 있던 버튼을 둬서 그냥 넘어가기 하면 이 다음 밑에 조건문 넣어서 어디로 보낼지 provider로 넘김
        // 만약 업뎃 누르면 링크 전송 하고 --- 그뒤어 처리는 솔직히 모르겠다.

      ),

    ));
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

void _launchStoreURL(String url) async {
  await launchUrl(Uri.parse(url));
}

Future <bool> getPlatform() async{
  if (Platform.isIOS) {
    return true;
  } else   {
    return false;
  }
}
