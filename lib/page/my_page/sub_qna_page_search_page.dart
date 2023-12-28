import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/category_page/category_page.dart';
import 'package:supo_market/page/my_page/sub_qna_page_board_page.dart';
import 'package:supo_market/page/sub_add_goods_page.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/board_entity.dart';
import '../../entity/user_entity.dart';
import '../../infra/my_info_data.dart';

class SubQnAPageSearchPage extends StatefulWidget {
  final List<Board> list;

  const SubQnAPageSearchPage({super.key, required this.list});

  @override
  _SubQnAPageSearchPageState createState() => _SubQnAPageSearchPageState();
}

class _SubQnAPageSearchPageState extends State<SubQnAPageSearchPage> {
  List<Board> searchList = [];
  final _controller = PageController();
  int _currentPage = 1;

  int refreshNum = 0;
  int loadingCount = 0;
  double _dragDistance = 0;
  bool isMoreRequesting = false;
  Future<String>? _futureResult;
  int searchCount = 0;
  String searchText = "";

  int page = 1;
  int pageSize = 10;
  String allListNum = "0";

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    searchList = widget.list;
    refreshNum = 0;
    debugPrint("qna_search_initiate");
  }

  @override
  void dispose() {
    debugPrint("control_dispose");
    qnaSearchPageBuilder = null;
    super.dispose();
  }

  void enterFunction(String value) async {
    debugPrint("enter Function");
    setState(() {
      searchText = value;
      qnaSearchPageBuilder = getBoardSearch(value, _currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading : IconButton(icon : Icon(Icons.arrow_back_ios), color: Colors.black, onPressed: () { Navigator.pop(context);},),
          flexibleSpace: Container(color: Colors.white),
          elevation: 0.0,
          //toolbarHeight: 100.0,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 0, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: enterFunction,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: '제목 검색',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white),
      body: FutureBuilder(
          future: qnaSearchPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!searchList.isEmpty) {
                return Center(
                  //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        color: Colors.white,
                        height: 150.0,
                        // child: NotificationListener<ScrollNotification>(
                        //   onNotification: (ScrollNotification notification) {
                        //     scrollNotification(notification);
                        //     return false;
                        //   },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            refreshNum += 1;
                            setState(() {});
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            itemBuilder: (context, position) {
                              //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                              searchList![position].uploadDate = formatDate(
                                  searchList![position].uploadDateForCompare ??
                                      DateTime.now());
                              //uploadDate를 현재 시간 기준으로 계속 업데이트하기

                                return GestureDetector(
                                  onTap: () {
                                    if (searchList[position].boardStatus ==
                                        BoardStatus.PRIVATE &&
                                        myUserInfo.userStatus !=
                                            UserStatus.ADMIN) {
                                      print("비밀글은 접근할 수 없습니다");
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubQnAPageBoardPage(
                                                      board: searchList![
                                                      position],
                                                      user: getUserInfo2(
                                                          searchList![
                                                          position]))));
                                    }
                                  },
                                  child: Card(
                                    color: Colors.grey[200],
                                    margin:
                                    const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10),
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            searchList![position].boardStatus == BoardStatus.PRIVATE?
                                            Container(
                                              padding:
                                              EdgeInsets.only(
                                                  left: 15),
                                              height: 40,
                                              width: 40,
                                              child: Image.asset(
                                                "assets/images/icons/lock.png",
                                              ),
                                            )
                                                : Container(width : 40, height: 40),
                                            Container(
                                              padding:
                                              EdgeInsets.only(
                                                  left: 15),
                                              height: 40,
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                        height: 10),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left:
                                                                  8),
                                                              child: Text(
                                                                  searchList![position].boardStatus == BoardStatus.PRIVATE
                                                                      ? "비밀글 입니다"
                                                                      : searchList
                                                                  ![position]
                                                                      .title!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                      20,
                                                                      fontWeight: FontWeight
                                                                          .bold),
                                                                  overflow:
                                                                  TextOverflow.ellipsis),
                                                            )),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 2),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                left:
                                                                8),
                                                            child: Text(
                                                                "등록 일자: ${searchList![position].uploadDate ?? ""}",
                                                                style: const TextStyle(
                                                                    fontSize: 10,
                                                                    fontFamily: 'KBO-L',
                                                                    fontWeight: FontWeight.bold),
                                                                overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 10),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                              EdgeInsets.only(
                                                  right: 10),
                                              child: Icon(
                                                Icons
                                                    .arrow_forward_ios_sharp,
                                                size: 30,
                                                color:
                                                Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            },
                            itemCount: searchList.length, //아이템 개수만큼 스크롤 가능
                          ),
                        ),
                      )),
                      //),
                      isMoreRequesting
                          ? Container(
                              height: 20.0,
                              width: 20.0,
                              color: Colors.white,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox(width: 0, height: 0),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("검색된 물품이 없습니다"),
                        ],
                      ),
                    ],
                  ),
                );
              }
            } else if (qnaSearchPageBuilder == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("검색어를 입력해주세요"),
                      ],
                    ),
                  ],
                ),
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
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<bool> getBoardSearch(String input, int page) async {
    //여기좀 해봐
    int pageSize = 7;
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/boards/search?title=${input}&page=${page}&pageSize=${pageSize}';

    searchList?.clear();

    try {
      Response response = await dio.get(url);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;

      if (response.toString() != "true") {
        //공백이면 true 주기

        await Future.delayed(Duration(milliseconds: 100));

        for (var data in jsonData) {
          int id = data['id'] as int;
          String title = data['title'] as String;
          String description = data['description'] as String;
          String boardStatus = data['status'] as String;
          BoardStatus status = convertStringToEnum(boardStatus);
          String createdAt = data['createdAt'] as String;
          String updatedAt = data['updatedAt'] as String;
          DateTime dateTime = DateTime.parse(updatedAt);

          searchList?.add(Board(
              id: id,
              title: title,
              description: description,
              boardStatus: status,
              userName: "",
              userStudentNumber: "",
              uploadDate: "방금 전",
              uploadDateForCompare: dateTime));
        }
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }

    await getAllBoardNumSearch(_currentPage, searchText);

    return true;
  }

  Future<void> _goToPage(int index) async {
    debugPrint("Go To index $index");
    if (index >= 0 && index < 10) {
      _controller.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    await updateList();
  }

  Future<void> updateList() async {
    debugPrint("페이지 변경 => ${_currentPage}");
    qnaSearchPageBuilder = getBoardSearch(searchText, _currentPage);
    isListened = false;
  }

  Future<bool> getAllBoardNumSearch(int page, String newTitle) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/boards/search/count?title=${newTitle}';

    try {
      Response response = await dio.get(url);
      allListNum = response.data;
      if (int.parse(allListNum) / (7 * _currentPage) < 1) {
        setState(() {
          isEnded = true;
        });
      } else {
        setState(() {
          isEnded = false;
        });
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }
}
