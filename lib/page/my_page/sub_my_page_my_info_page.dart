import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_profile_page.dart';
import 'package:supo_market/page/my_page/widgets/my_page_widgets.dart';
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
        //toolbarHeight: 60,
        leading: Padding(padding: const EdgeInsets.only(top:0, left: 10),
            child: IconButton (onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios, color: Colors.black), iconSize: 30)
        ),
      ),
      body: Column(
        children: [
          Padding(padding : const EdgeInsets.only(left : 20),
          child: PasswordChange(),),
          Padding(padding : const EdgeInsets.only(left : 20),
            child: ProfileChange(),),
          Padding(padding : const EdgeInsets.only(left : 20),
            child: DeleteButton(),),

          //const Text(환경 설정)
          //const SizedBox(width: 500, child: Divider(color: Colors.black, thickness: 0.1)),
        ],
      ),
    );
  }
}
