import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supo_market/entity/user_entity.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/home_page/sub_picture_page.dart';
import 'package:supo_market/page/home_page/sub_sub_home_page_comments_page.dart';
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/retrofit/RestClient.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';
import '../../entity/util_entity.dart';
import '../chatting_page/sub_chat_page.dart';

class SubHomePage extends StatefulWidget {
  final Item item;
  final Future<AUser> user;

  const SubHomePage({Key? key, required this.item, required this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubHomePageState();
  }
}

class _SubHomePageState extends State<SubHomePage> {
  RestClient? client;
  int activeIndex = 0;
  AUser? itemUser;
  String? roomID;
  Future<String>? tempToken;

  @override
  void initState() {
    debugPrint("Sub Home Page Initialize");
    activeIndex = 0;
    subHomePageBuilder = transferUserInfo();
    super.initState();
    Dio dio = Dio();
    client = RestClient(dio);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void inputInfo(String buy, String sell, String item, String seller) async {

    String buyToken = await getToken(buy);
    String sellToken = await getToken(sell);

    final roomData = RoomData(
      buyerID: buy,
      sellerID: sell,
      goodsID: item,
      id: roomID,
      roomName: seller,
      buyerToken: buyToken,
      sellerToken: sellToken,
      resentTime: '2023-09-12T10:27:44.074Z',
      resentMessage: 'None_Message_Yet',
      resentCheck: 'false',

    );

    await client!.postRoomDetail(roomData);
  }

  Future<bool> transferUserInfo() async {
    debugPrint("transferInfo");
    itemUser = await widget.user;
    widget.item.sellerSchoolNum = itemUser?.userStudentNumber;
    widget.item.sellerName = itemUser?.userName;
    widget.item.sellerImage = itemUser?.imagePath;
    widget.item.sellerUid = itemUser?.userUid;
    widget.item.isLiked = myUserInfo.userInterestedId
        .toString()
        ?.contains(widget.item.itemID.toString());

    roomID = myUserInfo.userUid! +
        itemUser!.userUid! +
        widget.item.itemID.toString();
    print("room ID는 $roomID");
    return true;
  }

  Future<bool> liked(Item item) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    print('getData');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/items/myInterestedItem/${item.itemID}';

    try {
      Response response = await dio.post(url);
      print(response);
      // Map<String, dynamic> JsonData = json.decode(response.data);
    } catch (e) {
      print('Error sending GET request : $e');
    }

    await getMyInfo();

    return true;
  }

  Future<bool> unLiked(Item item) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    print('getData');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/items/myInterestedItem/${item.itemID}';

