import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/log_in_page/sub_finding_password_page.dart';

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
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/main_logo.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: postechRed.withOpacity(0.9),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '비밀번호 찾기', style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5 - 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: id,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                suffixText: "@postech.ac.kr",
                                hintText: "포스텍 이메일",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text){
                              setState(() {
                                email = "$text@postech.ac.kr";
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                '인증번호 받기', style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black45),
                              ),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {

                                      await resetPassword(email);

                                      if(checkForArrive){
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext context) => SubFindingPasswordPage()));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                left: 10, top : 30,
                child: IconButton (onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.white54), iconSize: 30)
            ),
          ],
        ),
      ),
    );
  }

  void _notFoundPopUp(){
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