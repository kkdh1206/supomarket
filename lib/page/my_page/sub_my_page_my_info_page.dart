import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_profile_page.dart';
import '../../infra/my_info_data.dart';
import '../../infra/users_info_data.dart';
import '../log_in_page/log_in_page.dart';



class SubMyPageMyInfoPage extends StatefulWidget {
  const  SubMyPageMyInfoPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubMyPageMyInfoPageState();
  }
}

class _SubMyPageMyInfoPageState extends State< SubMyPageMyInfoPage> {

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
                          builder: (context) => SubMyInfoPageChangePasswordPage()));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.password),
                          SizedBox(width:18),
                          Text('비밀번호 변경', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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
                          builder: (context) => SubMyInfoPageChangeProfilePage()));
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.account_box),
                          SizedBox(width:18),
                          Text('프로필 변경', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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
