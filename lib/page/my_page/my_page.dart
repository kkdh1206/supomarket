import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_qna_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_my_info_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_selling_page.dart';
import 'package:supo_market/page/my_page/sub_my_page_settings_page.dart';
import 'package:supo_market/page/my_page/usecases/my_page_usecases.dart';
import 'package:supo_market/page/my_page/widgets/my_page_widgets.dart';
import '../../entity/item_entity.dart';
import '../../entity/user_entity.dart';
import '../../infra/users_info_data.dart';
import '../welcome_page.dart';
import '../master_page/master_page.dart';

class MyPage extends StatefulWidget{
  final List<Item> list;
  const MyPage({Key? key, required this.list}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }

}

class _MyPageState extends State<MyPage> {

  String? name;
  String? url;
  List<Item>? list;

  @override
  void initState() {
    list = widget.list;
    name = myUserInfo.userName;
    url =  myUserInfo.imagePath;
    super.initState();
    debugPrint("학번은 ${myUserInfo.userStudentNumber.toString()}");
    debugPrint("${myUserInfo!.userStatus}");
  }

  @override
  void didUpdateWidget(Widget oldWidget){
    print("didChangeDependencies : ${myUserInfo.imagePath??""}");
    name = myUserInfo.userName??"익명";
    url = myUserInfo.imagePath??"";
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
          const SizedBox(height: 10),
          Flexible(
            child: Row(
              children: [
                const SizedBox(width: 20),
                Flexible(
                  child: Container(
                    width: 80, // 박스의 너비
                    height: 80, // 박스의 높이
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      image: DecorationImage(
                        image: NetworkImage(url??""),
                        // 이미지 경로
                        fit: BoxFit.cover, // 이미지가 박스에 꽉 차도록 설정
                      ),
                    ),
                    //  실제로는 서버에서 받아와야함
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: NameNumber(name: name??"익명"),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: Container(
                    height: 120,
                      child: UserGrade()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SettingButton(),
          LogoutButton(),
          QnAButton(),
          MySoldButton(list!),
          MyBoughtButton(list!),
          MyInfoChangeButton(callback: (){
            setState(() {
            name = myUserInfo.userName!;
            url = myUserInfo.imagePath!;
          });
          }),
          myUserInfo.userStatus == UserStatus.ADMIN? ManagementButton(list!) : const SizedBox(),
        ],
      ),
    );
  }
}


