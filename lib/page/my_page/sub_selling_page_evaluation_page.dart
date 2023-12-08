import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/util_function.dart';

import '../../infra/users_info_data.dart';
import '../control_page.dart';

class SubSellingPageEvaluationPage extends StatefulWidget {
  final int userID;

  const SubSellingPageEvaluationPage({super.key, required this.userID});

  @override
  State<StatefulWidget> createState() {
    return SubSellingPageEvaluationPageState();
  }

}

class SubSellingPageEvaluationPageState extends State<SubSellingPageEvaluationPage>{

  @override
  void initState() {
    print("evaluage page initiate : ${widget.userID}");
    super.initState();
  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color : Colors.black),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName("control"));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ControlPage()));
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('거래는 만족스러웠나요?',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'KBO-B',
                    fontWeight: FontWeight.w700,
                    fontSize: 35)),
            Text(''),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await patchEvaluation(widget.userID, 5);
                    isLoading = true;
                    Navigator.popUntil(context, ModalRoute.withName("control"));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ControlPage()));
                    isLoading = false;
                    },
                  child: Image.asset(
                    'assets/images/good1.jpeg',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () async {
                    isLoading = true;
                    await patchEvaluation(widget.userID, -5);
                    isLoading = false;
                   // checkRequestList(context);
                    Navigator.popUntil(context, ModalRoute.withName("control"));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ControlPage()));
                  },
                  child: Image.asset(
                    'assets/images/bad1.jpeg',
                    width: 150,
                    height: 150,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ));
  }

  Future<bool> patchEvaluation(int userId, int score) async {

    print("patch Evaluation : $userId");

    String token = await firebaseAuth.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    String url = 'http://kdh.supomarket.com/auth/userScore/$userId';


    var data = {'score': score};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    return true;
  }

}


