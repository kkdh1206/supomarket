import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/category_page/category_page.dart';
import 'package:supo_market/page/sub_add_goods_page.dart';
import '../entity/chat_room_entity.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import 'chatting_page/chatting_page.dart';
import 'favorite_page/favorite_page.dart';
import 'home_page/home_page.dart';
import 'home_page/sub_home_page.dart';
import 'my_page/my_page.dart';


List<Item> searchList = [];
int searchCount = 0;
Item emptyItem = Item(sellingTitle: "", itemType: ItemType.BOOK, itemQuality: ItemQuality.MID, sellerName: "미상", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false, uploadDateForCompare: DateTime(2000, 12, 31), sellerSchoolNum: "20000000", imageListA : [], imageListB: [],  itemStatus: ItemStatus.TRADING);

class SearchPage extends StatefulWidget{

  final List<Item> list;
  const SearchPage({super.key, required this.list});

  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage>{

  var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
  Color postechRed = Color(0xffac145a);
  int refreshNum = 0;
  int loadingCount = 0;
  double _dragDistance = 0;
  bool isMoreRequesting = false;
  Future<String>? _futureResult;



  @override
  void initState() {
    super.initState();
    refreshNum = 0;
    loadingCount = 0;
    if (searchList!.length - allQuicksellNum < 10) {
      searchCount = searchList!.length - allQuicksellNum;
    }
    else {
      searchCount = 10;
    }
    debugPrint("search_initiate");
  }

  @override
  void dispose(){
    debugPrint("control_dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          title: Padding(padding: const EdgeInsets.only(left: 0, right: 0),
            child: Row(
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
                          Radius.circular(8),
                        ),
                      ),
                      hintText: '제목 검색',
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white),
      body: FutureBuilder(
          future: _futureResult,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if(searchCount !=0) {
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
                                itemBuilder: (context, position) {
                                  //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                                  searchList![searchList!.length - position - 1]
                                      .uploadDate = formatDate(
                                      searchList![searchList!.length -
                                          position - 1].uploadDateForCompare ??
                                          DateTime.now());
                                  //uploadDate를 현재 시간 기준으로 계속 업데이트하기

                                  if (searchList![searchList!.length -
                                      position - 1].itemStatus !=
                                      ItemStatus.FASTSELL) {
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
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(top: 10,
                                                        bottom: 10,
                                                        left: 10,
                                                        right: 15),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(8.0),
                                                      child: searchList![searchList!
                                                          .length - position -
                                                          1].imageListB.isEmpty
                                                          ?
                                                      Image.asset(
                                                          "assets/images/main_logo.jpg",
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover)
                                                          : Image.network(
                                                          searchList![searchList!
                                                              .length -
                                                              position - 1]
                                                              .imageListB[0],
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover),
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
                                                                child: Text(
                                                                    searchList![searchList!
                                                                        .length -
                                                                        position -
                                                                        1]
                                                                        .sellingTitle!,
                                                                    style: const TextStyle(
                                                                        fontSize: 20),
                                                                    overflow: TextOverflow
                                                                        .ellipsis),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                    "등록 일자: ${searchList![searchList!
                                                                        .length -
                                                                        position -
                                                                        1]
                                                                        .uploadDate ??
                                                                        ""}",
                                                                    style: const TextStyle(
                                                                        fontSize: 10),
                                                                    overflow: TextOverflow
                                                                        .ellipsis),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                    "가격: ${f
                                                                        .format(
                                                                        searchList![searchList!
                                                                            .length -
                                                                            position -
                                                                            1]
                                                                            .sellingPrice!)}원",
                                                                    style: const TextStyle(
                                                                        fontSize: 10),
                                                                    overflow: TextOverflow
                                                                        .ellipsis),
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
                                              searchList![searchList!.length -
                                                  position -
                                                  1]
                                                  .itemStatus ==
                                                  ItemStatus.FASTSELL ?
                                              Positioned(
                                                right: 10,
                                                bottom: 10,
                                                child: Container(
                                                  width: 60,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: postechRed,
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(
                                                            10.0)),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment
                                                        .center,
                                                    child: Text("급처분",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight
                                                              .bold),
                                                    ),
                                                  ),

                                                ),
                                              ) : const SizedBox(
                                                  width: 0, height: 0),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) =>
                                                  SubHomePage(
                                                      item: searchList![searchList!
                                                          .length - position -
                                                          1])));
                                        }
                                    );
                                  }
                                  else {
                                    return const SizedBox(
                                        height: 0, width: 0);
                                  }
                                },
                                itemCount: searchCount, //아이템 개수만큼 스크롤 가능
                              ),
                            ),
                          )
                      ),
                      //),
                      isMoreRequesting ? Container(
                        height: 20.0,
                        width: 20.0,
                        color: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ) : const SizedBox(width: 0, height: 0),
                    ],
                  ),
                );
              }else{
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
            }
            else if(_futureResult == null) {
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
            }
            else{
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
          }
      ),
    );
  }

  void scrollNotification(notification) {
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
      // 해당 값이 -0.2(20프로 이상) 아래서 위로 움직였다면
      if (percent <= -0.2) {
        // maxScrollExtent는 리스트 가장 아래 위치 값, pixels는 현재 위치 값
        // 두 같이 같다면(스크롤이 가장 아래에 있다) => 수정 : 끝이 100 픽셀밖에 차이가 안난다면
        if (notification.metrics.maxScrollExtent -
            notification.metrics.pixels <= 100) {
          debugPrint("More Requesting");

          setState(() {
            // 서버에서 데이터를 더 가져오는 효과를 주기 위함
            // 하단에 프로그레스 서클 표시용
            isMoreRequesting = true;
          });

          requestMore().then((value) {
            if (mounted) {
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


  void enterFunction(String value){
    debugPrint("enter Function");
    setState(() {
      _futureResult = _performAsyncTask(value);
    });
  }

  Future<String> _performAsyncTask(String input) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    print(token);
    Dio dio = Dio();
    print('여긴가??');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/items/search';

    searchList.clear();
    searchCount = 0;

    try {
      Map<String, dynamic>data ={
        'title': input,
        'sort': "DATEASCEND",
      };

      Response response = await dio.get(url,queryParameters: data);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;

      //  print(jsonData);

      for (var data in jsonData) {
        int id = data['id'] as int;
        String title = data['title'] as String;
        String description = data['description'] as String;
        // String status = data['status'] as String; //--> 이 부분은 수정 코드 주면 그때 실행하기
        int price = data['price'] as int;
        // String category = data['category'] as String;
        String updatedAt = data['updatedAt'] as String;
        List<String> imageUrl = List<String>.from(data['ImageUrls']);
        // 사진도 받아야하는데
        DateTime dateTime = DateTime.parse(updatedAt);


        // 시간 어떻게 받아올지 고민하기!!!!!!
        // 그리고 userId 는 현재 null 상태 해결해야함!!!
        searchList.add(Item(sellingTitle: title, itemType: ItemType.REFRIGERATOR, itemQuality: ItemQuality.HIGH, sellerName: "정태형", sellingPrice: price, uploadDate: "10일 전", uploadDateForCompare: dateTime, itemDetail:description,sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: imageUrl, itemStatus: ItemStatus.TRADING));
        searchCount++;
      }

    } catch (e) {
      print('Error sending GET request : $e');
    }

    debugPrint(searchCount.toString());
    return "end";
  }

  Future<void> requestMore() async {
    // 해당부분은 서버에서 가져오는 내용을 가상으로 만든 것이기 때문에 큰 의미는 없다.

    setState(() {
      debugPrint("Request More : 현재 급처분 포함 총 리스트의 길이는 ${searchList!.length}입니다");
      if (searchCount + 10 > (searchList!.length - allQuicksellNum)) {
        searchCount = searchList!.length - allQuicksellNum;
      }
      else {
        searchCount = searchCount + 10;
      }
      debugPrint("Request More : 현재 표시되는 Max Item Count는 $searchCount 입니다");
    });
    // 가상으로 잠시 지연 줌
    return await Future.delayed(Duration(milliseconds: 1000));
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