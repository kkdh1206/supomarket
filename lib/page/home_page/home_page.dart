import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/item_entity.dart';
import 'package:intl/intl.dart';
import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../util_function.dart';

class HomePage extends StatefulWidget {
  final List<Item>? list;

  const HomePage({Key? key, required this.list}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item>? list;
  int refreshNum = 0;
  final options1 = [
    SortType.DATEASCEND,
    SortType.DATEDESCEND,
    SortType.PRICEDESCEND,
    SortType.PRICEASCEND
  ];

  final options2 = [
    ItemStatus.TRADING,
    ItemStatus.SUPOFASTSELL,
    ItemStatus.RESERVED,
    ItemStatus.SOLDOUT,
  ];

  SortType selectedOption1 = SortType.DATEASCEND;
  ItemStatus selectedOption2 = ItemStatus.TRADING;
  bool isMoreRequesting = false;

  int page = 1;
  int pageSize = 10;

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;

  @override
  void initState() {
    debugPrint("Home Initiate");
    super.initState();
    onePageUpdateList();
    isEnded = false; //리스트 끝에 도달함
    page = 1; //늘어난 page 리스트 수
    list = widget.list;
    refreshNum = 0; //새로고침 시
    selectedOption1 = options1[0];
    selectedOption2 = options2[0];
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
    if (scrollController!.offset + 500 >= scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange && !isListened && !isEnded) {
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
        title: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: DropdownButton(
                        value: selectedOption1,
                        items: options1
                            .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == SortType.PRICEASCEND
                                  ? "가격 낮은 순"
                                  : e == SortType.PRICEDESCEND
                                  ? "가격 높은 순"
                                  : e == SortType.DATEASCEND
                                  ? "최신 순"
                                  : "오래된 순",
                              textScaleFactor: 0.8,
                            )))
                            .toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedOption1 = value!;
                            page = 1;
                            isListened = false;
                            isEnded = false;
                          });
                          updateList();
                        },
                        itemHeight: 50.0,
                        elevation: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: DropdownButton(
                        value: selectedOption2,
                        items: options2
                            .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == ItemStatus.TRADING
                                  ? "거래 중"
                                  : e == ItemStatus.SUPOFASTSELL
                                  ? "급처분 중"
                                  : e == ItemStatus.RESERVED
                                  ? "예약 중"
                                  : "판매 완료",
                              textScaleFactor: 0.8,
                            )))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedOption2 = value!;
                            page = 1;
                            isListened = false;
                            isEnded = false;
                          });
                          updateList();
                        },
                        itemHeight: 50.0,
                        elevation: 0,
                      ),
                    )
                  ],
                ),
              ],
            )),
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
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          refreshNum += 1;
                          onePageUpdateList();
                        },
                        child: ListView.builder(
                          controller: scrollController,
                          itemBuilder: (context, position) {
                            //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                            list![position].uploadDate = formatDate(
                                list![position].uploadDateForCompare ??
                                    DateTime.now());
                            //uploadDate를 현재 시간 기준으로 계속 업데이트하기
                            if (list![position].itemStatus !=
                                ItemStatus.USERFASTSELL) {
                              //급처분 아이템은 보여주지 않기
                              return GestureDetector(
                                  child: Card(
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    elevation: 1,
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 15),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: list![position]
                                                        .imageListB
                                                        .isEmpty
                                                    ? Image.asset(
                                                        "assets/images/main_logo.jpg",
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover)
                                                    : Image.network(
                                                        list![position]
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
                                                              list![position]
                                                                  .sellingTitle!,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              "등록 일자: ${list![position].uploadDate ?? ""}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                              "가격: ${f.format(list![position].sellingPrice!)}원",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          10),
                                                              overflow:
                                                                  TextOverflow
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
                                        list![position].itemStatus ==
                                                ItemStatus.USERFASTSELL
                                            ? Positioned(
                                                right: 10,
                                                bottom: 10,
                                                child: Container(
                                                  width: 60,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    color: postechRed,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                  child: const Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "급처분",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 0, height: 0),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    debugPrint(list![position].sellerSchoolNum);
                                    debugPrint(list![position].sellerName);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SubHomePage(
                                                  item: list![position],
                                                  user: fetchUserInfo(
                                                      list![position]),
                                                )));
                                  });
                            } else {
                              return const SizedBox(height: 0, width: 0);
                            }
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
    await fetchItemMain(page, selectedOption1, selectedOption2);
    isListened = false;
  }

  // Future<void> moreSpaceFunction() async {
  //   if (scrollController.hasClients && page != 1) {
  //     scrollController.jumpTo(scrollOffset + 50);
  //     debugPrint("jump to $scrollOffset+50");
  //   }
  //   return;
  // }

  void onePageUpdateList() {
    setState(() {
      homePageBuilder = fetchItem(1, selectedOption1, selectedOption2);
    });
  }

  //homePage에서의 fetch (나머지는 page 1 로딩을 위한 fetchData in Control/Add)
  Future<bool> fetchItemMain(int page, SortType type, ItemStatus status) async {

    ItemType? tempItemType;
    ItemStatus? tempItemStatus;
    ItemQuality? tempItemQuality;
    String? tempSellerName;
    String? tempSellerSchoolNum;
    int pageSize = 10;

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'http://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&status=${ConvertEnumToString(status)}&page=${page}&pageSize=${pageSize}';

    if (page == 1) {
      itemList.clear();
    }

    try {
      Response response = await dio.get(url);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;

      if (jsonData.toString() != "true") {
        debugPrint("List 개수 update");

        setState(() {
          isMoreRequesting = true;
        });
        await Future.delayed(Duration(milliseconds: 100));

        for (var data in jsonData) {
          int id = data['id'] as int;
          String title = data['title'] as String;
          String description = data['description'] as String;
          int price = data['price'] as int;

          String status = data['status'] as String; //--> 이 부분은 수정 코드 주면 그때 실행하기
          tempItemStatus = convertStringToEnum(status);

          String quality = data['quality'] as String;
          tempItemQuality = convertStringToEnum(quality);

          String category = data['category'] as String;
          tempItemType = convertStringToEnum(category);

          String updatedAt = data['updatedAt'] as String;
          List<String> imageUrl = List<String>.from(data['ImageUrls']);

          // 사진도 받아야하는데
          DateTime dateTime = DateTime.parse(updatedAt);

          // 시간 어떻게 받아올지 고민하기!!!!!!
          // 그리고 userId 는 현재 null 상태 해결해야함!!!
          itemList.add(Item(
              sellingTitle: title,
              itemType: tempItemType,
              itemQuality: tempItemQuality!,
              sellerName: "정태형",
              sellingPrice: price,
              uploadDate: "10일 전",
              uploadDateForCompare: dateTime,
              itemDetail: description,
              sellerImage:
                  "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96",
              isLiked: false,
              sellerSchoolNum: "20220000",
              imageListA: [],
              imageListB: imageUrl,
              itemStatus: tempItemStatus!,
              itemID: id));
        }

        //await moreSpaceFunction();

        setState(() {
          isMoreRequesting = false;
        });
      } else {
        setState(() {
          isEnded = true;
        });
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }
}
