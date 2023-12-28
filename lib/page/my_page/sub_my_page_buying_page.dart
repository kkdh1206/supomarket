import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import 'package:supo_market/page/log_in_page/usecases/popup_usecase.dart';
import 'package:supo_market/page/my_page/sub_selling_page_modify_page.dart';
import 'package:supo_market/page/my_page/widgets/my_page_widgets.dart';
import '../../entity/item_entity.dart';
import 'package:intl/intl.dart';
import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../home_page/widgets/home_page_widgets.dart';
import '../util_function.dart';

class SubMyPageBuyingPage extends StatefulWidget {
  final List<Item>? list;
  final AUser? user;

  const SubMyPageBuyingPage({Key? key, required this.list, this.user})
      : super(key: key);

  @override
  _SubMyPageBuyingPageState createState() => _SubMyPageBuyingPageState();
}

class _SubMyPageBuyingPageState extends State<SubMyPageBuyingPage> {
  List<Item>? list;
  int refreshNum = 0;
  bool isMoreRequesting = false;

  int page = 1;
  int pageSize = 10;

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;

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

  @override
  void initState() {
    debugPrint("My Selling Page Initiate");
    super.initState();
    initialUpdateList();
    isEnded = false; //리스트 끝에 도달함
    page = 1; //늘어난 page 리스트 수
    list = widget.list;
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
    print("scroll Listener");
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
      ),
      body: FutureBuilder(
          future: buyingPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {

              if(list!.isEmpty){
                return const Center(
                  child: Text("구입한 물품이 없습니다"),
                );
              }
              return Center(
                //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          refreshNum += 1;
                          setState(() {});
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            controller: scrollController,
                            itemBuilder: (context, position) {

                              //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                              list![position].uploadDate = formatDate(
                                  list![position].uploadDateForCompare ??
                                      DateTime.now());

                              list![position].buyingDate = formatDate(
                                  list![position].buyingDateForCompare ??
                                      DateTime.now());

                              //uploadDate를 현재 시간 기준으로 계속 업데이트하기
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    debugPrint(list![position].sellerSchoolNum);
                                    debugPrint(list![position].sellerName);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SubHomePage(
                                                  item: list![position],
                                                  user: getUserInfo(
                                                      list![position]),
                                                )));
                                  },
                                  child: MyItemCard2(
                                    image: list![position].imageListB.isEmpty
                                        ? Image.asset(
                                        "assets/images/main_logo.jpg",
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover)
                                        : Image.network(
                                        list![position].imageListB[0],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                                    title: list![position].sellingTitle!,
                                    date: list![position].uploadDate ?? "",
                                    buyingDate : list![position].buyingDate ?? "",
                                    price: list![position].sellingPrice!,
                                    itemId: list![position].itemID!.toString(),
                                    rebuild: (){
                                      print("rebuild");
                                      setState(() {
                                        buyingPageBuilder = _getMySellingItem(1, SortType.DATEASCEND);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            itemCount: list?.length,
                          ),
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
    if (scrollController.hasClients) {
      scrollOffset = scrollController!.position.pixels;
    }
    await _getMySellingItem(page, SortType.DATEASCEND);
    isListened = false;
  }

  Future<void> moreSpaceFunction() async {
    if (scrollController.hasClients && page != 1) {
      scrollController.jumpTo(scrollOffset + 50);
      debugPrint("jump to $scrollOffset+50");
    }
    return;
  }

  void initialUpdateList() {
    setState(() {
      buyingPageBuilder = _getMySellingItem(1, SortType.DATEASCEND);
    });
  }

  Future<bool> _getMySellingItem(int page, SortType type) async {
    ItemType? tempItemType;
    ItemStatus? tempItemStatus;
    ItemQuality? tempItemQuality;
    int pageSize = 10;

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/items/myHistory?sort=${ConvertEnumToString(
        type)}&page=${page}&pageSize=${pageSize}';

    if (page == 1) {
      itemList.clear();
    }

    try {
      Response response = await dio.get(url);
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
          String createdAt = data['createdAt'] as String;

          List<String> imageUrl = List<String>.from(data['ImageUrls']);

          // 사진도 받아야하는데
          DateTime dateTime = DateTime.parse(createdAt);
          DateTime dateTime2 = DateTime.parse(updatedAt);
          
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
              buyingDate: "10일 전",
              buyingDateForCompare : dateTime2,
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


  Future<bool> delete(Item item) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    setState(() {
      isMoreRequesting = true;
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/items/myItems/patch/status/${item.itemID}';

    var data = {'status': "DELETED"};

    print(data);
    try {
      Response response = await dio.patch(url, data: data);
      print(response);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    setState(() {
      isMoreRequesting = false;
    });

    return true;
  }

}