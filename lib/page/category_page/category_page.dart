import 'package:flutter/material.dart';
import 'package:supo_market/page/category_page/sub_category_page.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/goods_entity.dart';
import '../chatting_page/chatting_page.dart';
import '../my_page/my_page.dart';

Color postechRed = Color(0xffac145a);

class CategoryPage extends StatefulWidget{

  final List<Goods>? list;
  const CategoryPage({Key? key, required this.list}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{

  List<Goods>? list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    debugPrint("Category Initiate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryButton(list!, context, Colors.greenAccent, "냉장고", const Icon(Icons.kitchen_outlined, size: 40)),
              const SizedBox(width: 20),
              CategoryButton(list!, context, Colors.blueGrey, "의류", const Icon(Icons.checkroom_outlined, size: 40)),
              const SizedBox(width: 20),
              CategoryButton(list!, context, Colors.pinkAccent, "자취방", const Icon(Icons.maps_home_work_outlined, size: 40)),
              const SizedBox(width: 20),
              CategoryButton(list!, context, Colors.yellow, "모니터", const Icon(Icons.desktop_windows_outlined, size: 40)),
              ]
          ),
           const SizedBox(height: 30.0),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               CategoryButton(list!, context, Colors.brown, "책", const Icon(Icons.menu_book_outlined, size: 40)),
               const SizedBox(width: 20),
               CategoryButton(list!, context, Colors.blueGrey, "기타", const Icon(Icons.more_horiz_outlined, size: 40)),
             ],
           ),
          const SizedBox(height: 30.0),
           // Expanded(
           //     child: Card(
           //         shape: const RoundedRectangleBorder(
           //             borderRadius: BorderRadius.all(Radius.circular(100))
           //         ),
           //         margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           //         elevation: 2,
           //         child: Container(height: 400, color:Colors.yellow)
           //     ),
           // )
        ],
      ),
    );
  }
}



Widget CategoryCard(Color color, String text){
  return Card(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30))
    ),
    color : color,
    child: SizedBox(
      width: 150, height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, textAlign: TextAlign.center, textScaleFactor: 2),
        ],
      ),
    ),
  );
}



Widget CategoryButton(List<Goods> list, BuildContext context, Color color, String text, Icon icon){

  Color temp = color;
  String categoryName = text;

  return Column(
    children: [
      Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
          color: color,
        ),
        child: IconButton(
          color: Colors.grey[200],
          icon: icon,
          onPressed: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoryPage(list: list, category : text)),);
          //바텀시트 이용해서 카테고리 올림
              showModalBottomSheet(context: context,
                builder: (BuildContext context)
                {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child : ListView.builder(itemBuilder: (context, position) {
                      //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번

                      list![position].uploadDate = formatDate(list![position].uploadDateForCompare??DateTime.now());
                      //uploadDate를 현재 시간 기준으로 계속 업데이트하기

                      if(list?[position]!.goodsType!.contains(categoryName)??true){
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
                                          child: Image.asset(list![position].imagePath_1 ?? "assets/images/main_logo.png", width: 100,
                                              height: 100, fit: BoxFit.fitHeight),
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
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                enableDrag: true, //바텀시트 드래그 가능
                isDismissible: true, //바텀시트 아닌 부분 클릭시 close
                barrierColor: color.withOpacity(0.1), //바텀 시트 아닌 부분 색깔
                constraints: const BoxConstraints( //크기 설정
                  minWidth: 500,
                  maxWidth: 500,
                  minHeight: 100,
                  maxHeight: 650,
                ),
                isScrollControlled: true, // false = 화면의 절반만 차지함, true = 전체 화면 차지 가능
              );
            },
        ),
      ),
      const SizedBox(height: 5),
      Text(text),
    ],
  );
}