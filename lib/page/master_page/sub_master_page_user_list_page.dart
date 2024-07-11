import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import '../../entity/item_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../log_in_page/log_in_page.dart';
import '../util_function.dart';

class SubMasterPageUserListPage extends StatefulWidget {
  const SubMasterPageUserListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubMasterPageUserListPageState();
  }
}

class _SubMasterPageUserListPageState extends State<SubMasterPageUserListPage> {
  int refreshNum = 0;

  bool isMoreRequesting = false;

  int page = 1;
  int pageSize = 10;

  List<AUser> list = [];

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;
  bool isLoading = false;

  @override
  void initState() {
    debugPrint("Home Initiate");
    super.initState();
    onePageUpdateList();
    isEnded = false; //리스트 끝에 도달함
    page = 1;
    refreshNum = 0; //새로고침 시
    scrollOffset = 0.0;
    scrollController!.addListener(_scrollListener); //스크롤뷰 위치 이용 함수
    isMoreRequesting = false; //요청 중이면 circle progress
    isListened = false; //progress가 돌아가고 있으면 추가로 요청하지 않기 (한번만)
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _scrollListener() {
    if (scrollController!.offset + 500 >=
            scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange &&
        !isListened &&
        !isEnded) {
      // 리스트의 마지막에 도달하면 새로운 리스트 아이템을 가져오는 함수 호출
      page++;
      isListened = true;
      updateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        toolbarHeight: 40,
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: homePageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("총 유저 수 : ${list.length.toString()}", style: const TextStyle(fontSize : 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          refreshNum += 1;
                          onePageUpdateList();
                        },
                        child: ListView.builder(
                          controller: scrollController,
                          itemBuilder: (context, position) {
                            return GestureDetector(
                                child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                                "이름 : ${list![position].userName}"),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                                "이메일 : ${list![position].email}"),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                                "상태 : : ${ConvertEnumToString(list![position].userStatus)}"),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text("온라인 : "),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {});
                          },
                          itemCount: list?.length,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        isMoreRequesting
                            ? Container(
                                height: 20.0,
                                width: 20.0,
                                color: Colors.transparent,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox(width: 0, height: 0),
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

  void updateList() async {
    debugPrint("update List 함수 호출");
    await getInfoAllUser(page, list);
    isListened = false;
  }

  void onePageUpdateList() {
    setState(() {
      homePageBuilder = getInfoAllUser(1, list);
    });
  }

  Future<bool> getInfoAllUser(int page, List<AUser> list) async {
    debugPrint("요청");
    int pageSize = 10;

    var token = await firebaseAuth.currentUser?.getIdToken();
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    // dio.options.responseType = ResponseType.plain; // responseType 설정
    String url = 'https://kdh.supomarket.com/auth/allUser';

    if (page == 1) {
      list.clear();
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isMoreRequesting = true;
      });
    }

    try {
      Response response = await dio.get(url);
      dynamic jsonData = response.data;

      if (jsonData.toString() != "true") {
        print("Response는 ${response}");

        for (var data in jsonData) {
          String Email = data['Email'] as String;
          String username = data['username'] as String;
          String userstatus = data['status'] as String;
          // bool online = data['online'] as bool;

          list.add(AUser(
              email: Email,
              userName: username,
              imagePath: "",
              isUserLogin: true,
              userStatus: convertStringToEnum(userstatus)));
          print("add");
        }

        if (page == 1) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isMoreRequesting = false;
          });
        }
      } else {
        setState(() {
          isEnded = true;
          isMoreRequesting = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }
}