    try {
      Response response = await dio.patch(url);
      print(response);
      // Map<String, dynamic> JsonData = json.decode(response.data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();
    return true;
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: subHomePageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            widget.item.imageListB.isEmpty
                                ? Image.asset(
                                    "assets/images/main_logo.jpg",
                                    width: 400,
                                    height: 400,
                                    fit: BoxFit.fitHeight,
                                  )
                                : CarouselSlider.builder(
                                    options: CarouselOptions(
                                      height: 400,
                                      initialPage: 0,
                                      viewportFraction: 1,
                                      enlargeCenterPage: true,
                                      onPageChanged: (index, reason) =>
                                          setState(() {
                                        activeIndex = index;
                                      }),
                                    ),
                                    itemCount: widget.item.imageListB?.length,
                                    itemBuilder: (context, index, realIndex) {
                                      final url =
                                          widget.item.imageListB?[index];
                                      return GestureDetector(
                                          child: imageSlider(url, index),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubPicturePage(
                                                            url: url)));
                                          });
                                    },
                                  ),
                            widget.item.imageListB.isEmpty
                                ? const SizedBox(width: 0, height: 0)
                                : Positioned(
                                    bottom: 20,
                                    child: CarouselIndicator(
                                      animationDuration: 100,
                                      count: widget.item.imageListB?.length,
                                      index: activeIndex,
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  Icon(Icons.arrow_back, color: Colors.black54),
                              iconSize: 30)),
                    ],
                  ),
                  //판매자 카드
                  Card(
                    color: Colors.grey[200],
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child:
                                widget.item.sellerImage == null ? Image.asset(
                                "assets/images/user.png",
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover)
                                : Image.network(
                                widget.item.sellerImage!, width: 100,
                                height: 100,
                                fit: BoxFit.cover),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(1.0),
                                      color: Color(0xffB70001),
                                      height: 25,
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "판매자",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'KBO-M'
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  margin: const EdgeInsets.only(left : 10),
                                  child: Text(
                                    widget.item.sellerName ?? "미상",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow : TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                           // const Text(
                           //    "추가 상세 정보",
                           //    style: TextStyle(
                           //      fontFamily: 'KBO-L',
                           //      fontSize: 18,
                           //    ),
                           //  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 0),
                                child: Text(widget.item.sellingTitle!,
                                    textScaleFactor: 2.1,
                                    style: const TextStyle(
                                      fontFamily: 'KBO-B',
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text("${f.format(widget.item.sellingPrice!)}원",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Color(0xffB70001),
                                    ),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Text(widget.item.uploadDate! ?? "미상",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, left: 10),
                            child: Text(
                              "상품종류",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'KBO-M',
                                color: Color(0xffB70001),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 20),
                                child: Text(
                                    widget.item.itemType == ItemType.ETC
                                        ? "기타"
                                        : widget.item.itemType ==
                                                ItemType.REFRIGERATOR
                                            ? "전자기기"
                                            : widget.item.itemType ==
                                                    ItemType.ROOM
                                                ? "자취방"
                                                : widget.item.itemType ==
                                                        ItemType.MONITOR
                                                    ? "가구"
                                                    : widget.item.itemType ==
                                                            ItemType.CLOTHES
                                                        ? "이동수단"
                                                        : "책",
                                    style: const TextStyle(
                                        fontFamily: 'KBO-L',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "상품품질",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'KBO-M',
                                color: Color(0xffB70001),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                    widget.item.itemQuality == ItemQuality.HIGH
                                        ? "상"
                                        : widget.item.itemQuality ==
                                                ItemQuality.MID
                                            ? "중"
                                            : "하",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'KBO-L',
                                        fontSize: 17),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "상품내용",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'KBO-M',
                                color: Color(0xffB70001),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(widget.item.itemDetail ?? "",
                                    style: const TextStyle(
                                        fontFamily: 'KBO-L',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.start),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
            ;
          },
        ),
        bottomNavigationBar: FutureBuilder(
          future: subHomePageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return BottomAppBar(
                height: 55,
                color: Colors.grey[350],
                child: Row(
                  children: [
                    GestureDetector(
                    onTap: () {
                              setState(() {
                                widget.item.isLiked = !(widget.item.isLiked!);
                                if (widget.item.isLiked!) {
                                  favoritePageBuilder = liked(widget.item);
                                } else {
                                  favoritePageBuilder = unLiked(widget.item);
                                }
                              });
                            },
                      child: Container(
                        padding: EdgeInsets.only(left: 0),
                        height: 42,
                        width: 42,
                        child: widget.item.isLiked == true? Image.asset("assets/images/icons/heart.png", color : mainColor)
                        : Image.asset("assets/images/heart_border.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SubSubHomePageCommentsPage(itemID: widget.item.itemID!)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 42,
                        width: 42,
                        child: Image.asset("assets/images/icons/comment.png"),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.only(left: 15),
                    //     height: 42,
                    //     width: 42,
                    //     child: Image.asset("assets/images/icons/check.png"),
                    //   ),
                    // ),
                    const SizedBox(width: 150),
                    Expanded(child: Padding(padding: EdgeInsets.only(right: 10),
                        child: MaterialButton(color: Color(0xffB70001),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                            child: const Text(
                              "채팅하기", style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'KBO-B',
                                color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if(widget.item.sellerUid == null){
                                print("존재하지 않는 사용자입니다");
                              }
                              else if(widget.item.sellerUid == myUserInfo.userUid) {
                                print("자기 자신과 채팅할 수 없습니다");
                              }
                              else {
                                await getToken(widget.item.sellerUid!);
                                inputInfo(
                                  myUserInfo.userUid!,
                                  itemUser!.userUid!,
                                  widget.item.itemID.toString(),
                                  widget.item.sellerName!,
                                );
                                print("여기" + roomID! + widget.item.sellerName!);
                                await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    SubChattingPage(roomID: roomID,
                                        traderName: widget.item.sellerName,
                                    buyerID : myUserInfo.userUid!, sellerID : itemUser!.userUid!)));
                              }
                            })
                    )
                    ),
                  ],
                ),
              );

            } else {
              return const SizedBox();
            }
            ;
          },
        ));
  }
  //이미지 넘기는 슬라이더
  Widget imageSlider(url, index) => Container(
        width: 400,
        height: 400,
        color: Colors.grey,
        child: Image.network(url, fit: BoxFit.cover, width: 400, height: 400),
      );
}
