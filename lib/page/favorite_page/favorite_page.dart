import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/item_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../../infra/my_info_data.dart';
import '../home_page/widgets/home_page_widgets.dart';
import '../util_function.dart';


String searchName = "";

class FavoritePage extends StatefulWidget{

  final List<Item>? list;
  const FavoritePage({Key? key, required this.list}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();

}

class _FavoritePageState extends State<FavoritePage>{

  List<Item>? list;
  Future<bool>? favoritePageBuilder;

  bool isMoreRequesting = false;

  int page = 1;
  int pageSize = 10;

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    debugPrint(list?.length.toString());
    print(myUserInfo.userInterestedId.toString());
    isMoreRequesting = false; //요청 중이면 circle progress
    isListened = false; //progress가 돌아가고 있으면 추가로 요청하지 않기 (한번만)
    scrollController!.addListener(_scrollListener); //스크롤뷰 위치 이용 함수
    onePageUpdateList();
  }

  @override
  void dispose(){
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

  void updateList() async {
    debugPrint("update List 함수 호출");
    await getItemFavorite(page, SortType.DATEASCEND);
    isListened = false;
  }

  void onePageUpdateList() {
    debugPrint("One Page 불러오기");
    setState(() {
      favoritePageBuilder = getItemFavorite(page, SortType.DATEASCEND);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: favoritePageBuilder,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(itemList.isEmpty){
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("찜 목록이 없습니다"),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, position) {
                //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                  return ItemCard(
                    image: list![position].imageListB.isEmpty
                        ? Image.asset("assets/images/main_logo.jpg",
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
                    price: list![position].sellingPrice!,
                    onTap: () {
                      debugPrint(list![position].sellerSchoolNum);
                      debugPrint(list![position].sellerName);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubHomePage(
                                item: list![position],
                                user: getUserInfo(
                                    list![position]),
                              )));
                    },
                  );
                },
                itemCount: list!.length, //아이템 개수만큼 스크롤 가능
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
            )],
          ),
          );
        }
        },
      ),
    );
  }

  Future<bool> getItemFavorite(int page, SortType type) async{

    ItemType? tempItemType;
    ItemStatus? tempItemStatus;
    ItemQuality? tempItemQuality;
    String? tempSellerName;
    String? tempSellerSchoolNum;
    int pageSize = 10;

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    print('getItemFavorite');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/items/myInterestedItem?sort=${ConvertEnumToString(type)}&page=${page}&pageSize=${pageSize}';
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




