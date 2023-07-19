import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/sub_setting_page_alarm_page.dart';
import '../../entity/user_entity.dart';

class SubMyPageSettingPage extends StatelessWidget{
  final User user;
  const SubMyPageSettingPage({Key? key, required this.user}) : super(key:key);

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
                                builder: (context) => SubSettingPageAlarmPage()));
                          },
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(Icons.volume_up),
                                SizedBox(width:18),
                                Text('알림 설정', style: TextStyle(fontSize: 15), textAlign: TextAlign.left),
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


