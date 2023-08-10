import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/item_entity.dart';
import '../util_function.dart';


/////////일단 안쓰는 page - 혹시모르니까 보류//////////////////


var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
Color postechRed = const Color(0xffac145a);

class SubCategoryPage extends StatefulWidget{

  final List<Item>? list;
  final String category;
  const SubCategoryPage({Key? key, required this.list, required this.category}) : super(key: key);

  @override
  _SubCategoryPageState createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {

  List<Item>? list;
  late String category;
  int refreshNum = 0;
  late String searchName;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    category = widget.category;
    searchName = "";
    refreshNum = 0;
    debugPrint("Sub Category Initiate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Icon(
                Icons.search,
                color: Colors.black12,
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: '제목 및 카테고리 검색',
                  ),
                  onChanged: (text) {
                    setState((){searchName = text;});
                  },
                ),
              ),
            ],
          ),
        ),
        body: Center(
          //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
          child: RefreshIndicator(
            onRefresh: () async {
              refreshNum += 1;
              setState(() {});
            },
            child: ListView.builder(itemBuilder: (context, position) {
              //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번

              list![position].uploadDate = formatDate(list![position].uploadDateForCompare??DateTime.now());
              //uploadDate를 현재 시간 기준으로 계속 업데이트하기

              if(list?[position]!.sellingTitle!.contains(searchName)??true){
                //만약 TextField 내용(searchName)이 제목 포함하고 있으면 보여주기
                return GestureDetector(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      elevation: 1,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Padding(padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10, right: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: list![position].imageListB[0] == null?
                                  Image.asset( "assets/images/main_logo.png",width: 100, height: 100, fit: BoxFit.cover) :
                                  Image.network(list![position].imageListB[0], width: 100, height: 100, fit: BoxFit.cover),
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
                                            child: Text(list![position].sellingTitle!,
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
                                                "등록 일자: ${list![position].uploadDate ?? ""}",
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
                                                list![position].sellingPrice!)}원",
                                                style: const TextStyle(fontSize: 10),
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //isQucikSell이 true라면 표시
                          list![position].itemStatus == ItemStatus.FASTSELL?
                          Positioned(
                            right: 10,
                            bottom : 10,
                            child: Container(
                              width: 60,
                              height: 25,
                              decoration: BoxDecoration(
                                color: postechRed,
                                borderRadius : const BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text("급처분",
                                  style: TextStyle(color: Colors.white, fontSize : 10, fontWeight: FontWeight.bold),
                                ),
                              ),

                            ),
                          ) : const SizedBox(width:0, height:0),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SubHomePage(item: list![position], user: fetchUserInfo(list![position]))));
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
        )
    );
  }
}




