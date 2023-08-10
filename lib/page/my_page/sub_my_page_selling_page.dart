import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import 'package:supo_market/page/my_page/sub_selling_page_modify_page.dart';
import '../../entity/item_entity.dart';
import 'package:intl/intl.dart';
import '../../entity/user_entity.dart';
import '../util_function.dart';

Color postechRed = const Color(0xffac145a);
var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
String searchName = "";

class SubMyPageSellingPage extends StatefulWidget {
  final List<Item>? list;
  final AUser? user;
  const SubMyPageSellingPage({Key? key, required this.list, required this.user}) : super(key: key);

  @override
  _SubMyPageSellingPageState createState() => _SubMyPageSellingPageState();
}

class _SubMyPageSellingPageState extends State<SubMyPageSellingPage>{

  List<Item>? list;
  late AUser? user;
  int refreshNum = 0;
  String stateText = "판매중";


  @override
  void initState() {
    super.initState();
    list = widget.list;
    user = widget.user;
    refreshNum = 0;
    debugPrint("My Selling Page Initiate");
    debugPrint("내 물품은 ${myUserInfo.userItemNum.toString()}개이다");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: Padding(padding: const EdgeInsets.only(top:10, left: 10),
              child: IconButton (onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.black45), iconSize: 30)
          ),
        ),
        body: Center(
          //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
          child: RefreshIndicator(
            onRefresh: () async {
              refreshNum += 1;
              setState(() {});
            },

            //내 물품이 없음면 Text 출력
            child: myUserInfo.userItemNum == 0 ? const Text("내 물품이 없습니다") :
            ListView.builder(itemBuilder: (context, position) {
              //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번

              list![position].uploadDate = formatDate(list![position].uploadDateForCompare??DateTime.now());
              //uploadDate를 현재 시간 기준으로 계속 업데이트하기
              if(list![position].sellerSchoolNum == (myUserInfo.userStudentNumber)) {
                //만약 TextField 내용(searchName)이 제목 포함하고 있으면 보여주기
                return GestureDetector(
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      elevation: 1,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Row(
                                children: [
                                  Padding(padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10, right: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: list![position].imageListB.isEmpty?
                                      Image.asset( "assets/images/main_logo.jpg",width: 100, height: 100, fit: BoxFit.cover) :
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
                                                child: Text(list![position]
                                                    .sellingTitle!,
                                                    style: const TextStyle(
                                                        fontSize: 20),
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    "등록 일자: ${list![position]
                                                        .uploadDate ?? ""}",
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                    overflow: TextOverflow
                                                        .ellipsis),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text("가격: ${f.format(
                                                    list![position]
                                                        .sellingPrice!)}원",
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                    overflow: TextOverflow
                                                        .ellipsis),
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
                                bottom: 10,
                                child: Container(
                                  width: 60,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: postechRed,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("급처분",
                                      style: TextStyle(color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox(width: 0, height: 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[200],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: MaterialButton(
                                  onPressed: () async {
                                    final newData = await Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) =>
                                            SubSellingPageModifyPage(
                                                item: list![position])));
                                    setState(() {
                                      if (newData.returnType == "modified") {
                                        //userName 여기서 등록
                                        list?[position].itemDetail = newData.itemDetail!;
                                        list?[position].sellingTitle = newData.sellingTitle!;
                                        list?[position].itemQuality = newData.itemQuality!;
                                        list?[position].itemStatus= newData.Status!;
                                        list?[position].itemType = newData.itemType!;
                                        list?[position].imageListB = newData.imagePath!;
                                        list?[position].sellingPrice = newData.sellingPrice;
                                        list?[position].itemType = newData.itemType;
                                        //수정하면 시간도 방금전 업데이트
                                        list?[position].uploadDate = "방금 전";
                                        list?[position].uploadDateForCompare =
                                            DateTime.now();
                                      }
                                    });
                                  },
                                  child: const Text("수정하기",
                                    style: TextStyle(color: Colors.black45,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: postechRed,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      list?.removeAt(position);
                                      myUserInfo.userItemNum = (myUserInfo.userItemNum! - 1)!;
                                      //instance delete는 나중에 생각해보자
                                    });
                                  },
                                  child: const Text("삭제하기",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(width : 10),
                              Container(
                                width: 100,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if(list![position].itemStatus == ItemStatus.TRADING){
                                        list![position].itemStatus = ItemStatus.RESERVED;}
                                      else if(list![position].itemStatus == ItemStatus.RESERVED){
                                        list![position].itemStatus = ItemStatus.SOLDOUT;
                                      }else if(list![position].itemStatus == ItemStatus.SOLDOUT){
                                        list![position].itemStatus = ItemStatus.FASTSELL;
                                      }else{
                                        list![position].itemStatus = ItemStatus.TRADING;
                                      };
                                    });
                                  },
                                  child: Text(list![position].itemStatus == ItemStatus.TRADING? "거래가능"
                                      : list![position].itemStatus == ItemStatus.FASTSELL? "급처분"
                                      : list![position].itemStatus == ItemStatus.SOLDOUT? "판매완료" : "예약중"
                                      , style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              SubHomePage(item: list![position],user: fetchUserInfo(list![position]))));
                    }
                );
              } else{
                return const SizedBox(width: 0, height: 0);
              }
            },
              itemCount: list!.length, //아이템 개수만큼 스크롤 가능
            ),
          ),
        )
    );
  }
}


//(현재 Date) - (등록 Data) => 업로드 시간 표시
String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} 분 전';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} 시간 전';
  } else {
    return '${date.year}.${date.month}.${date.day}';
  }
}

