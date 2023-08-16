import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/category_page/sub_category_page.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import '../../entity/item_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../../infra/my_info_data.dart';
import '../chatting_page/chatting_page.dart';
import '../my_page/my_page.dart';
import 'package:supo_market/constants.dart';
import 'package:provider/provider.dart';

import '../util_function.dart';

class CategoryPage extends StatefulWidget {
  final List<Item>? list;

  const CategoryPage({Key? key, required this.list}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Item>? list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
    debugPrint("Category Initiate");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            CategoryButton(
                list: list!,
                context: context,
                color: Colors.greenAccent,
                text: '냉장고',
                icon: const Icon(
                  Icons.kitchen_outlined,
                  size: 40,
                )),
            const SizedBox(width: 20),
            CategoryButton(
                list: list!,
                context: context,
                color: Colors.blueGrey,
                text: '의류',
                icon: const Icon(Icons.checkroom_outlined, size: 40)),
            const SizedBox(width: 20),
            CategoryButton(
                list: list!,
                context: context,
                color: Colors.pinkAccent,
                text: '자취방',
                icon: const Icon(Icons.maps_home_work_outlined, size: 40)),
            const SizedBox(width: 20),
            CategoryButton(
                list: list!,
                context: context,
                color: Colors.yellow,
                text: '모니터',
                icon: const Icon(Icons.desktop_windows_outlined, size: 40)),
          ]),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryButton(
                  list: list!,
                  context: context,
                  color: Colors.brown,
                  text: '책',
                  icon: const Icon(Icons.menu_book_outlined, size: 40)),
              const SizedBox(width: 20),
              CategoryButton(
                  list: list!,
                  context: context,
                  color: Colors.blueGrey,
                  text: '기타',
                  icon: const Icon(Icons.more_horiz_outlined, size: 40)),
            ],
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}

class CategoryButton extends StatefulWidget {
  final List<Item> list;
  final BuildContext context;
  final Color color;
  final String text;
  final Icon icon;

  const CategoryButton({
    Key? key,
    required this.list,
    required this.context,
    required this.color,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  Color? color;
  String? categoryName;
  List<Item>? list;
  String? text;
  Icon? icon;
  String? url;

  bool isMoreRequesting = false;
  int page = 1;
  int pageSize = 10;
  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;
  Map<String,String>? data;

  int refreshNum = 0;
  final options1 = [
    SortType.DATEASCEND,
    SortType.DATEDESCEND,
    SortType.PRICEDESCEND,
    SortType.PRICEASCEND
  ];

  final options2 = [
    ItemStatus.TRADING,
    ItemStatus.SUPOFASTSELL,
    ItemStatus.RESERVED,
    ItemStatus.SOLDOUT,
  ];

  SortType selectedOption1 = SortType.DATEASCEND;
  ItemStatus selectedOption2 = ItemStatus.TRADING;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    categoryName = widget.text;
    icon = widget.icon;
    text = widget.text;
    list = widget.list;
    page = 1;
    super.initState();
    print(myUserInfo.userInterestedId.toString());
    isMoreRequesting = false; //요청 중이면 circle progress
    isListened = false; //progress가 돌아가고 있으면 추가로 요청하지 않기 (한번만)
    selectedOption1 = options1[0];
    selectedOption2 = options2[0];
    debugPrint("$text category initiate");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: IconButton(
            color: Colors.grey[200],
            icon: icon!,
            onPressed: () {
              Navigator.push(context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return SubCategoryPage(list: list, type : text); // 화면을 반환하는 부분
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset(0.0, 0.0);
                  const curve = Curves.easeInOut;
                  var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                      position: offsetAnimation, child: child);
                },
              ));
            },
          ),
        ),
        const SizedBox(height: 5),
        Text(text!),
      ],
    );
  }

}
