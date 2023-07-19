import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/goods_entity.dart';
import 'package:intl/intl.dart';


Color postechRed = const Color(0xffac145a);
var f = NumberFormat('###,###,###,###'); //숫자 가격 콤마 표시
String searchName = "";

class HomePage extends StatefulWidget {
  final List<Goods>? list;
  const HomePage({Key? key, required this.list}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  List<Goods>? list;
  int refreshNum = 0;
  String selectedOption = "최신 순";
  final options = ["최신 순", "가격 순"];

  @override
  void initState() {
    super.initState();
    list = widget.list;
    refreshNum = 0;
    setState(() {
      selectedOption = options[0];
    });
    debugPrint("Home Initiate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Column(
          children: [
            Row(
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
                      hintText: '제목 검색',
                    ),
                    onChanged: (text) {
                      setState((){searchName = text;});
                    },
                  ),
                ),
              ],
            ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     DropdownButton(
          //       value: selectedOption,
          //       items: options.map((e) => DropdownMenuItem(
          //         value: e, // 선택 시 onChanged 를 통해 반환할 value
          //         child: Text(e,
          //           style: const TextStyle(fontSize: 10),
          //         ),
          //       )).toList(),
          //       onChanged: (value) { // items 의 DropdownMenuItem 의 value 반환
          //         setState(() {
          //           selectedOption = value!;
          //         });
          //       },
          //     ),
          //   ],
          // ),
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
                                  child: list![position].imageList.isEmpty?
                                  Image.asset("assets/images/main_logo.jpg", width: 100, height: 100, fit: BoxFit.fitHeight,)
                                 : Image.file(File(list![position].imageList[0].path), width: 100, height: 100, fit: BoxFit.fitHeight,),
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
                          list![position].isQuickSell == true?
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
                          builder: (context) => SubHomePage(goods: list![position])));
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

