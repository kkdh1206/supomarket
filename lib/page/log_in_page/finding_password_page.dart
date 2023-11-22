import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/log_in_page/sub_finding_password_page.dart';
import 'package:supo_market/page/log_in_page/widgets/log_in_page_widget.dart';

import '../../entity/util_entity.dart';
import '../../infra/users_info_data.dart';
import 'log_in_page.dart';

class FindingPasswordPage extends StatefulWidget {
  const FindingPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FindingPasswordPageState();
  }
}

class _FindingPasswordPageState extends State<FindingPasswordPage> {
  String email = "";
  bool checkForArrive = false;

  TextEditingController id = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkForArrive = false;
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      checkForArrive = true;
      return;
    } on FirebaseAuthException catch (e) {
      _notFoundPopUp();
      checkForArrive = false;
      return;
    } catch (e) {
      _notFoundPopUp();
      checkForArrive = false;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              SupoTitle4(),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: TextInputwithButton(
                          hintText: '이메일',
                          onChanged: (text) {
                            setState(() {
                              email = "$text@postech.ac.kr";
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 325,
                        height: 60,
                        margin: const EdgeInsets.only(left: 35, right: 35),
                        child: TextButton(
                            onPressed: () async {
                              await resetPassword(email);

                              if (checkForArrive) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SubFindingPasswordPage()));
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
                                  '인증번호 받기',
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
                ),
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
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  iconSize: 30)),
        ],
      ),
    );
  }

  void _notFoundPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("등록되지 않은 계정입니다")),
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
