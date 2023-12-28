import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
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

class SubQnAPageBoardPage extends StatefulWidget {
  final Board board;
  final Future<AUser> user;

  const SubQnAPageBoardPage({Key? key, required this.board, required this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubQnAPageBoardPageState();
  }
}

class _SubQnAPageBoardPageState extends State<SubQnAPageBoardPage> {
  int activeIndex = 0;
  String inputText = "";
  Board board = Board(
      id: 0,
      title: "",
      description: "",
      boardStatus: BoardStatus.PUBLIC,
      userName: "",
      userStudentNumber: "");
  TextEditingController comment = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> commentList = [];
  bool isStackOn = false;

  @override
  void initState() {
    debugPrint("Sub Home Page Initialize");
    board = widget.board;
    activeIndex = 0;
    boardPageBuilder = transferUserInfo();
    super.initState();
  }

  Future<void> scrollToTop() async {
    // if (isKeyboardOpen) {

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  void scrollToBottom(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // if (isKeyboardOpen) {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 10),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> transferUserInfo() async {
    debugPrint("transferInfo");
    AUser itemUser = await widget.user;
    board.userStudentNumber = itemUser.userStudentNumber;
    board.userName = itemUser.userName;

    await getAnswer();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    // if (isKeyboardOpen) {
    //   scrollToBottom(context);
    // }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
          future: boardPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  ListView(
                    controller: _scrollController,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: BoardName(text: board.title!),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: BoardOwner(text: board.userName!),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: UploadTime(text: board.uploadDate!),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: BoardContents(text: board.title!),
                            ),
                            const SizedBox(height: 10),
                            Stack(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: commentList.length,
                                  itemBuilder: (context, position) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: CommentCard(
                                        writer: commentList[position]
                                            ['username'],
                                        date: formatDate(
                                            commentList[position]['dateTime']),
                                        content: commentList[position]
                                            ['content'],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                  Positioned(
                      left: 10,
                      top: 20,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.black),
                          iconSize: 30)),
                ],
              );
            } else {
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                ],
              ));
            }
          }),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.white,
              child: new ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: CommentInput(
                  onChanged: (text) {
                    print("변경!!!");
                    setState(() {
                      inputText = text;
                    });
                  },
                  onSubmitted: (text) {
                    print("다음!!!");
                    setState(() {
                      comment.text = text + '\n';
                      comment.selection = TextSelection.fromPosition(
                          TextPosition(offset: comment.text.length));
                      inputText = comment.text;
                    });
                  },
                  onPressed: () async {
                    await postAnswer(inputText);
                    await getAnswer();
                    comment.clear();
                    inputText = "";
                    scrollToBottom(context);
                  },
                  controller: comment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> postAnswer(String content) async {
    String token = await firebaseAuth.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/comment'; // 여기에 api 랑 endpoint 추가해야됨

    if (content != "") {
      Map<String, dynamic> data = {
        'content': content,
        'username': myUserInfo.userName!,
        'boardId': board.id,
      };

      try {
        print(data);
        Response response = await dio.post(url, data: data);
        print(response);
      } catch (e) {
        print('Error sending POST request : $e');
      }

      return true;
    } else {
      print("입력해주세요");
      return true;
    }
  }

  Future<bool> getAnswer() async {
    print("getAnswer => ${board.id}");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    String url = 'https://kdh.supomarket.com/boards/comment/${board.id}';

    try {
      Response response = await dio.get(url);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;
      print(response);

      if (jsonData.toString() != "true") {
        print("들어옴");

        for (var data in jsonData) {
          int id = data['id'] as int;
          String content = data['content'] as String;
          String userName = data['username'] as String;
          String createdAt = data['createdAt'] as String;
          DateTime dateTime = DateTime.parse(createdAt);

          commentList.add(
              {'username': userName, 'content': content, 'dateTime': dateTime});

          debugPrint("add");
        }

        //await moreSpaceFunction();

        setState(() {
          // isMoreRequesting = false;
        });
      } else {
        setState(() {
          //isEnded = true;
        });
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }
    //await scrollToBottom(context);
    return true;
  }
}
