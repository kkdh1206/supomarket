import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../control_page.dart';
import '../log_in_page/log_in_page.dart';

Color postechRed = Color(0xffac145a);

class SubMyInfoPageChangePasswordPage extends StatefulWidget {
  final Future<Database> db;
  const SubMyInfoPageChangePasswordPage({super.key, required this.db});

  @override
  State<StatefulWidget> createState() {
    return _SubMyInfoPageChangePasswordPageState();
  }
}

class _SubMyInfoPageChangePasswordPageState extends State<SubMyInfoPageChangePasswordPage> {

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
      debugPrint("비밀번호 변경 완료");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/main_logo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.white70.withOpacity(0.9),
        body: Stack(
          children: [
            isPressed == true?
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ) : const SizedBox(width: 0, height: 0),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '비밀번호 변경', style: TextStyle(color: Colors.black54, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                controller: oldP,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "기존 비밀번호",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onChanged: (text){
                                  givenPassword = text;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: newP,
                                style: const TextStyle(),
                                obscureText: true, //패스워드 별표 처리
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "신규 비밀번호",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onChanged: (text){
                                  newPassword = text;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                  controller: newP2,
                                  style: const TextStyle(),
                              obscureText: true, //패스워드 별표 처리
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "신규 비밀번호 확인",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onChanged: (text){
                                newPassword2 = text;
                              },
                            ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    '확인', style: TextStyle(
                                      fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black45),
                                  ),
                                  const SizedBox(width: 15),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {

                                          if(givenPassword == myUserInfo.password){
                                            if(newPassword.compareTo(newPassword2) == 0){
                                              setState(() {
                                                isPressed = true;
                                              });
                                              await passwordUpdate(newPassword);
                                              setState((){
                                                isPressed = false;
                                              });
                                              Navigator.pop(context);
                                            }
                                            else{
                                              //경고문
                                              debugPrint("신규 비밀번호가 다릅니다");
                                            }
                                          }
                                          else{
                                            //경고문
                                            debugPrint("기존 비밀번호가 다릅니다");
                                            debugPrint(myUserInfo.password);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
