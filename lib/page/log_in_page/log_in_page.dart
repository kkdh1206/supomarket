import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';

import '../control_page.dart';

Color postechRed = Color(0xffac145a);

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool checkForArrive = false;
  bool isPressed = false;

  //비밀번호 7자리 이상, 아이디는 이메일 폼
  Future<void> createEmailAndPassword(String id, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: id,
        password: password,
      );
      if(credential.user != null){
         allUserIDPWList.add(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signInWithEmailAndPassword(String id, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
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
    // myUserInfo.userGoodsNum = 0;
    // myUserInfo.userName = "";
    // myUserInfo.imagePath = "";
    // myUserInfo.userSchoolNum = "";
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
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
            isPressed == true?
            const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ) : const SizedBox(width: 0, height: 0),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '슈포마켓', style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5 - 50),
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
                                controller: id,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "ID",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onChanged: (text){
                                  givenID = text;
                                },
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: password,
                                style: const TextStyle(),
                                obscureText: true, //패스워드 별표 처리
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onChanged: (text){
                                  givenPassword = text;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      createEmailAndPassword(givenID, givenPassword);
                                    },
                                    child: const Text("회원가입 하러가기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text("비밀번호 찾기", style: TextStyle(color: Colors.white54, decoration: TextDecoration.underline)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Sign in', style: TextStyle(
                                      fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black45),
                                  ),
                                  const SizedBox(width: 15),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: const Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          //isPress가 활성화되어있을 때 circle progress bar가 돌아가도록 함
                                          setState(() {
                                            isPressed = true;
                                          });
                                          //Sign In 이 올바르면 checkForArrive가 true, 이상한 정보라면 false가 된다.
                                          await signInWithEmailAndPassword(givenID, givenPassword);
                                          setState((){
                                            isPressed = false;
                                            if(checkForArrive == true){
                                              debugPrint("로그인 정보의 correct는 ${myUserInfo.isUserLogin.toString()}다");
                                              //로그인 되어있으면 넘어가기
                                              if(myUserInfo.isUserLogin!){
                                                //myUserInfo에 불러온 정보 적어주기
                                                getMyUserInfo(givenID, givenPassword);
                                                //다 지우고 control page가 첫 스택
                                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                                    builder: (BuildContext context) => ControlPage()), (route) => false);
                                              }
                                            }
                                          });
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

  bool checkLogin(String id, String password){

    //체크 방법

    return true;
  }

  void getMyUserInfo(String id, String password){

    //myUserInfo.info = allUserInfoList에서 가져와 대입

  }


}
