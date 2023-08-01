import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supo_market/infra/goods_list_data.dart';
import 'package:supo_market/page/category_page/category_page.dart';
import 'package:supo_market/page/sub_add_goods_page.dart';
import '../entity/chat_room_entity.dart';
import '../entity/goods_entity.dart';
import '../entity/user_entity.dart';
import '../infra/my_info_data.dart';
import 'chatting_page/chatting_page.dart';
import 'favorite_page/favorite_page.dart';
import 'home_page/home_page.dart';
import 'my_page/my_page.dart';


Goods emptyGoods = Goods(sellingTitle: "", goodsType: "", goodsQuality: "", sellerName: "미상", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false,isQuickSell: false, uploadDateForCompare: DateTime(2000, 12, 31), sellerSchoolNum: "20000000", imageListA : [], imageListB: [], sellingState: 0);

class ControlPage extends StatefulWidget{

  const ControlPage({super.key});

  @override
  _ControlPageState createState() => _ControlPageState();
}


class _ControlPageState extends State<ControlPage> with SingleTickerProviderStateMixin{
  //singleTickerProviderState를 상속에 추가하지 않으면 해당 클래스에서 애니메이션을 처리할 수 없다.
  TabController? controller;
  List<ChatRoom> chatRoomList = List.empty(growable: true);
  late User otherUser;
  Color postechRed = Color(0xffac145a);

  @override
  void initState() {
    super.initState();
    debugPrint("control_initiate");
    controller = TabController(length: 5, vsync: this);
    otherUser = User(userName: "정태형", isUserLogin: true, imagePath: "assets/images/user.png", userSchoolNum: "20210000", userGoodsNum: 0, id: '1234', password: '12345677', isMaster: false);
    goodsList.add(Goods(sellingTitle: "냉장고 싸게 팝니다", goodsType: "냉장고", goodsQuality: "상", sellerName: "정태형", sellingPrice: 10000, uploadDate: "10일 전", uploadDateForCompare: DateTime(2023, 7, 8, 18, 20), sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, isQuickSell: false, sellerSchoolNum: "20220000", imageListA: [], imageListB: [], sellingState: 0));
    goodsList.add(Goods(sellingTitle: "컴퓨터구조 교재 가져가세요", goodsType: "책", goodsQuality: "하", sellerName: "김도형", sellingPrice: 20000, uploadDate : "방금 전", uploadDateForCompare: DateTime(2000, 12, 31), sellerImage : "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fseller_sample.png?alt=media&token=15dbc13b-5eb3-41f8-9c2a-d33d447d2e15", isLiked : true, goodsDetail: "한 번밖에 안썼어요", isQuickSell: true, sellerSchoolNum: "20211111", imageListA : [], imageListB : [], sellingState: 0));
    chatRoomList.add(ChatRoom(traderName: "채팅봇", traderImage: "assets/images/bot.png", goodsName: "", lastChattingDay: "방금 전", lastChattingSentence: "안녕하세요, 슈포마켓에 오신 것을 환영합니다.", sellingTitle: '환영합니다'));
    setState(() {
      myUserInfo.userGoodsNum ??= 0; //널이면 0 초기화
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
            final newData = await Navigator.push(context, MaterialPageRoute(builder: (context) => SubAddGoodsPage(list: goodsList)));
            setState(() {
              if(newData.returnType == "add"){
                //userName 여기서 등록
                newData.goods.sellerName = myUserInfo.userName;
                newData.goods.sellerSchoolNum = myUserInfo.userSchoolNum;
                goodsList.add(newData.goods??emptyGoods);
                //userGoodsNum 증가
                myUserInfo.userGoodsNum = (myUserInfo.userGoodsNum! + 1)!;

                //추가했을 때는 10개가 넘어가도 괜찮음!
                itemCount = itemCount + 1;
                debugPrint("이 표시되는 itemCounts는 $itemCount 개입니다");
              }
            });
          },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[HomePage(list: goodsList), CategoryPage(list: goodsList), ChattingPage(list: chatRoomList), FavoritePage(list: goodsList), MyPage(list: goodsList)],
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
