import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/category_page/category_page.dart';
import 'package:supo_market/page/search_page.dart';
import 'package:supo_market/page/sub_add_goods_page.dart';
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/widgets/util_widgets.dart';
import '../entity/chat_room_entity.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import '../provider/socket_provider.dart';
import 'chatting_page/chatting_page.dart';
import 'favorite_page/favorite_page.dart';
import 'home_page/home_page.dart';
import 'log_in_page/widgets/log_in_page_widget.dart';
import 'my_page/my_page.dart';
import 'package:url_launcher/url_launcher.dart';

Item emptyItem = Item(
    sellingTitle: "",
    itemType: ItemType.BOOK,
    itemQuality: ItemQuality.MID,
    sellerName: "미상",
    sellingPrice: 0,
    uploadDate: "",
    sellerImage: "",
    isLiked: false,
    uploadDateForCompare: DateTime(2000, 12, 31),
    sellerSchoolNum: "20000000",
    imageListA: [],
    imageListB: [],
    itemStatus: ItemStatus.TRADING,
    itemID: 2);

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> with SingleTickerProviderStateMixin {
  //singleTickerProviderState를 상속에 추가하지 않으면 해당 클래스에서 애니메이션을 처리할 수 없다.
  TabController? controller;
  List<ChatRoom> chatRoomList = List.empty(growable: true);
  late AUser otherUser;
  AUser requestTrader = AUser(email: '', userName: '', imagePath: '', isUserLogin: null, userStatus: UserStatus.NORMAL);
  //late AnimationController _bellController;
  List<Map<String, String>> requestList = [];


  @override
  void initState() {
    super.initState();

    debugPrint("control_initiate");
    controller = TabController(length: 5, vsync: this);
    controller!.addListener(() {
      setState(() {
        _selectedIndex = controller!.index;
      });
    });;
    otherUser = AUser(
        userName: "정태형",
        isUserLogin: true,
        imagePath: "assets/images/user.png",
        userStudentNumber: "20210000",
        userItemNum: 0,
        email: '1234',
        password: '12345677',
        userStatus: UserStatus.NORMAL);
    //itemList.add(Item(sellingTitle: "냉장고 싸게 팝니다", itemType: ItemType.REFRIGERATOR, itemQuality: ItemQuality.MID, sellerName: "정태형", sellingPrice: 10000, uploadDate: "10일 전", uploadDateForCompare: DateTime(2023, 7, 8, 18, 20), sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: [], itemStatus: ItemStatus.USERFASTSELL));
    //itemList.add(Item(sellingTitle: "컴퓨터구조 교재 가져가세요", itemType: ItemType.BOOK, itemQuality: ItemQuality.MID, sellerName: "김도형", sellingPrice: 20000, uploadDate : "방금 전", uploadDateForCompare: DateTime(2000, 12, 31), sellerImage : "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fseller_sample.png?alt=media&token=15dbc13b-5eb3-41f8-9c2a-d33d447d2e15", isLiked : true, itemDetail: "한 번밖에 안썼어요", sellerSchoolNum: "20211111", imageListA : [], imageListB : [], itemStatus: ItemStatus.TRADING));
    chatRoomList.add(ChatRoom(
        traderName: "채팅봇",
        traderImage: "assets/images/bot.png",
        itemName: "",
        lastChattingDay: "방금 전",
        lastChattingSentence: "안녕하세요, 슈포마켓에 오신 것을 환영합니다.",
        sellingTitle: '환영합니다'));
    setState(() {
      myUserInfo.userItemNum ??= 0; //널이면 0 초기화
    });
    requestList = myUserInfo.requestList??[];
    // _bellController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  addListener() {
    //컨트롤러를 통해 탭의 위치나 애니메이션 상태 등을 알 수 있고 추가할 수 있다.
    print("add Listner");
    if (controller!.indexIsChanging) {
      print("previous page : ${controller?.previousIndex}");
      print("current page : ${controller?.index}");

      setState(() {
        requestList = myUserInfo.requestList??[];
        print("request List Listener $requestList");
      });
    }
  }

  @override
  void dispose() {
    debugPrint("control_dispose");
    controller!.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    controller!.animateTo(index);
  }






  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            centerTitle: false,
            toolbarHeight: 50,
            title: Stack(
              children: [
                SupoTitle2(),
                Positioned(
                  top: 0, right: 0,
                  child: Row(
                    children: [
                      ReallyBoughtPopUp(
                        itemId: requestList.isNotEmpty
                            ? requestList![0]['itemId']!
                            : '-1',
                        traderId: requestList.isNotEmpty
                            ? requestList![0]['userId']!
                            : '-1',
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: IconButton(
                            icon: const Icon(Icons.search, size: 35),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SearchPage(list: itemList)));
                            }),
                      ),
                    ],
                  ),
                ),
                //ReallyBoughtPopUp(itemId: '126', traderId: '9', itemName: '아이템제목', traderName: '거래자이름',),
              ],
            ),
            backgroundColor: Colors.white),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: postechRed,

          onPressed: () async {
            // 여기 팝업창 띄움
            // showDialog 함수로 팝업 창 띄우기
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("유의 사항"),
                  content: Container(
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("슈포마켓은 올바른 중고거래 문화 조성을 위해서 현행 법령을 위반하는 물품의 거래는 제한하고 있습니다.\n"
                              "제한물품 거래시, 법에따른 처벌 및 계정이 제한될 수 있습니다. \n"
                              "자세한 규정은 아래 링크를 참고바랍니다. \n"),
                          GestureDetector(
                            onTap: (){
                              _launchURL('https://www.supomarket.com/rules/trade');
                            },
                            child: Text("물품규정 바로가기",
                              style: TextStyle(color: Colors.cyan, decoration: TextDecoration.underline),),
                          )
                          // Add more items as needed
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text("확인"),
                      onPressed: () {
                        Navigator.of(context).pop(); // 팝업 닫기
                        updateList(); // 리스트 업데이트
                        debugPrint("add return");
                      },
                    ),

                  ],
                );
              },
            );



            final newData = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubAddItemPage(list: itemList)));
            setState(() {
              if (newData.returnType == "add") {
                debugPrint("add return");
                updateList();
              }
            });
          },
          child: Container(
            color : Colors.white,
            child: Image.asset("assets/images/icons/plus_again.png",width: 100, height: 100, fit: BoxFit.cover),
          ),
          //child: const Icon(Icons.add),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[ // 탭바는 순서를 통해 구분이 된다고 한다
            HomePage(list: itemList),
            CategoryPage(list: itemList),
            ChattingPage(list: chatRoomList),
            FavoritePage(list: itemList),
            MyPage(list: itemList)
          ],
        ),
        bottomNavigationBar: SafeArea(

          child: CupertinoTabBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,

        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
        label: '홈',
      ),
    BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.square_list),
    label: '분류',
    ),
    BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.chat_bubble_2),
    label: '채팅',
    ),
    BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.heart),
    label: '찜',
    ),
    BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.person),
    label: '내 정보',
    ),
    ],
              backgroundColor: Colors.white
    ),

            // tabBuilder: (context, index) {
            //   return CupertinoTabView(
            //     builder: (context) {
            //       final List<Widget> _pages = [ // 탭바는 순서를 통해 구분이 된다고 한다
            //         HomePage(list: itemList),
            //         CategoryPage(list: itemList),
            //         ChattingPage(list: chatRoomList),
            //         FavoritePage(list: itemList),
            //         MyPage(list: itemList)
            //       ];
            //
            //       return _pages[index];
            //     },
            //   );
            // },


    ),
      );


  }

  void _launchURL(String url) async {
    await launchUrl(Uri.parse('http://www.supomarket.com/rules/trade'));
  }

  void updateList() {
    debugPrint("update List");
    setState(() {
      homePageBuilder = getItem(1, SortType.DATEASCEND, ItemStatus.TRADING, TradeType.ALL);
    });
  }

  void getNameById(String itemId) async{
    requestTrader = await getUserInfo3(itemId);
    return;
  }


}