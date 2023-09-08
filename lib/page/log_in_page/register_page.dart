import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../entity/util_entity.dart';
import '../../infra/users_info_data.dart';
import 'auth_email_page.dart';
import 'log_in_page.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  bool isChecked = false;
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController realName = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController userStudentNumber = TextEditingController();

  String newID = "";
  String newPassword = "";
  String newPassword2 = "";
  String newNickName = "";
  String newRealName = "";
  String newUserSchoolNum = "";
  bool checkForArrive = false;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    newID = "";
    newPassword = "";
    newPassword2 = "";
    newNickName = "";
    newRealName = "";
    newUserSchoolNum = "";
    checkForArrive = false;
  }

  //비밀번호 7자리 이상, 아이디는 이메일 폼
  Future<void> createEmailAndPassword(String id, String password,
      String userName, String newUserSchoolNum) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: id,
        password: password,
      );
      if (credential.user != null) {
        allUserList.add(credential);
        credential.user?.updateDisplayName(newNickName);
        checkForArrive = true;
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _weakPasswordPopUp();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _alreadyExistPopUp();
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }

    checkForArrive = false;
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/main_logo.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: postechRed.withOpacity(0.9),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                '회원가입',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.23),
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
                              hintText: "이메일",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixText: "@postech.ac.kr",
                            ),
                            onChanged: (text) {
                              setState(() {
                                newID = "$text@postech.ac.kr";
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password,
                            style: const TextStyle(),
                            obscureText: true,
                            //패스워드 별표 처리
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "비밀번호",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text) {
                              setState(() {
                                newPassword = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: password2,
                            style: const TextStyle(),
                            obscureText: true,
                            //패스워드 별표 처리
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "비밀번호 재입력",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text) {
                              setState(() {
                                newPassword2 = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: realName,
                            style: const TextStyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "이름",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text) {
                              setState(() {
                                newRealName = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              TextField(
                                controller: nickName,
                                style: const TextStyle(),
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    hintText: "닉네임",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onChanged: (text) {
                                  setState(() {
                                    newNickName = text;
                                  });
                                },
                              ),
                              Positioned(
                                right: 15,
                                child: MaterialButton(
                                  color: Colors.grey,
                                  child: const Text(
                                    "중복 확인",
                                    textScaleFactor: 0.9,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    checkDuplication(newNickName);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: userStudentNumber,
                            style: const TextStyle(),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "학번",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (text) {
                              setState(() {
                                newUserSchoolNum = text;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black45),
                              ),
                              const SizedBox(width: 15),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (newPassword.compareTo(newPassword2) == 0) {

                                        setState(() {
                                          isPressed = true;
                                        });

                                        await createEmailAndPassword(
                                            newID,
                                            newPassword,
                                            newRealName,
                                            newUserSchoolNum);
                                        String token = await firebaseAuth
                                                .currentUser
                                                ?.getIdToken() ??
                                            '';

                                        Dio dio = Dio();

                                        try {
                                          dio.options.headers['Authorization'] = 'Bearer $token';
                                          String url = 'http://kdh.supomarket.com/auth/signup'; // 여기에 api 랑 endpoint 추가해야됨

                                          Map<String, String> data = {
                                            'Email': newID,
                                            'username': newNickName,
                                            'realname': newRealName,
                                            'studentNumber': newUserSchoolNum
                                          };
                                          Response response = await dio.post(url, data: data);

                                          setState(() {
                                            isPressed = false;

                                            if (checkForArrive) {
                                              //로그인 되어있으면 넘어가기
                                              //uploadInfo();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AuthEmailPage()),
                                                  (route) => false);
                                            }
                                          });
                                        } catch (e) {
                                          print('Error sending POST request : $e');
                                        }
                                      } else {
                                        _differentPasswordPopUp();
                                      }
                                      ;
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
              ),
            ),
            Positioned(
                left: 10,
                top: 30,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white54),
                    iconSize: 30)),
            isPressed == true
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox(width: 0, height: 0),
          ],
        ),
      ),
    );
  }

  void _differentPasswordPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("비밀번호가 다릅니다")),
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

  Future<void> checkDuplication(String username) async {
    String name = username ?? '';
    if (await checkUsername(name) == true) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('사용 가능한 username 입니다')),
        );
    }
    if (username == '') {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('username 을 넣어주세요')),
        );
    }

    if (await checkUsername(name) == false) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('이미 존재하는 username 입니다')));
    }
  }

  Future<bool> checkUsername(String username) async {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain; // responseType 설정
    String url =
        'http://kdh.supomarket.com/auth/username'; // 수정요망 (https://) 일단 뺌  --> 앞에 http든 https 든 꼭 있어야되구나!!

    try {
      Map<String, String> data = {'username': username};
      Response response = await dio.get(url, data: data);

      if (response.statusCode == 200) {
        String exist = response.data.trim();

        if (exist == 'true') {
          return true;
        } // 가능
        if (exist == 'false') {
          return false;
        } // 불가능
      } else {
        print('Failed to get response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }
    return false;
  }

  void _alreadyExistPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("이미 존재하는 계정입니다")),
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

  void _weakPasswordPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("너무 비밀번호가 약합니다")),
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
