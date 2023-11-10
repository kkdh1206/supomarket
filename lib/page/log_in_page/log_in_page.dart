import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/log_in_page/auth_email_page.dart';
import 'package:supo_market/page/log_in_page/register_page.dart';
import 'package:supo_market/page/log_in_page/widgets/widget.dart';
import 'package:supo_market/page/util_function.dart';

import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../control_page.dart';
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

  Future<void> signInWithEmailAndPassword(String id, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: id,
          password: password
      );
      if(credential.user != null){
        myUserInfo.isUserLogin = true;
        checkForArrive =  true;
        return;
      }
      else{
        myUserInfo.isUserLogin = false;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _notUserPopUp();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _wrongPasswordPopUp();
        print('Wrong password provided for that user.');
      }
      else{
        _wrongInfoPopUp();
      }
    }

    checkForArrive = false;
    return;
  }

  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  String givenID = "";
  String givenPassword = "";

  @override
  void initState() {
    //myUser 누군지 모르니 초기화
    checkForArrive = false;
    myUserInfo.isUserLogin = false;
    isPressed = false;
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SupoTitle(),
              TextInputwithButton(),
              RegisterPassward(),
              LoginButton(),

            ]
        ));
  }

//
// @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage('assets/images/main_logo.jpg'), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: postechRed.withOpacity(0.9),
//         body: Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(left: 35, top: 130),
//               child: const Text(
//                 '슈포마켓', style: TextStyle(color: Colors.white, fontSize: 33),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.5 - 50),
//                 child: Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.only(left: 35, right: 35),
//                           child: Column(
//                             children: [
//                               TextField(
//                                 controller: id,
//                                 style: const TextStyle(color: Colors.black),
//                                 decoration: InputDecoration(
//                                     fillColor: Colors.grey.shade100,
//                                     filled: true,
//                                     hintText: "이메일",
//                                     suffixText: "@postech.ac.kr",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     )),
//                                 onChanged: (text){
//                                   givenID = "$text@postech.ac.kr";
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               ),
//                               TextField(
//                                 controller: password,
//                                 style: const TextStyle(),
//                                 obscureText: true, //패스워드 별표 처리
//                                 decoration: InputDecoration(
//                                     fillColor: Colors.grey.shade100,
//                                     filled: true,
//                                     hintText: "비밀번호",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     )),
//                                 onChanged: (text){
//                                   givenPassword = text;
//                                 },
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                         openRegisterPage();
//                                       },
//                                     child: const Text("회원가입 하러가기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       openFindingPasswordPage();
//                                     },
//                                     child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   const Text(
//                                     'Sign in', style: TextStyle(
//                                       fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black45),
//                                   ),
//                                   const SizedBox(width: 15),
//                                   CircleAvatar(
//                                     radius: 30,
//                                     backgroundColor: const Color(0xff4c505b),
//                                     child: IconButton(
//                                         color: Colors.white,
//                                         onPressed: () async {
//
//                                           //isPress가 활성화되어있을 때 circle progress bar가 돌아가도록 함
//                                           setState(() {
//                                             isPressed = true;
//                                           });
//                                           //Sign In 이 올바르면 checkForArrive가 true, 이상한 정보라면 false가 된다.
//                                           await signInWithEmailAndPassword(givenID, givenPassword);
//
//                                           //도형코드~
//                                           debugPrint("LogInPage : auth/signin 로그인 정보 받아오기");
//                                           var token = await firebaseAuth.currentUser?.getIdToken();
//                                           Dio dio = Dio();
//                                           dio.options.headers['Authorization'] = 'Bearer $token';
//                                           String url = 'http://kdh.supomarket.com/auth/signin';
//                                           try {
//                                             Response response = await dio.post(url);  // 근데 이걸 post로 해야하는지는 확신이 안서네 ;;
//                                           } catch (e) {
//                                             print('Error sending POST request : $e');
//                                           }
//                                           //~도형코드
//
//                                           setState((){
//                                               isPressed = false;
//                                             });
//
//                                             if(checkForArrive == true){
//                                               debugPrint("로그인 정보의 correct는 ${myUserInfo.isUserLogin.toString()}다");
//                                               //로그인 되어있으면 넘어가기
//                                               if(myUserInfo.isUserLogin!){
//                                                 //인증 되어 있으면 control page가 첫 스택, 아니라면 auth_email page 띄우
//                                                 debugPrint("현재 로그인된 유저 이메일은 ${firebaseAuth.currentUser?.email} 입니다");
//                                                 debugPrint("현재 로그인된 유저 이메일 인증 여부는 ${firebaseAuth.currentUser?.emailVerified.toString()} 입니다");
//
//                                                 if(firebaseAuth.currentUser?.emailVerified??false){
//                                                   await fetchMyInfo(); //유저정보 fetch
//                                                   FirebaseMessaging fbMsg = FirebaseMessaging.instance;
//                                                   String? fcmToken = await fbMsg.getToken();
//                                                   await patchToken(fcmToken!); //fcm token 보내기
//
//                                                   if(myUserInfo.userStatus != UserStatus.BANNED){
//                                                     setPasswordInDevice(givenPassword);
//                                                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                                                         builder: (BuildContext context) => ControlPage()), (route) => false);
//                                                   }
//                                                   else{
//                                                     _bannedUserPopUp();
//                                                   }
//                                                 }
//                                                 else {
//                                                   Navigator.push(context, MaterialPageRoute(
//                                                       builder: (BuildContext context) => AuthEmailPage()));
//                                                 }
//                                               }
//                                             }
//                                         },
//                                         icon: const Icon(
//                                           Icons.arrow_forward,
//                                         )),
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(
//                                 height: 40,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     isPressed == true?
//                     const Align(
//                       alignment: Alignment.center,
//                       child: CircularProgressIndicator(),
//                     ) : const SizedBox(width: 0, height: 0),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


  Future openRegisterPage() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  Future openFindingPasswordPage() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => FindingPasswordPage()));
  }

  void _wrongPasswordPopUp(){
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("올바른 정보가 아닙니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _bannedUserPopUp(){
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("해당 유저는 접속할 수 없습니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _notUserPopUp(){
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("유저 정보가 없습니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _wrongInfoPopUp(){
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("올바르지 않은 정보입니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


