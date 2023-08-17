import 'dart:io';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supo_market/entity/user_entity.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/home_page/sub_picture_page.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/board_entity.dart';
import '../../entity/item_entity.dart';
import 'package:flutter/services.dart';

import '../../entity/util_entity.dart';



class SubQnAPageBoardPage extends StatefulWidget {

  final Board board;
  final Future<AUser> user;
  const SubQnAPageBoardPage({Key? key, required this.board, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubQnAPageBoardPageState();
  }
}

class _SubQnAPageBoardPageState extends State<SubQnAPageBoardPage>{

  int activeIndex = 0;
  Board board = Board(id: 0, title: "", description: "", boardStatus: BoardStatus.PUBLIC, userName: "", userStudentNumber: "");
  @override
  void initState(){
    debugPrint("Sub Home Page Initialize");
    board = widget.board;
    activeIndex = 0;
    boardPageBuilder = transferUserInfo();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  Future<bool> transferUserInfo() async {
    debugPrint("transferInfo");
    AUser itemUser = await widget.user;
    board.userStudentNumber = itemUser.userStudentNumber;
    board.userName = itemUser.userName;

    return true;
  }

  Future<bool> initPageUpdate() async {
    await Future.delayed(Duration(seconds:2));
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(color: Colors.white),
        ),
        body: FutureBuilder(
          future: boardPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: [
                    DataTable(
                      columns: [
                        const DataColumn(label: Text("제목")),
                        DataColumn(label: Text("${board.title}")),
                      ],
                      rows: [
                        DataRow(
                            cells: [
                              const DataCell(Text('작성자')),
                              DataCell(Text('${board.userName}')),
                            ]
                        ),
                        DataRow(
                            cells: [
                              const DataCell(Text('작성 일시')),
                              DataCell(Text('${board.uploadDate}')),
                            ]
                        ),
                      ],
                        showBottomBorder : true,
                    ),
                    Padding(padding: EdgeInsets.all(20.0), child: Text(board.description??""),),
                  ],
              );
            }else{
              return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    ],
                  )
              );
            };
          },
        ),
    );
  }

}