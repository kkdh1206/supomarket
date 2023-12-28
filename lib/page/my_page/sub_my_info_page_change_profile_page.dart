import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/util_entity.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../control_page.dart';
import '../log_in_page/register_page.dart';

class SubMyInfoPageChangeProfilePage extends StatefulWidget {
  const SubMyInfoPageChangeProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubMyInfoPageChangeProfilePageState();
  }
}

class _SubMyInfoPageChangeProfilePageState
    extends State<SubMyInfoPageChangeProfilePage> {
  TextEditingController userName = TextEditingController();
  bool isChecked = false;
  bool isLoading = false;
  String? originalImage;
  String? originalName;
  XFile? image;
  File? file;
  String? name;
  bool isImageChanged = false;
  bool isNameChanged = false;

  Future<void> passwordUpdate(String newPassword) async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      setPasswordInDevice(newPassword);
      debugPrint("비밀번호 변경 완료");
    }
  }

  @override
  void initState() {
    super.initState();
    originalImage = myUserInfo.imagePath;
    originalName = myUserInfo.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black45),
                iconSize: 30)),
        flexibleSpace: Container(color: Colors.white),
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          )
              : const SizedBox(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Container(
                        height: 120,
                        width: 120,
                        child: Stack(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _storeImage();
                                },
                                icon: isImageChanged == false? ClipOval(
                                    child: Image.network(
                                      myUserInfo!.imagePath!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    )) :
                                ClipOval(
                                    child: Image.file(file!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ))
                            ),
                            Center(
                              child: IconButton(
                                icon: Icon(Icons.image,
                                    color: Colors.white.withOpacity(0.8)),
                                onPressed: () {
                                  _storeImage();
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const SizedBox(
                  width: 500,
                  child: Divider(color: Colors.black, thickness: 0.1)),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Stack(
                        children: [
                          TextFormField(
                            initialValue: myUserInfo.userName,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                enabledBorder: UnderlineInputBorder(),
                                hintText: '이름을 입력하세요'),
                            onChanged: (text) {
                              setState(() {
                                isNameChanged = true;
                                name = text;

                              });
                            },
                          ),
                          Positioned(
                            right : 5,
                            top : 10,
                            child: Container(
                              width: 75,
                              height: 28,
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(name!=null){
                                    checkDuplication(name!);
                                  }
                                  else{
                                    name = 'ㅈㅓㅇㅇㅠㅈㅣㄴ'; // 오류 내기 위해 일부러 넣음
                                    checkDuplication(name!);
                                  }
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.grey,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                if(isNameChanged){
                  if(isChecked){
                    await patchProfileName(name ?? myUserInfo.userName!);
                  }
                  else{
                    _checkNickNamePopUp();
                  }

                }
                if(isImageChanged){
                  await patchProfileImage(file!);
                }
                Navigator.pop(context);
              },
              child: const Text("적용하기",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _storeImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      image = XFile(pickedFile.path);
      file = File(image!.path);
      isImageChanged = true;
      setState(() {});
    }
  }

  Future<bool> patchProfileImage(dynamic? file) async {

    print("이미지 변경");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();
    print('modify profile');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/patch/userinformation/image';

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: 'image.jpg'),
    });

    try {
      Response response = await dio.patch(url, data: formData);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      isLoading = false;
    });

    return true;
  }

  Future<bool> patchProfileName(String name) async {

    print("이름 변경");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();
    print('modify profile');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/patch/userinformation/username';

    var data = {'username': name };

    try {
      Response response = await dio.patch(url, data:data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      isLoading = false;
    });

    return true;
  }

  Future<bool> resetProfile(String imageUrl) async {

    debugPrint("프로필 원상복구 ");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();
    print('modify profile');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/patch/userinformation/image2';

    var data = {'image' : imageUrl };

    try {
      Response response = await dio.patch(url, data: data);
      myUserInfo.imagePath = response.data['image'];
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      isLoading = false;
    });

    return true;
  }
  Future<bool> checkUsername(String username) async {
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain; // responseType 설정
    String url =
        'https://kdh.supomarket.com/auth/username';

    //빈칸이면 오류나서 이렇게 보낼게
    username = username==""?'ㅈㅓㅇㅇㅠㅈㅣㄴ':username;

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

}

