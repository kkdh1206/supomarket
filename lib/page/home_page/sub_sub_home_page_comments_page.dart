import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../my_page/widgets/board_page_widgets.dart';
import '../util_function.dart';

class SubSubHomePageCommentsPage extends StatefulWidget {

  final int itemID;

  const SubSubHomePageCommentsPage({super.key, required this.itemID});

  @override
  State<StatefulWidget> createState() {
    return SubSubHomePageCommentsPageState();
  }

}

class SubSubHomePageCommentsPageState extends State<SubSubHomePageCommentsPage> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController comment = TextEditingController();
  List<Map<String, dynamic>> commentList = [];
  String inputText = "";

  @override
  void initState() {
    super.initState();
    inputText = "";
    subSubHomePageCommentsPageBuilder = _getComment();
  }

  void scrollToBottom(BuildContext context) {
    final isKeyboardOpen = MediaQuery
        .of(context)
        .viewInsets
        .bottom > 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: subSubHomePageCommentsPageBuilder,
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
                      left: 10, top: 20,
                      child: IconButton(onPressed: () {
                        Navigator.pop(context);
                      },
                          icon: const Icon(
                              Icons.arrow_back_ios, color: Colors.black),
                          iconSize: 30)
                  ),
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
      bottomNavigationBar: BottomAppBar(
        height: 55,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomAppBar(
              elevation: 0,
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
                  await _postComment(inputText, widget.itemID.toString());
                  await _getComment();
                  comment.clear();
                  scrollToBottom(context);
                },
                controller: comment,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<bool> _postComment(String content, String itemID) async {
    String token = await firebaseAuth.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'http://kdh.supomarket.com/itemComment'; // 여기에 api 랑 endpoint 추가해야됨

    Map<String, dynamic> data = {
      'content': content,
      'username': myUserInfo.userName!,
      'itemId': itemID,
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

  Future<bool> _getComment() async {

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    String url = 'http://kdh.supomarket.com/items/comment/${widget.itemID}';

    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;
      print(response);

      if (jsonData.toString() != "true") {

        commentList = [];
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