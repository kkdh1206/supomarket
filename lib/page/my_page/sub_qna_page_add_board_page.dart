import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supo_market/entity/user_entity.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/home_page/sub_picture_page.dart';
import 'package:supo_market/page/my_page/widgets/board_page_widgets.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/board_entity.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';

import '../../entity/util_entity.dart';
import '../../infra/users_info_data.dart';

class SubQnAPageAddBoardPage extends StatefulWidget {
  const SubQnAPageAddBoardPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubQnAPageAddBoardPageState();
  }
}

class _SubQnAPageAddBoardPageState extends State<SubQnAPageAddBoardPage> {
  int activeIndex = 0;
  Board board = Board(
      id: 0,
      title: "",
      description: "",
      boardStatus: BoardStatus.PUBLIC,
      userName: "",
      userStudentNumber: "");
  String newTitle = "";
  String newDescription = "";
  TextEditingController title = TextEditingController();
  TextEditingController detail = TextEditingController();
  bool isPrivate = false;

  @override
  void initState() {
    debugPrint("Sub Home Page Initialize");
    activeIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(color: Colors.white),
          leading: Padding(
              padding: const EdgeInsets.only(top: 0, left: 10),
              child: IconButton(
                  onPressed: () async {
                    Navigator.pop(
                        context,
                        ReturnType(
                            newTitle: newTitle,
                            newDescription: newDescription,
                            returnType: "exit",
                            newStatus: board.boardStatus!));
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  iconSize: 30)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: MaterialButton(
                onPressed: () {
                  if (newTitle.length < 5) {
                    popUp("제목은 5글자 이상이어야 합니다");
                  } else if (newDescription.length < 10) {
                    popUp("내용은 10글자 이상이어야 합니다");
                  } else {
                    Navigator.pop(
                        context,
                        ReturnType(
                            newTitle: newTitle,
                            newDescription: newDescription,
                            newStatus: board.boardStatus!,
                            returnType: "add"));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: postechRed.withOpacity(1.0)),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("등록하기",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                EachTextField(
                  text: '제목',
                  onChanged: (text) {
                    setState(() {
                      newTitle = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    EachTextField(
                      text: '작성자',
                      onChanged: (text) {},
                    ),
                    Container(
                      color: Colors.transparent,
                      width: 1000,
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    EachTextField(
                      text: '작성 일시',
                      onChanged: (text) {},
                    ),
                    Container(
                      color: Colors.transparent,
                      width: 1000,
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                EachTextField(
                  text: '문의 내용',
                  onChanged: (text) {
                    setState(() {
                      newDescription = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(width: 30),
                    const Text("비밀글 ", style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'KBO-B'),
                    ),
                    CupertinoSwitch(
                      // 급처분 여부
                      value: isPrivate,
                      activeColor: mainColor,
                      onChanged: (bool? value) {
                        // 스위치가 토글될 때 실행될 코드
                        setState(() {
                          board.boardStatus = (value == false ? BoardStatus.PUBLIC : BoardStatus.PRIVATE);
                          isPrivate = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ]),
        ));
  }

  void popUp(String value) {
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
}

class ReturnType {
  String newTitle = "";
  String newDescription = "";
  BoardStatus newStatus = BoardStatus.PUBLIC;
  String returnType = "";

  ReturnType({
    required this.newTitle,
    required this.newDescription,
    required this.newStatus,
    required this.returnType,
  });
}
