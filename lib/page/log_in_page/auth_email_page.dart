import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/log_in_page/sub_finding_password_page.dart';
import '../../entity/util_entity.dart';
import '../../infra/users_info_data.dart';
import 'log_in_page.dart';



class AuthEmailPage extends StatefulWidget {

  const AuthEmailPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthEmailPageState();
  }
}

class _AuthEmailPageState extends State<AuthEmailPage> {

  @override
  void initState() {
    super.initState();
    sendEmail(firebaseAuth.currentUser?.email??"");
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (BuildContext context) => LogInPage()), (route) => false);
    });

  }

  @override
  Future<void> sendEmail(String email) async {
    try {
      await firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      debugPrint("인증 이메일 에러");
    } catch (e) {
      debugPrint("인증 이메일 에러");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '이메일로 인증 링크가', style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '발송되었습니다', style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '3초 뒤 로그인 페이지로 돌아갑니다', style: TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );

    //   Scaffold(
    //   backgroundColor: postechRed.withOpacity(0.9),
    //   body: Stack(
    //     children: [
    //       Container(
    //         padding: const EdgeInsets.only(left: 35, top: 130),
    //         child: const Text(
    //           '이메일 인증', style: TextStyle(color: Colors.white, fontSize: 33),
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.only(left : 35, top : 180),
    //         child: const Text(
    //             '이메일로 인증 링크가 발송되었습니다', style: TextStyle(color: Colors.white, fontSize: 15),
    //             textAlign: TextAlign.center,
    //         ),
    //       ),
    //       Container(
    //         padding: const EdgeInsets.only(left : 35, top : 210),
    //         child: const Text(
    //           '3초 뒤 로그인 페이지로 돌아갑니다', style: TextStyle(color: Colors.white, fontSize: 15),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}