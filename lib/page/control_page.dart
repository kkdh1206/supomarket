import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/category_page/category_page.dart';
import 'package:supo_market/page/sub_add_goods_page.dart';
import '../entity/chat_room_entity.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import 'chatting_page/chatting_page.dart';
import 'favorite_page/favorite_page.dart';
import 'home_page/home_page.dart';
import 'my_page/my_page.dart';


Item emptyItem = Item(sellingTitle: "", itemType: ItemType.BOOK, itemQuality: ItemQuality.MID, sellerName: "미상", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false, uploadDateForCompare: DateTime(2000, 12, 31), sellerSchoolNum: "20000000", imageListA : [], imageListB: [],  itemStatus: ItemStatus.TRADING);

class ControlPage extends StatefulWidget{

  const ControlPage({super.key});

  @override
  _ControlPageState createState() => _ControlPageState();
}


class _ControlPageState extends State<ControlPage> with SingleTickerProviderStateMixin{
  //singleTickerProviderState를 상속에 추가하지 않으면 해당 클래스에서 애니메이션을 처리할 수 없다.
  TabController? controller;
  List<ChatRoom> chatRoomList = List.empty(growable: true);
  late AUser otherUser;
  Color postechRed = Color(0xffac145a);


  @override
  void initState() {
    super.initState();
    debugPrint("control_initiate");
    controller = TabController(length: 5, vsync: this);
    otherUser = AUser(userName: "정태형", isUserLogin: true, imagePath: "assets/images/user.png", userSchoolNum: "20210000", userItemNum: 0, id: '1234', password: '12345677', userStatus: UserStatus.NORMAL);
    //itemList.add(Item(sellingTitle: "냉장고 싸게 팝니다", itemType: ItemType.REFRIGERATOR, itemQuality: ItemQuality.MID, sellerName: "정태형", sellingPrice: 10000, uploadDate: "10일 전", uploadDateForCompare: DateTime(2023, 7, 8, 18, 20), sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: [], itemStatus: ItemStatus.FASTSELL));
    //itemList.add(Item(sellingTitle: "컴퓨터구조 교재 가져가세요", itemType: ItemType.BOOK, itemQuality: ItemQuality.MID, sellerName: "김도형", sellingPrice: 20000, uploadDate : "방금 전", uploadDateForCompare: DateTime(2000, 12, 31), sellerImage : "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fseller_sample.png?alt=media&token=15dbc13b-5eb3-41f8-9c2a-d33d447d2e15", isLiked : true, itemDetail: "한 번밖에 안썼어요", sellerSchoolNum: "20211111", imageListA : [], imageListB : [], itemStatus: ItemStatus.TRADING));
    chatRoomList.add(ChatRoom(traderName: "채팅봇", traderImage: "assets/images/bot.png", itemName: "", lastChattingDay: "방금 전", lastChattingSentence: "안녕하세요, 슈포마켓에 오신 것을 환영합니다.", sellingTitle: '환영합니다'));
    setState(() {
      myUserInfo.userItemNum ??= 0; //널이면 0 초기화
    });
  }

  @override addListener(){
    //컨트롤러를 통해 탭의 위치나 애니메이션 상태 등을 알 수 있고 추가할 수 있다.
    if(controller!.indexIsChanging){
      print("previous page : ${controller?.previousIndex}");
      print("current page : ${controller?.index}");
    }
  }

  @override
  void dispose(){
    debugPrint("control_dispose");
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          title: const Text("슈포마켓",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)
          ),
          backgroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: postechRed,
        onPressed: ()
          async {
            itemList.clear();
            itemCount = 0;
            final newData = await Navigator.push(context, MaterialPageRoute(builder: (context) => SubAddItemPage(list: itemList)));
            setState(() {
              if(newData.returnType == "add"){
                newData.item.sellerName = myUserInfo.userName;
                newData.item.sellerSchoolNum = myUserInfo.userSchoolNum;
                itemList.add(newData.item??emptyItem);
                //userItemNum 증가
                myUserInfo.userItemNum = (myUserInfo.userItemNum! + 1)!;

                //추가했을 때는 10개가 넘어가도 괜찮음!
                itemCount = itemCount + 1;
                debugPrint("controlPage : 총 아이템 리스트는 ${itemCount+allQuicksellNum} 개입니다");
                debugPrint("controlPage : 홈페이지에 표시되는 개수는 $itemCount 개입니다");
              }
            });
          },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[HomePage(list: itemList), CategoryPage(list: itemList), ChattingPage(list: chatRoomList), FavoritePage(list: itemList), MyPage(list: itemList)],
      ),
      bottomNavigationBar: TabBar(tabs: const <Tab>[
        Tab(icon: Icon(Icons.home_filled, color: Color(0xffac145a)), child : Text("홈")),
        Tab(icon: Icon(Icons.list, color: Color(0xffac145a)), child : Text("분류")),
        Tab(icon: Icon(Icons.chat_bubble, color: Color(0xffac145a)), child : Text("채팅")),
        Tab(icon: Icon(Icons.favorite, color: Color(0xffac145a)), child : Text("찜")),
        Tab(icon: Icon(Icons.info, color: Color(0xffac145a)), child : Text("내 정보"))],
        controller: controller,
        unselectedLabelColor : Colors.grey, //선택 안된 라벨
        labelColor: Colors.black, //선택된 라벨
      ),
      backgroundColor: Colors.white,
    );
  }
}