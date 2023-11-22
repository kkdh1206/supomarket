import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/usecases/util_usecases.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../../widgets/util_widgets.dart';
import '../control_page.dart';
import '../log_in_page/log_in_page.dart';
import '../log_in_page/widgets/log_in_page_widget.dart';

class SubMyInfoPageChangePasswordPage extends StatefulWidget {
  const SubMyInfoPageChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubMyInfoPageChangePasswordPageState();
  }
}

class _SubMyInfoPageChangePasswordPageState
    extends State<SubMyInfoPageChangePasswordPage> {
  TextEditingController oldP = TextEditingController();
  TextEditingController newP = TextEditingController();
  TextEditingController newP2 = TextEditingController();
  String givenPassword = "";
  String newPassword = "";
  String newPassword2 = "";
  bool checkForArrive = false;
  bool isPressed = false;

  Future<void> passwordUpdate(String newPassword) async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      setPasswordInDevice(newPassword);
      debugPrint("비밀번호 변경 완료");
    }
    else{
      print("user null error");
      isPressed = false;
    }
  }

  void _popUp(String value, BuildContext context) {
    utilUsecase.popUp(value, context);
  }

  @override
  void initState() {
    super.initState();
    _getPasswordInDevice();
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
              SupoTitle5(),
              const SizedBox(height: 60),
              TextInputwithButton(
                hintText: '기존 비밀번호',
                onChanged: (text) {
                  givenPassword = text;
                  isPressed = false;
                },
              ),
              TextInputwithButton(
                hintText: '새 비밀번호',
                onChanged: (value) {
                  setState(() {
                    newPassword = value;
                    isPressed = false;
                  });
                },
              ),
              TextInputwithButton(
                hintText: '새 비밀번호 확인',
                onChanged: (value) {
                  setState(() {
                    newPassword2 = value;
                    isPressed = false;
                  });
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 325,
                height: 60,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFB70001),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15.0), // 원하는 둥근 정도 설정
                      ),
                    ),
                    onPressed: () async {
                      print(myUserInfo.password);
                      if (givenPassword == myUserInfo.password) {
                        if (newPassword == givenPassword){
                          _popUp("새 비밀번호가 기존 비밀번호와 같습니다", context);
                        }
                        else if (newPassword.compareTo(newPassword2) == 0) {
                          setState(() {
                            isPressed = true;
                          });
                          await passwordUpdate(newPassword);
                          setState(() {
                            isPressed = false;
                          });
                          _popUp("비밀번호가 변경되었습니다", context);
                        } else {
                          _popUp("신규 비밀번호가 다릅니다", context);
                        }
                      } else {
                        _popUp("기존 비밀번호가 다릅니다", context);
                      }
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '확인',
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
            ],
          ),
          Positioned(
              left: 10,
              top: 50,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  iconSize: 30)),
          isPressed == true
              ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }

  void _getPasswordInDevice() async{
    myUserInfo.password = await getPasswordInDevice();
  }
}
