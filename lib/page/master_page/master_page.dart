import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/master_page/sub_master_page_goods_list_page.dart';
import 'package:supo_market/page/master_page/sub_master_page_quicksell_goods_list_page.dart';
import 'package:supo_market/page/master_page/sub_master_page_user_list_page.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import '../../entity/goods_entity.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../log_in_page/log_in_page.dart';

Color postechRed = Color(0xffac145a);

class MasterPage extends StatefulWidget {
  final List<Goods> list;
  const MasterPage({super.key, required this.list});

  @override
  State<StatefulWidget> createState() {
    return _MasterPageState();
  }
}

class _MasterPageState extends State<MasterPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Padding(padding: const EdgeInsets.only(top:10, left: 10),
            child: IconButton (onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.black45), iconSize: 30)
        ),
      ),
      body: Column(
        children: [
          //const Text(환경 설정)
          const SizedBox(width: 500, child: Divider(color: Colors.black, thickness: 0.1)),
          Expanded(child:
          ListView(
            children: [
              SizedBox(
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SubMasterPageUserListPage(list: widget.list)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.supervised_user_circle),
                          SizedBox(width:18),
                          Text('유저 목록', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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
                          builder: (context) => SubMasterPageGoodsListPage(list: widget.list)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(width:18),
                          Text('물품 목록 관리', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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
                          builder: (context) => SubMasterPageQuicksellGoodsListPage(list: widget.list)));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.request_page),
                          SizedBox(width:18),
                          Text('급처분 물품 목록', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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
