import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/util_function.dart';

import '../../infra/users_info_data.dart';

class SubSellingPageSelectionPage extends StatefulWidget {
  final List<String> nameList;
  final List<String> userUidList;
  final String itemId;

  const SubSellingPageSelectionPage ({super.key, required this.nameList, required this.userUidList, required this.itemId, });

  @override
  State<StatefulWidget> createState() {
    return SubSellingPageSelectionPageState();
  }

}

class SubSellingPageSelectionPageState extends State<SubSellingPageSelectionPage >{

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;


    List<String> nameList = widget.nameList;
    List<String> userUidList = widget.userUidList;

    String traderName = nameList[0];
    String traderUid = userUidList[0];

    int selectedIndex = 0;

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color : Colors.black),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("누구와 거래하셨나요?", style: TextStyle(fontSize : 25)),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 50,
                        backgroundColor: Colors.white,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            traderName = nameList[index];
                            traderUid = userUidList[index];
                            selectedIndex = index;
                          });
                        },
                        children: List<Widget>.generate(nameList.length, (index) {
                          return Center(
                            child: Text(
                                  nameList[index],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      height: 60,
                      child: TextButton(
                          onPressed: () async {
                            if(widget.userUidList.isNotEmpty) {
                              await postRequestList(traderUid, widget.itemId);
                            }
                            Navigator.popUntil(context, ModalRoute.withName("/"));
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
                                '확인',
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
                    SizedBox(height: height * 0.2),
                  ],
                ),
                isLoading ? const Center(
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
                ) : const SizedBox(width: 0, height: 0),
              ],
            ),
          ),
        ));
  }

  Future<bool> postRequestList(String userUid, String itemId) async {

    print("post Request List $userUid ${int.parse(itemId)}");

    if(userUid == null){
      print("uid는 Null");
      userUid = "steadfastness";
    }

    //없애기 이부분
    userUid = "E3GFCEbDoyTfjKbt3MkTlsOzRph2";
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/auth/request';

    Map<String, dynamic> data = {'buyerUid' : userUid, 'itemId' : int.parse(itemId)};

    try {
      Response response = await dio.post(url, data: data);
    } catch (e) {
      print('Error sending POST request : $e');
    }

    setState(() {
      isLoading = false;
    });

    return true;
  }
}






