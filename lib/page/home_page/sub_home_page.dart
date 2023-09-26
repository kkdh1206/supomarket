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
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/retrofit/RestClient.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';

import '../../entity/util_entity.dart';
import '../chatting_page/sub_chat_page.dart';



class SubHomePage extends StatefulWidget {

  final Item item;
  final Future<AUser> user;
  const SubHomePage({Key? key, required this.item, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubHomePageState();
  }
}

class _SubHomePageState extends State<SubHomePage>{
  RestClient? client;
  int activeIndex = 0;
  AUser? itemUser;
  String? roomID;
  Future<String>? tempToken;

  @override
  void initState(){
    debugPrint("Sub Home Page Initialize");
    activeIndex = 0;
    subHomePageBuilder = transferUserInfo();
    super.initState();
    Dio dio = Dio();
    client = RestClient(dio);
  }

  @override
  void dispose(){
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
      resentTime: '2023-09-12T10:27:44.074Z'
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
    widget.item.isLiked = myUserInfo.userInterestedId.toString()?.contains(widget.item.itemID.toString());

    roomID = myUserInfo.userUid!+ itemUser!.userUid! + widget.item.itemID.toString();
    print("room ID는 $roomID");
    return true;
  }

  Future<bool> liked(Item item) async{

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    print('fetchData');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/items/myInterestedItem/${item.itemID}';

    try {
      Response response = await dio.post(url);
      print(response);
      // Map<String, dynamic> JsonData = json.decode(response.data);

    } catch (e) {
      print('Error sending GET request : $e');
    }

    await fetchMyInfo();

    return true;
  }

  Future<bool> unLiked(Item item) async{

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    print('fetchData');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'http://kdh.supomarket.com/items/myInterestedItem/${item.itemID}';

    try {
      Response response = await dio.patch(url);
      print(response);
      // Map<String, dynamic> JsonData = json.decode(response.data);

    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await fetchMyInfo();
    return true;
  }

  @override
  Widget build(BuildContext context) {

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
                    Padding(padding: const EdgeInsets.only(top: 0),
                      child: Stack(
                        alignment: Alignment.bottomCenter, children: <Widget>[
                        widget.item.imageListB.isEmpty ?
                        Image.asset("assets/images/main_logo.jpg", width: 400,
                          height: 400, fit: BoxFit.fitHeight,)
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
                            final url = widget.item.imageListB?[index];
                              return GestureDetector(
                                child: imageSlider(url, index),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SubPicturePage(url : url)));
                                }
                            );
                          },
                        ),


                        widget.item.imageListB.isEmpty ? const SizedBox(
                            width: 0, height: 0)
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
                        left: 10, top: 10,
                        child: IconButton(onPressed: () {
                          Navigator.pop(context);
                        },
                            icon: Icon(Icons.arrow_back, color: Colors.white54),
                            iconSize: 30)
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(widget.item.sellingTitle!,
                              textScaleFactor: 1.8,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900),
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
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text("등록 날짜 : ${widget.item.uploadDate ??
                              "미상"}",
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text("상품 종류 : "
                              "${widget.item.itemType == ItemType.REFRIGERATOR
                              ? "냉장고"
                              :
                          widget.item.itemType == ItemType.MONITOR ? "모니터" :
                          widget.item.itemType == ItemType.BOOK ? "책" :
                          widget.item.itemType == ItemType.ROOM ? "자취방" :
                          widget.item.itemType == ItemType.CLOTHES
                              ? "옷"
                              : "기타"}",
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text("상품 품질 : "
                              "${widget.item.itemQuality == ItemQuality.HIGH
                              ? "상" : widget.item.itemQuality == ItemQuality.MID
                              ? "중" : "하"}",
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text("상품 내용 : ${widget.item.itemDetail ?? ""}",
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start),
                        ),
                      ),
                    ),
                  ],
                ),
                //판매자 카드
                Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  elevation: 1,
                  child: Row(
                    children: [
                      Padding(padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: widget.item.sellerImage == null ? Image.asset(
                              "assets/images/user.png", width: 100,
                              height: 100,
                              fit: BoxFit.cover)
                              : Image.network(
                              widget.item.sellerImage ?? "", width: 100,
                              height: 100,
                              fit: BoxFit.cover),),
                      ),
                      Text("판매자 : ${widget.item.sellerName ?? "미상"}", textScaleFactor: 1.2),
                      const Expanded(child: SizedBox(width: 1)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text("${widget.item.sellingPrice!
                              .toString()}원",
                              textScaleFactor: 1.8,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.start),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }else{
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
              )
            );
          };
        },
        ),
        bottomNavigationBar: FutureBuilder(
          future: subHomePageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
              return BottomAppBar(
                  child: Row(
                    children: [
                      IconButton(icon: widget.item.isLiked == true
                      ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                      onPressed: () {
                        setState(() {
                         widget.item.isLiked = !(widget.item.isLiked!);
                          if (widget.item.isLiked!) {
                            favoritePageBuilder = liked(widget.item);
                          } else {
                            favoritePageBuilder = unLiked(widget.item);
                          }
                        });
                      }),
                      IconButton(icon: Icon(Icons.chat), onPressed: () {},),
                      IconButton(icon: Icon(Icons.more_vert), onPressed: () {},),
                      const SizedBox(width: 120),
                      Expanded(child: Padding(padding: EdgeInsets.only(right: 10),
                        child: MaterialButton(color: postechRed,
                        child: const Text(
                          "채팅하기", textScaleFactor: 0.9, style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),),
                          onPressed: () async {
                              //채팅 목록에 추가됨기
                             await getToken(widget.item.sellerUid!);
                              inputInfo(
                                  myUserInfo.userUid!,
                                  itemUser!.userUid!,
                                  widget.item.itemID.toString(),
                                  widget.item.sellerName!,
                                  );
                              await Navigator.push(context, MaterialPageRoute(builder: (context)=>SubChattingPage(roomID: roomID)));
                          })
                        )
                      ),
                    ],
                  ),
                );
              }else{
                return const SizedBox();
              };
          },
        )
    );
  }

  //이미지 넘기는 슬라이더
  Widget imageSlider(url, index) => Container(
    width: 400,
    height: 400,
    color: Colors.grey,
    child: Image.network(url, fit: BoxFit.cover, width: 400, height: 400),
  );

}