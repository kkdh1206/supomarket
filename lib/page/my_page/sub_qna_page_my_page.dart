import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supo_market/entity/item_entity.dart';
import 'package:supo_market/entity/util_entity.dart';
import 'package:supo_market/page/my_page/sub_qna_page_add_board_page.dart';
import 'package:supo_market/page/my_page/sub_qna_page_board_page.dart';
import 'package:supo_market/page/my_page/sub_qna_page_modify_page.dart';
import 'package:supo_market/page/my_page/sub_qna_page_search_page.dart';
import 'package:supo_market/page/my_page/sub_setting_page_alarm_page.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/board_entity.dart';
import '../../entity/user_entity.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';

class SubQnaPageMyPage extends StatefulWidget {
  const SubQnaPageMyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubQnaPageMyPageState();
  }
}

class SubQnaPageMyPageState extends State<SubQnaPageMyPage> {
  final _controller = PageController();
  int _currentPage = 1;
  int refreshNum = 0;

  ScrollController scrollController = ScrollController();
  bool isEnded = false;
  String allListNum = "0";
  bool isLoading = false;

  List<Board> list = [];

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('내가 올린 질문',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'KBO-M',
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ],
          ),
        ),
        body: FutureBuilder(
            future: myQnaPageBuilder,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                refreshNum += 1;
                                updateList();
                              },
                              child: ListView.builder(
                                controller: scrollController,
                                itemBuilder: (context, position) {
                                  //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                                  list![position].uploadDate = formatDate(
                                      list![position].uploadDateForCompare ??
                                          DateTime.now());
                                  //급처분 아이템은 보여주지 않기
                                  return GestureDetector(
                                      child: Card(
                                        color: Colors.grey[200],
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                list![position].boardStatus ==
                                                        BoardStatus.PRIVATE
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15),
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                          "assets/images/icons/lock.png",
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 40, height: 40),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  height: 40,
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8),
                                                              child: Text(
                                                                  list![position]
                                                                              .boardStatus ==
                                                                          BoardStatus
                                                                              .PRIVATE
                                                                      ? "비밀글 입니다"
                                                                      : list![position]
                                                                          .title!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 2),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            8),
                                                                child: Text(
                                                                    "등록 일자: ${list![position].uploadDate ?? ""}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontFamily:
                                                                            'KBO-L',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
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
                                                      EdgeInsets.only(right: 0),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 25,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () async {
                                                      var newData = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SubQnAPageModifyPage(
                                                                      board: list![
                                                                          position])));
                                                      if (newData.returnType == "modified") {
                                                        await modify(list![position]!.id!, newData.newTitle, newData.newDescription, ConvertEnumToString(newData.newStatus));
                                                        await getBoardMyPage();
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      color: Colors.grey[600],
                                                    ),
                                                    onPressed: () async {
                                                      await delete(
                                                          list![position].id!);
                                                      await getBoardMyPage();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubQnAPageBoardPage(
                                                        board: list![position],
                                                        user: getUserInfo2(
                                                            list![position]))));
                                      });
                                },
                                itemCount: list?.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                      isLoading == true
                          ? const Center(
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
                            )
                          : const SizedBox(),
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
            }));
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
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateList() async {
    debugPrint("페이지 변경 => ${_currentPage}");
    myQnaPageBuilder = getBoardMyPage();
  }

  Future<bool> delete(int id) async {
    int pageSize = 7;
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    print(id);
    String url = 'https://kdh.supomarket.com/boards/status/$id';

    setState(() {
      isLoading = true;
    });
    var data = {'status': 'DELETED'};

    try {
      Response response = await dio.patch(url, data: data);
      dynamic jsonData = response.data;
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    setState(() {
      isLoading = false;
    });

    return true;
  }

  Future<bool> getBoardMyPage() async {
    int pageSize = 7;
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/boards/myBoards';

    setState(() {
      isLoading = true;
    });

    list?.clear();

    try {
      Response response = await dio.get(url);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;

      if (jsonData.toString() != "true") {
        debugPrint("List 개수 update");

        await Future.delayed(Duration(milliseconds: 100));

        for (var data in jsonData) {
          int id = data['id'] as int;
          String title = data['title'] as String;
          String description = data['description'] as String;
          String boardStatus = data['status'] as String;
          BoardStatus status = convertStringToEnum(boardStatus);

          String updatedAt = data['updatedAt'] as String;
          DateTime dateTime = DateTime.parse(updatedAt);

          list?.add(Board(
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

    setState(() {
      isLoading = false;
    });

    setState(() {});

    return true;
  }

  Future<bool> modify(
      int boardId, String title, String description, String status) async {
    print("modify function");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    print('add Item To Server');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/boards/myBoards/${boardId}';

    var data = {
      "title": title,
      "description": description,
      "status": status,
    };

    try {
      Response response = await dio.patch(url, data: data);
      print(response);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    return true;
  }
}
