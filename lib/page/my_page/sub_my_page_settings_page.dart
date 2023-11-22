import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/sub_my_info_page_change_password_page.dart';
import 'package:supo_market/page/my_page/sub_setting_page_alarm_page.dart';
import '../../entity/user_entity.dart';

class SubMyPageSettingPage extends StatelessWidget{
  final AUser user;
  const SubMyPageSettingPage({Key? key, required this.user}) : super(key:key);

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
            //const Text(환경 설정)
            //const SizedBox(width: 500, child: Divider(color: Colors.black, thickness: 0.1)),
            Expanded(child:
              ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left : 20),
                    child: Container(
                    height: 50,
                    width: 350,
                    child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SubSettingPageAlarmPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.volume_up_outlined, size : 30),
                            // Image.asset(
                            //   'assets/images/icons/key.png',
                            //   width: 25,
                            //   height: 25,
                            // ),
                            Text(
                              '  알림 설정',
                              style: TextStyle(fontFamily: 'Arial', fontSize: 17),
                            )
                          ],
                        ))),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}


