import 'package:flutter/material.dart';
import '../entity/chat_room_entity.dart';
import '../entity/goods_entity.dart';
import '../entity/user_entity.dart';
import 'chatting_page.dart';
import 'favorite_page.dart';
import 'home_page.dart';
import 'my_page.dart';

Color postechRed = Color(0xffac145a);

class ControlPage extends StatefulWidget{
  const ControlPage({super.key});

  @override
  _ControlPageState createState() => _ControlPageState();
}


class _ControlPageState extends State<ControlPage> with SingleTickerProviderStateMixin{
  //singleTickerProviderState를 상속에 추가하지 않으면 해당 클래스에서 애니메이션을 처리할 수 없다.
  TabController? controller;
  List<Goods> goodsList = List.empty(growable:true);
  List<ChatRoom> chatRoomList = List.empty(growable: true);
  late User personalUser;
  late User otherUser;

  @override
  void initState() {
    super.initState();
    debugPrint("control_initiate");
    controller = TabController(length: 4, vsync: this);
    personalUser =  User(userName: "이지현", userState: "login", imagePath: "assets/images/user.png", userSchoolNum: "20210207");
    otherUser =  User(userName: "정태형", userState: "login", imagePath: "assets/images/user.png", userSchoolNum: "20210000");
    goodsList.add(Goods(sellingTitle: "냉장고 싸게 팝니다", goodsName: "냉장고", goodsQuality: "상", sellerName: "이지현", imagePath_1: "assets/images/main_logo.jpg", sellingPrice: 10000, uploadDate: "10일전"));
    goodsList.add(Goods(sellingTitle: "컴퓨터구조 교재 가져가세요", goodsName: "책", goodsQuality: "하", sellerName: "김도형", imagePath_1: "assets/images/main_logo.jpg", sellingPrice: 20000));
    chatRoomList.add(ChatRoom(traderName: "채팅봇", traderImage: "assets/images/bot.png", goodsName: "", lastChattingDay: "방금 전", lastChattingSentence: "안녕하세요, 슈포마켓에 오신 것을 환영합니다.", sellingTitle: '환영합니다'));
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
          title: const Text("슈포마켓", style: TextStyle(fontWeight: FontWeight.w300)),backgroundColor: postechRed),
      floatingActionButton: FloatingActionButton(
        backgroundColor: postechRed,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[HomePage(list: goodsList), ChattingPage(list: chatRoomList), FavoritePage(), MyPage(user: personalUser)],
      ),
      bottomNavigationBar: TabBar(tabs: const <Tab>[
        Tab(icon: Icon(Icons.home_filled, color: Color(0xffac145a)), child : Text("홈")),
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



