import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

UtilUsecase utilUsecase = UtilUsecase();

class UtilUsecase{

  void popUp(String value, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(child: Text(value)),
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

  Future<void> patchRequestList(String userId, String itemId) async{

    print("patch Really Bought : userId ${userId} itemId ${itemId}");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/auth/request';

    var data = {'sellerId': userId, 'itemId' : itemId};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    return;
  }

  Future<void> postBuyingList(String itemId) async {
    print("post Buy List");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/items/myHistory/add';

    var data = {'itemId': itemId};

    try {
      Response response = await dio.post(url, data: data);
    } catch (e) {
      print('Error sending POST request : $e');
    }

    return;
  }

}
