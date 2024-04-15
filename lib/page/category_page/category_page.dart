import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/category_page/sub_category_page.dart';
import 'package:supo_market/page/category_page/widgets/category_page_widgets.dart';
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
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Refrigerator(list: widget.list, text: "전자기기"),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Clothes(list: widget.list, text: "가구"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Rooms(list: widget.list, text: "자취방"),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Monitor(list: widget.list, text: "이동수단"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Book(list: widget.list, text: "책"),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Etc(list: widget.list, text: "ETC"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

