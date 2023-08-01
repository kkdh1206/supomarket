import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/goods_entity.dart';
import 'package:intl/intl.dart';

import '../../entity/user_entity.dart';
import '../../infra/goods_list_data.dart';


Color postechRed = const Color(0xffac145a);
var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
String searchName = "";

class HomePage extends StatefulWidget {
  final Future<Database> db;
  final List<Goods>? list;
  const HomePage({Key? key, required this.list, required this.db}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List<Goods>? list;
  int refreshNum = 0;
  String selectedOption = "최신 순";
  final options = ["최신 순", "가격 순"];
  int loadingCount = 0;
  double _dragDistance = 0;
  bool isMoreRequesting = false;
  // late ScrollController _controller;
  bool _isFirstLoadRunning = false;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    refreshNum = 0;
    loadingCount = 0;
    if(list!.length < 10){
      itemCount = list!.length;
    }
    else{
      itemCount = 10;
    }
    debugPrint("현재 표시되는 Max item count는 $itemCount 입니다.");
    setState(() {
      selectedOption = options[0];
    });
    debugPrint("Home Initiate");
  }

  @override
  void dispose(){
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black12,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      hintText: '제목 검색',
                    ),
                    onChanged: (text) {
                      setState((){searchName = text;});
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Expanded(
          child: Container(
              color: Colors.white,
              height: 150.0,
              child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    scrollNotification(notification);
                    return false;
                  },
          child: RefreshIndicator(
              onRefresh: () async {
                 refreshNum += 1;
                 setState(() {});
                 },
          child: ListView.builder(
            itemBuilder: (context, position) {

              //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
              list![list!.length-position-1].uploadDate = formatDate(list![list!.length-position-1].uploadDateForCompare??DateTime.now());
              //uploadDate를 현재 시간 기준으로 계속 업데이트하기

              if(list![list!.length-position-1]!.sellingTitle!.contains(searchName)??true){
                //만약 TextField 내용(searchName)이 제목 포함하고 있으면 보여주기

                debugPrint(list!.length.toString());
                debugPrint(position.toString());
                debugPrint(list![list!.length-position-1]!.isQuickSell.toString());
                if(list![list!.length-position-1]!.isQuickSell == false){
                  //급처분 아이템은 보여주지 않기
                  return GestureDetector(
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        elevation: 1,
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: list![list!.length-position-1].imageListB.isEmpty?
                                    Image.asset("assets/images/main_logo.jpg", width: 100, height: 100, fit: BoxFit.cover)
                                        : Image.network(list![list!.length-position-1].imageListB[0], width: 100, height: 100, fit: BoxFit.cover),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(list![list!.length-position-1].sellingTitle!,
                                                  style: const TextStyle(fontSize: 20),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  "등록 일자: ${list![list!.length-position-1].uploadDate ?? ""}",
                                                  style: const TextStyle(fontSize: 10),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text("가격: ${f.format(
                                                  list![list!.length-position-1].sellingPrice!)}원",
                                                  style: const TextStyle(fontSize: 10),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //isQucikSell이 true라면 표시
                            list![list!.length-position-1].isQuickSell == true?
                            Positioned(
                              right: 10,
                              bottom : 10,
                              child: Container(
                                width: 60,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: postechRed,
                                  borderRadius : const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("급처분",
                                    style: TextStyle(color: Colors.white, fontSize : 10, fontWeight: FontWeight.bold),
                                  ),
                                ),

                              ),
                            ) : const SizedBox(width:0, height:0),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => SubHomePage(goods: list![list!.length-position-1])));
                      }
                  );
                }
                else{
                  return const SizedBox(height: 0, width: 0);
                }
              }
              else{
                return const SizedBox(height: 0, width: 0);
              }
            },
              itemCount: itemCount, //아이템 개수만큼 스크롤 가능
                    ),
                ),
              )
            ),
          ),
            isMoreRequesting? Container(
              height: 20.0,
              width: 20.0,
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ) : const SizedBox(width: 0, height: 0),
         ],
        ),
      ),
    );
  }

  scrollNotification(notification) {
    // 스크롤 최대 범위
    var containerExtent = notification.metrics.viewportDimension;

    if (notification is ScrollStartNotification) {
      // 스크롤을 시작하면 발생(손가락으로 리스트를 누르고 움직이려고 할때)
      // 스크롤 거리값을 0으로 초기화함
      _dragDistance = 0;
    } else if (notification is OverscrollNotification) {
      // 안드로이드에서 동작
      // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.overscroll)
      _dragDistance -= notification.overscroll;
    } else if (notification is ScrollUpdateNotification) {
      // ios에서 동작 // 스크롤을 시작후 움직일때 발생(손가락으로 리스트를 누르고 움직이고 있을때 계속 발생)
      // 스크롤 움직인 만큼 빼준다.(notification.scrollDelta)
      _dragDistance -= notification.scrollDelta!;
    } else if (notification is ScrollEndNotification) {
      // 스크롤이 끝났을때 발생(손가락을 리스트에서 움직이다가 뗐을때 발생)
      // 지금까지 움직인 거리를 최대 거리로 나눈다.
      var percent = _dragDistance / (containerExtent);
      // 해당 값이 -0.4(40프로 이상) 아래서 위로 움직였다면
      if (percent <= -0.4) {
        // maxScrollExtent는 리스트 가장 아래 위치 값, pixels는 현재 위치 값
        // 두 같이 같다면(스크롤이 가장 아래에 있다)
        if (notification.metrics.maxScrollExtent ==
            notification.metrics.pixels) {
          setState(() {
            // 서버에서 데이터를 더 가져오는 효과를 주기 위함
            // 하단에 프로그레스 서클 표시용
            isMoreRequesting = true;
          });

          requestMore().then((value) {
            if(mounted){
              setState(() {
                // 다 가져오면 하단 표시 서클 제거
                isMoreRequesting = false;
              });
            }
          });
        }
      }
    }
  }

  Future<void> requestMore() async {
    // 해당부분은 서버에서 가져오는 내용을 가상으로 만든 것이기 때문에 큰 의미는 없다.

    setState(() {
      debugPrint("현재 리스트의 길이는 ${list!.length}입니다");
      if(itemCount + 10 > list!.length){
        itemCount = list!.length;
      }
      else{
        itemCount = itemCount + 10;
      }
      debugPrint("현재 로딩된 (급처분 포함) Max Item Count는 $itemCount 입니다");
    });
    // 가상으로 잠시 지연 줌
    return await Future.delayed(Duration(milliseconds: 1000));
  }


void _insertUser() async {
    AUser user = AUser(email : "1", password: "2", userSchoolNum: "4", userName: "3");
    final Database database = await widget.db;
    await database.insert("user", user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> getUser() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('user');
    
    print(maps);

  }
}


//(현재 Date) - (등록 Data) => 업로드 시간 표시
String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} 분 전';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} 시간 전';
  } else {
    return '${date.year}.${date.month}.${date.day}';
  }
}

