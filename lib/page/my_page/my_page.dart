import 'package:flutter/material.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/my_page/sub_my_page_selling_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_settings_page.dart';
import '../../entity/goods_entity.dart';
import '../../entity/user_entity.dart';

class MyPage extends StatelessWidget{
  final User user;
  final List<Goods> list;
  const MyPage({Key? key, required this.user, required this.list}) : super(key:key);

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
                  child : Image.asset(user!.imagePath!, width: 80, height: 80, fit: BoxFit.contain),
                ),
                Padding(padding: const EdgeInsets.only(top:30, left:20),
                  child: Row(
                      children: [
                        Text(user!.userSchoolNum??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        Text(user!.userName??"", textScaleFactor: 1.2, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                builder: (context) => SubMyPageSettingPage(user: user)));
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
                              builder: (context) => SubMyPageSellingPage(list : list, user: user)));
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
                ],
              ),
            )
        ],
      ),
    );
  }
}


