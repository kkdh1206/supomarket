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
import 'package:supo_market/page/util_function.dart';
import '../../entity/board_entity.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';

import '../../entity/util_entity.dart';
import '../../infra/users_info_data.dart';

class SubQnAPageModifyPage extends StatefulWidget {
  final Board board;

  const SubQnAPageModifyPage({Key? key, required this.board}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubQnAPageModifyPageState();
  }
}

class _SubQnAPageModifyPageState extends State<SubQnAPageModifyPage> {
  int activeIndex = 0;

  Board newBoard = Board(
      id: 0,
      title: "",
      description: "",
      boardStatus: BoardStatus.PUBLIC,
      userName: "",
      userStudentNumber: "");

  String newTitle = "";
  String newDescription = "";
  bool isPrivate = false;

  @override
  void initState() {
    debugPrint("Modify Page Initialize");
    newBoard = widget.board;
    activeIndex = 0;
    isPrivate = widget.board.boardStatus == BoardStatus.PRIVATE;
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
        flexibleSpace: Container(color: Colors.white),
        leading: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: IconButton(
                onPressed: () async {
                  Navigator.pop(
                      context,
                      ReturnType(
                          newTitle: newTitle,
                          newDescription: newDescription,
                          returnType: "exit",
                          newStatus: newBoard.boardStatus!));
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black45),
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
                          newStatus: newBoard.boardStatus!,
                          returnType: "modified"));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: postechRed.withOpacity(1.0)),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("수정하기",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
              width: 500,
              child: const Divider(color: Colors.black45, thickness: 0.5)),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 25),
                child: Text("제목", style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: widget.board.title,
                  onChanged: (text) {
                    setState(() {
                      newTitle = text;
                    });
                  },
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                    label: Center(
                      child: Text(
                        '제목을 입력하세요',
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 200),
                child: Text("내용", style: TextStyle(fontSize: 20)),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: widget.board.description,
                  onChanged: (text) {
                    setState(() {
                      newDescription = text;
                    });
                  },
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                    label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '내용을 입력하세요',
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 20),
              const Text("비밀글 ", style: TextStyle(fontSize: 20)),
              CupertinoSwitch(
                // 급처분 여부
                value: isPrivate,
                activeColor: CupertinoColors.activeOrange,
                onChanged: (bool? value) {
                  // 스위치가 토글될 때 실행될 코드
                  setState(() {
                    newBoard.boardStatus = (value == true
                        ? BoardStatus.PUBLIC
                        : BoardStatus.PRIVATE);
                    isPrivate = value ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
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
