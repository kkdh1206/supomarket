
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../infra/my_info_data.dart';
import '../../../retrofit/RestClient.dart';
import '../../welcome_page.dart';

MyPageUsecase myPageUsecase = MyPageUsecase();

class MyPageUsecase{

  void logOutPopUp(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          //화면 잘리는 것 방지
          content: const SingleChildScrollView(child:Text("로그아웃 하시겠습니까?")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("예"),
                  onPressed: () async {
                    //로그아웃
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    myUserInfo.isUserLogin = false;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (BuildContext context) => WelcomePage()), (route) => false);
                  },
                ),
                TextButton(
                  child: const Text("아니오"),
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

  Future<void> postKeyword(String text) async {

    print("post Keyword");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/items/myAlarmCategory';

    var data = {'category': text};

    try {
      Response response = await dio.post(url, data: data);
    } catch (e) {
      print('Error sending POST request : $e');
    }

    return;
  }


  Future<void> patchKeyword(String text) async {
    print("patch Keyword");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/items/myAlarmCategory';

    var data = {'category': text};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending POST request : $e');
    }

    return;
  }

  Future<bool> getKeyword(List<String> list) async {
    print("get Keyword");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/items/myAlarmCategory';

    list.clear();

    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;

      print("??");
      for (int i = 0; i < jsonData.length; i++) {
        list.add(jsonData[i]);
      }
      //print(jsonData[0]);
      // list = List<String>.from(jsonData['alarmList']);
      print(list.toString());
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }

}
