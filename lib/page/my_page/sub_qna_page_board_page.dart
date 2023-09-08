import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
    // } else {
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // }
  }

  void scrollToBottom(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // if (isKeyboardOpen) {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 100),
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardOpen) {
      scrollToBottom(context);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              isStackOn = !isStackOn;
            });
            if(isStackOn){
              scrollToTop();
            }
          },
              icon: Icon(Icons.chat_bubble, color: Colors.grey)),
        ],
      ),
      body: FutureBuilder(
        future: boardPageBuilder,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: [
              ListView(children: [
                Container(
                  width: 1000,
                  color: Colors.white,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("제목")),
                      DataColumn(label: Text("${board.title}")),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('작성자')),
                        DataCell(Text('${board.userName}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('작성 일시')),
                        DataCell(Text('${board.uploadDate}')),
                      ]),
                    ],
                    showBottomBorder: true,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Container(
                      width: 1000,
                      color: Colors.white,
                      child: Text("${board.description}"),
                    )),

              ]),
              isStackOn==true?
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: commentList.length,
                        itemBuilder: (context, position) {
                          //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                          return GestureDetector(
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.start,
                                      children: [
                                        Expanded(child:
                                        Text(commentList[commentList.length - position - 1]['username'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.start,
                                      children: [
                                        Expanded(child:
                                        Text(commentList[commentList.length -
                                            position -
                                            1]['content']),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        maxLines : null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        onChanged: (text){
                          print("변경!!!");
                          setState(() {
                            inputText = text;
                          });
                        },
                        onSubmitted: (text){
                           print("다음!!!");
                           setState(() {
                             comment.text = text + '\n';
                             comment.selection = TextSelection.fromPosition(TextPosition(offset: comment.text.length));
                             inputText = comment.text;
                           });
                        },
                        controller: comment,
                        // controller 속성을이용해 inputText변수값을 textfield의 초기 입력값으로 사용할 수 있다
                        decoration:
                            InputDecoration(labelText: "Enter your message"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        await postAnswer(inputText);
                        await getAnswer();
                        comment.clear();
                        scrollToBottom(context);
                      }
                    ),
                  ]),
                  SizedBox(height: 15),
                ],
              ) : const SizedBox(),
            ]);
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
          ;
        },
      ),
    );
  }

  Future<bool> postAnswer(String content) async {
    String token = await firebaseAuth.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'http://kdh.supomarket.com/comment'; // 여기에 api 랑 endpoint 추가해야됨

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
  }

  Future<bool> getAnswer() async {
    print("getAnswer => ${board.id}");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    String url = 'http://kdh.supomarket.com/boards/comment/${board.id}';

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

    return true;
  }
}
