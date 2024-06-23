import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/log_in_page/agreement.dart';
import 'package:supo_market/page/log_in_page/widgets/log_in_page_widget.dart';
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
  bool isAgree = false;
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

  // 비밀번호 7자리 이상, 아이디는 이메일 폼
  Future<void> createEmailAndPassword(String id, String password,
      String userName, String newUserSchoolNum) async {
    if(newUserSchoolNum == "" || id == "" || password == "" || userName == ""){
      print("입력 하나를 안함");
      _checkAllthing();
      setState(() {
        isPressed = false;
      });
    }
    else if(isChecked==false){
      print("닉네임 중복 확인안함");
      _checkNickNamePopUp();
      setState(() {
        isPressed = false;
      });
    }
    else if(isAgree == false) {
      print("사용약관 동의안함");
      _checkAgree();
      setState(() {
        isPressed = false;
      });
    }
    else {
      try {
        final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: id,
          password: password,
        );
        if (credential.user != null) {
          allUserList.add(credential);
          credential.user?.updateDisplayName(newNickName);
          setState(() {
            isPressed = false;
          });
          return;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _weakPasswordPopUp();
          print('비밀번호는 8자리 이상이어야 합니다.');
          setState(() {
            isPressed = false;
          });
        } else if (e.code == 'email-already-in-use') {
          _alreadyExistPopUp();
          print('이미 존재하는 이메일 입니다.');
          setState(() {
            isPressed = false;
          });
        }
      } catch (e) {
        print(e);
      }

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
          SingleChildScrollView(
            child: Container(
              //padding: EdgeInsets.only(
              // top: MediaQuery.of(context).size.height * 0.23),
              child: Stack(
                children: [
                  Column(children: [
                    const SizedBox(height: 100),
                    SupoTitle3(),
                    const SizedBox(height: 60),
                    TextInputwithButton(
                        hintText: '이메일',
                        onChanged: (text) {
                          setState(() {
                            newID = "$text@postech.ac.kr";
                          });
                        }),
                    TextInputwithButton(
                        hintText: '비밀번호',
                        onChanged: (text) {
                          setState(() {
                            newPassword = text;
                          });
                        }),
                    TextInputwithButton(
                        hintText: '비밀번호 재입력',
                        onChanged: (text) {
                          setState(() {
                            newPassword2 = text;
                          });
                        }),
                    TextInputwithButton(
                        hintText: '이름',
                        onChanged: (text) {
                          setState(() {
                            newRealName = text;
                          });
                        }),
                    Stack(
                      children: [
                        TextInputwithButton(
                            hintText: '닉네임 (2자리 이상)',
                            onChanged: (text) {
                              setState(() {
                                newNickName = text;
                                isChecked = false; // 바꾸면 false 로 계속 업데이트를 해줌
                              });
                            }),
                        Positioned(
                          right : 5,
                          top : 10,
                          child: Container(
                            width: 75,
                            height: 28,
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                checkDuplication(newNickName);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.grey[600],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 0.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: Text(
                                "중복확인",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'KBO-B'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    TextInputwithButton(
                        hintText: '학번/직번(20240000)',
                        onChanged: (text) {
                          setState(() {
                            newUserSchoolNum = text;
                          });
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: isAgree,
                            onChanged: (value) {
                              setState(() {
                                isAgree = value!;
                              });
                            }
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AgreementPage()),
                            );
                          },
                          child: Text(
                            '사용약관 확인 및 동의',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 325,
                            height: 60,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFB70001),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15.0), // 원하는 둥근 정도 설정
                                  ),
                                ),
                                onPressed: () async {
                                  if (newPassword.compareTo(newPassword2) ==
                                      0) {
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
                                      dio.options.headers['Authorization'] =
                                      'Bearer $token';
                                      String url =
                                          'https://kdh.supomarket.com/auth/signup'; // 여기에 api 랑 endpoint 추가해야됨

                                      Map<String, String> data = {
                                        'Email': newID,
                                        'username': newNickName,
                                        'realname': newRealName,
                                        'studentNumber': newUserSchoolNum
                                      };
                                      Response response =
                                      await dio.post(url, data: data);

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
                                },
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '회원가입',
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
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ),
          ),
          Positioned(
              left: 10,
              top: 50,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                  iconSize: 30)),
          isPressed == true
              ? const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
              : const SizedBox(width: 0, height: 0), // 아무것도 없으면 크기없는 상자둔듯
        ],
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

  void _alreadyExistPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("이미 사용중인 이메일입니다.\n만약 해당 메일로 계정을 만드신 적이 없다면\nsupomarket@naver.com 으로 메일 부탁드립니다.")),
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
      isChecked = true;
    }

    else if (await checkUsername(name) == false) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('이미 존재하는 username 입니다')));
      isChecked = false;
    }
  }

  Future<bool> checkUsername(String username) async {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain; // responseType 설정
    String url =
        'https://kdh.supomarket.com/auth/username';

    //빈칸이면 오류나서 이렇게 보낼게
    username = username==""?'슈피':username;

    print(username);
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

  // void _alreadyExistPopUp() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, //여백을 눌러도 닫히지 않음
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: const SingleChildScrollView(child: Text("이미 존재하는 계정입니다")),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               TextButton(
  //                 child: const Text("확인"),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

  void _checkNickNamePopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("닉네임 중복확인을 확인해주세요")),
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

  void _checkAgree() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("사용약관 동의를 확인해주세요.")),
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

  void _checkAllthing() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("모든 정보를 입력해주세요")),
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