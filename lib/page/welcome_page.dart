import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/firebase_options.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../entity/user_entity.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';
import 'control_page.dart';
import 'log_in_page/log_in_page.dart';

Color postechRed = Color(0xffac145a);

void main() async {

  //firebase 사용을 위한 호출들
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
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
              Image.asset("assets/images/main_logo.jpg"),
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
    myUserInfo.imagePath = "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96";
    myUserInfo.id = "";
    myUserInfo.userSchoolNum = "";
    myUserInfo.password = "";
    myUserInfo.isUserLogin = false;
    myUserInfo.userName = "";

    //firebase 유저 정보 불러오기
    super.initState();
    debugPrint("welcomePage initiate");

    //로그인 여부 판단
    if (firebaseAuth.currentUser != null) {
      myUserInfo.isUserLogin = true;
      debugPrint("로그인 상태입니다");
      getUserInfo();
    }
    else {
      debugPrint("로그아웃 상태입니다");
    }
  }

  Future<void> getUserInfo() async{

    //도형코드~
    debugPrint("LogInPage : auth/userInfo : 유저 정보 Response 받아오기");
    var token = await firebaseAuth.currentUser?.getIdToken();
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    // dio.options.responseType = ResponseType.plain; // responseType 설정
    String url = 'http://kdh.supomarket.com/auth/userInfo'; // 수정요망 (https://) 일단 뺌  --> 앞에 http든 https 든 꼭 있어야되구나!!

    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;

      print("Response는 ${response}");

      setState(() {
        String studentNumber = jsonData['studentNumber'] as String;
        debugPrint("WelcomePage : 학번은 $studentNumber");
        myUserInfo.userSchoolNum = studentNumber;
      });

      if (response.statusCode == 200){;
      }
      else {
        print('Failed to get response. Status code: ${response.statusCode}');
      }
    }catch (e) {
      print('Error sending GET request : $e');
    }
    //~도형코드

    setState((){
      myUserInfo.id = firebaseAuth.currentUser?.email;
      myUserInfo.userName = firebaseAuth.currentUser?.displayName;
    });


    Reference ref = FirebaseStorage.instance.ref().child('users').child(firebaseAuth.currentUser!.uid).child("profile"+".jpg");
    if(ref!=null) {
      try{
        String url = await ref.getDownloadURL();
        setState(() {
          myUserInfo.imagePath = url;
          debugPrint("프로필 사진 가져오기");
        });
      } catch (e, stack) {
        myUserInfo.imagePath = "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96";
        debugPrint("업로드된 이미지가 아직 없습니다");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Nanum',
      ),
      home: FutureBuilder(
        future: Future.delayed(
            const Duration(seconds: 3), () => "Intro Completed."),
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
    );
  }
}

Widget SplashConditionWidget(AsyncSnapshot<Object?> snapshot) {
  if(snapshot.hasError) {
    return const Text("Error!!");
  } else if(snapshot.hasData) {
    return (myUserInfo.isUserLogin == true) && (firebaseAuth.currentUser?.emailVerified == true)? ControlPage() : WelcomePage();
  } else {
    return SplashScreen();
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
                child : Image.asset('assets/images/main_logo.jpg'),
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

