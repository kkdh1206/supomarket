import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
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

Color postechRed = Color(0xffac145a);
Goods emptyGoods = Goods(sellingTitle: "", goodsType: "", goodsQuality: "", sellerName: "", imagePath_1: "", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false,isQuickSell: false,  uploadDateForCompare: DateTime(2000, 12, 31), sellerSchoolNum: "20000000", imageList : []);

class ControlPage extends StatefulWidget{

  final Future<Database> db;
  const ControlPage({super.key, required this.db});

  @override
  _ControlPageState createState() => _ControlPageState();
}


class _ControlPageState extends State<ControlPage> with SingleTickerProviderStateMixin{
  //singleTickerProviderState를 상속에 추가하지 않으면 해당 클래스에서 애니메이션을 처리할 수 없다.
  TabController? controller;
  List<Goods> goodsList = List.empty(growable:true);
  List<ChatRoom> chatRoomList = List.empty(growable: true);
  late User otherUser;

  @override
  void initState() {
    super.initState();
    debugPrint("control_initiate");

    controller = TabController(length: 5, vsync: this);
    otherUser =  User(userName: "정태형", isUserLogin: true, imagePath: "assets/images/user.png", userSchoolNum: "20210000", userGoodsNum: 0, id: '1234', password: '12345677', isMaster: false);
    goodsList.add(Goods(sellingTitle: "냉장고 싸게 팝니다", goodsType: "냉장고", goodsQuality: "상", sellerName: "정태형", imagePath_1: "assets/images/refri_sample.png", sellingPrice: 10000, uploadDate: "10일 전", uploadDateForCompare: DateTime(2023, 7, 8, 18, 20), sellerImage: "assets/images/seller_sample.png", isLiked : false, isQuickSell: false, sellerSchoolNum: "20220000", imageList: []));
    goodsList.add(Goods(sellingTitle: "컴퓨터구조 교재 가져가세요", goodsType: "책", goodsQuality: "하", sellerName: "김도형", imagePath_1: "assets/images/main_logo.jpg", sellingPrice: 20000, uploadDate : "방금 전", uploadDateForCompare: DateTime(2000, 12, 31), sellerImage : "assets/images/user.png", isLiked : true, goodsDetail: "한 번밖에 안썼어요", isQuickSell: true, sellerSchoolNum: "20211111", imageList : []));
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
              }
            });
          },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[HomePage(list: goodsList, db: widget.db), CategoryPage(list: goodsList), ChattingPage(list: chatRoomList), FavoritePage(list: goodsList), MyPage(list: goodsList, db: widget.db)],
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
