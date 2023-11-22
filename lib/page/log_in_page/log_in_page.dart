import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/log_in_page/register_page.dart';
import 'package:supo_market/page/log_in_page/usecases/popup_usecase.dart';
import 'package:supo_market/page/log_in_page/widgets/log_in_page_widget.dart';
import '../../entity/user_entity.dart';
import '../control_page.dart';
import '../util_function.dart';
import 'auth_email_page.dart';
import 'finding_password_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage> {
  bool checkForArrive = false;
  bool isPressed = false;

  String givenID = "";
  String givenPassword = "";

  @override
  void initState() {
    //myUser 누군지 모르니 초기화
    isPressed = false;
    checkForArrive = false;
    myUserInfo.isUserLogin = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              SupoTitle(),
              const SizedBox(height: 60),
              TextInputwithButton(
                  hintText: '이메일',
                  onChanged: (value) {
                    setState(() {
                      givenID = "$value@postech.ac.kr";
                    });
                  }),
              TextInputwithButton(
                hintText: '비밀번호',
                onChanged: (value) {
                  setState(() {
                    givenPassword = value;
                    isPressed = false;
                  });
                },
              ),
              RegisterPassward(),
              SizedBox(
                width: 325,
                height: 60,
                child: TextButton(
                    onPressed: () async {
                      //isPress가 활성화되어있을 때 circle progress bar가 돌아가도록 함
                      setState(() {
                        isPressed = true;
                      });
                      //Sign In 이 올바르면 checkForArrive가 true, 이상한 정보라면 false가 된다.
                      await signInWithEmailAndPassword(givenID, givenPassword);

                      //도형코드~
                      debugPrint("LogInPage : auth/signin 로그인 정보 받아오기");
                      var token = await firebaseAuth.currentUser?.getIdToken();
                      Dio dio = Dio();
                      dio.options.headers['Authorization'] = 'Bearer $token';
                      String url = 'http://kdh.supomarket.com/auth/signin';
                      try {
                        Response response = await dio
                            .post(url); // 근데 이걸 post로 해야하는지는 확신이 안서네 ;;
                      } catch (e) {
                        print('Error sending POST request : $e');
                      }
                      //~도형코드

                      setState(() {
                        isPressed = false;
                      });

                      if (checkForArrive == true) {
                        debugPrint(
                            "로그인 정보의 correct는 ${myUserInfo.isUserLogin.toString()}다");
                        //로그인 되어있으면 넘어가기
                        if (myUserInfo.isUserLogin!) {
                          //인증 되어 있으면 control page가 첫 스택, 아니라면 auth_email page 띄우
                          debugPrint(
                              "현재 로그인된 유저 이메일은 ${firebaseAuth.currentUser?.email} 입니다");
                          debugPrint(
                              "현재 로그인된 유저 이메일 인증 여부는 ${firebaseAuth.currentUser?.emailVerified.toString()} 입니다");

                          if (firebaseAuth.currentUser?.emailVerified ??
                              false) {
                            await getMyInfo(); //유저정보 get
                            FirebaseMessaging fbMsg = FirebaseMessaging.instance;
                            String? fcmToken = await fbMsg.getToken();
                            await patchToken(fcmToken!); //fcm token 보내기

                            if (myUserInfo.userStatus != UserStatus.BANNED) {
                              setPasswordInDevice(givenPassword);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ControlPage()),
                                  (route) => false);
                            } else {
                              popUpUseCase.bannedUserPopUp(context);
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthEmailPage()));
                          }
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFB70001),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // 원하는 둥근 정도 설정
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '로그인',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'KBO-M',
                              fontWeight: FontWeight.w800,
                              fontSize: 23),
                        )
                      ],
                    )),
              ),
            ]),

        isPressed == true
            ? const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const SizedBox(width: 0, height: 0),
        isPressed == true
            ? const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color : Colors.white,
          ),
        )
            : const SizedBox(width: 0, height: 0),
      ],
    ));
  }

  Future openRegisterPage() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  Future openFindingPasswordPage() {
    return Navigator.push(context,
        MaterialPageRoute(builder: (context) => FindingPasswordPage()));
  }

  void _wrongPasswordPopUp() {
    print("wrong password pop up");
    popUpUseCase.wrongPasswordPopUp(context);
  }

  void _bannedUserPopUp() {
    print("banned user pop up");
    popUpUseCase.bannedUserPopUp(context);
  }

  void _notUserPopUp() {
    print("not user pop up");
    popUpUseCase.notUserPopUp(context);
  }

  void _wrongInfoPopUp() {
    print("wrong info pop up");
    popUpUseCase.wrongInfoPopUp(context);
  }

  Future<void> signInWithEmailAndPassword(String id, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: id, password: password);
      if (credential.user != null) {
        myUserInfo.isUserLogin = true;
        checkForArrive = true;
        return;
      } else {
        myUserInfo.isUserLogin = false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _notUserPopUp();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _wrongPasswordPopUp();
        print('Wrong password provided for that user.');
      } else {
        _wrongInfoPopUp();
      }
    }

    checkForArrive = false;
    return;
  }
}
