import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/sub_setting_page_alarm_page.dart';
import '../../entity/user_entity.dart';

class SubMyPageQnAPage extends StatelessWidget{
  const SubMyPageQnAPage({Key? key}) : super(key:key);

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

        ],
      ),
    );
  }
}


