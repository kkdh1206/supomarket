import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/my_page/sub_my_page_selling_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_settings_page.dart';
import '../../entity/goods_entity.dart';
import '../../entity/user_entity.dart';
import '../welcome_page.dart';
import 'master_page.dart';

class MyPage extends StatefulWidget{
  final List<Goods> list;
  const MyPage({Key? key, required this.list}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }

}

class _MyPageState extends State<MyPage>{

  List<Goods>? list;

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(left:20, top:30),
                child : Image.asset(myUserInfo!.imagePath!, width: 80, height: 80, fit: BoxFit.contain),
              ),
              Padding(padding: const EdgeInsets.only(top:30, left:20),
                child: Row(
                  children: [
                    Text(myUserInfo!.userSchoolNum??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(myUserInfo!.userName??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height:10),
          const SizedBox(width: 500, child: Divider(color: Colors.black, thickness: 0.1)),
          Expanded(child:
          ListView(
            children: [
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SubMyPageSettingPage(user: myUserInfo!)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width:18),
                          Text('환경 설정', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {  },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width:18),
                          Text('내 정보 변경', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SubMyPageSellingPage(list : list, user: myUserInfo!)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.inventory),
                          SizedBox(width:18),
                          Text('내가 판 상품', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {  },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          SizedBox(width:18),
                          Text('고객 센터', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              ),
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      _LogOutPopUp();
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width:18),
                          Text('로그아웃', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              ),


              //관리자만 보이는 메뉴
              myUserInfo!.isMaster == true?
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MasterPage(list : list)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.manage_accounts_rounded, color: Colors.redAccent),
                          SizedBox(width:18),
                          Text('관리자 페이지', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
                        ],
                      ),
                    ),
                  )
              )
              : const SizedBox(width:0, height: 0),
            ],
          ),
          )
        ],
      ),
    );
  }

//로그아웃 팝업
  void _LogOutPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          //화면 잘리는 것 방지
          content: const SingleChildScrollView(child:Text("로그아웃 하시겠습니까?")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("예"),
                  onPressed: () async {
                    //로그아웃
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    myUserInfo.isUserLogin = false;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) => WelcomePage()), (route) => false);
                  },
                ),
                TextButton(
                  child: const Text("아니오"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}




