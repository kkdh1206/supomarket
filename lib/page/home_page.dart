import 'package:flutter/material.dart';
import 'package:supo_market/page/sub_home_page.dart';
import '../entity/goods_entity.dart';

Color postechRed = Color(0xffac145a);

class HomePage extends StatelessWidget {

  final List<Goods>? list;
  const HomePage({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(itemBuilder: (context, position) {
          //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
          return GestureDetector(
            child: Card(
                child: Row(
                  children: [
                    Padding(padding: const EdgeInsets.only(top:10, bottom:10,left:10, right:10),
                      child: Image.asset(list![position].imagePath_1??"assets/images/main_logo.png", width:80, height: 80, fit: BoxFit.contain),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(list![position].sellingTitle!, style: const TextStyle(fontSize:20),overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("등록 일자: ${list![position].uploadDate?? ""}", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Text("판매자: ${list![position].sellerName!}", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SubHomePage(goods: list![position])));
              }
            );
          },
          itemCount: list!.length, //아이템 개수만큼 스크롤 가능
        ),
      ),
    );
  }
}


