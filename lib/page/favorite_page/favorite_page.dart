import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/goods_entity.dart';

Color postechRed = Color(0xffac145a);
var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
String searchName = "";

class FavoritePage extends StatefulWidget{

  final List<Goods>? list;
  const FavoritePage({Key? key, required this.list}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();

}

class _FavoritePageState extends State<FavoritePage>{

  List<Goods>? list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView.builder(itemBuilder: (context, position) {
          //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
          if(list![list!.length-position-1]!.isLiked == true){
            //만약 TextField 내용(searchName)이 제목 포함하고 있으면 보여주기
            return GestureDetector(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  elevation: 1,
                  child: Row(
                    children: [
                      Padding(padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: list![list!.length-position-1].imageListB.isEmpty?
                          Image.asset( "assets/images/main_logo.jpg",width: 100, height: 100, fit: BoxFit.cover) :
                          Image.network(list![list!.length-position-1].imageListB[0], width: 100, height: 100, fit: BoxFit.cover),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(list![list!.length-position-1].sellingTitle!,
                                        style: const TextStyle(fontSize: 20),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        "등록 일자: ${list![list!.length-position-1].uploadDate ??
                                            ""}",
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text("가격: ${f.format(
                                        list![list!.length-position-1].sellingPrice!)}원",
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis),
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SubHomePage(goods: list![list!.length-position-1])));
                 }
            );
          }
          else{
            return const SizedBox(height: 0, width: 0);
          }
        },
          itemCount: list!.length, //아이템 개수만큼 스크롤 가능
        ),
      ),
    );
  }
}




