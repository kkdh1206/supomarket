import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../entity/user_entity.dart';
import '../../infra/my_info_data.dart';

class SubSettingPageAlarmPage extends StatefulWidget{
  const SubSettingPageAlarmPage({Key? key}) : super(key: key);

  @override
  _SubSettingPageAlarmPageState createState() => _SubSettingPageAlarmPageState();
}

class _SubSettingPageAlarmPageState extends State<SubSettingPageAlarmPage>{

  FixedExtentScrollController? thirdController;

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
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(width:18),
                          Text("채팅 알림", style: TextStyle(fontSize: 15),),
                          SizedBox(width:18),
                          CupertinoSwitch(
                            // 급처분 여부
                            value: mySetting.chattingAlarm!,
                            activeColor: CupertinoColors.activeOrange,
                            onChanged: (bool? value) {
                              // 스위치가 토글될 때 실행될 코드
                              setState(() {
                                mySetting.chattingAlarm = value ?? false;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
              ),
              SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width:18),
                      Text("키워드 알림", style: TextStyle(fontSize: 15),),
                      SizedBox(width:18),
                      CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        color: CupertinoColors.activeOrange,
                        onPressed: (){
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 400,
                                  width: 400,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 50,
                                          backgroundColor: Colors.white,
                                          scrollController: thirdController,
                                          onSelectedItemChanged: (index){
                                            setState(() {
                                              switch(index){
                                                case(0) : mySetting.selectedCategoryAlarm = "냉장고";
                                                case(1) : mySetting.selectedCategoryAlarm = "의류";
                                                case(2) : mySetting.selectedCategoryAlarm = "자취방";
                                                case(3) : mySetting.selectedCategoryAlarm = "모니터";
                                                case(4) : mySetting.selectedCategoryAlarm = "책";
                                                case(5) : mySetting.selectedCategoryAlarm = "기타";
                                                case(6) : mySetting.selectedCategoryAlarm = "없음";
                                              }
                                            });
                                          },
                                          children: List<Widget>.generate(7, (index){
                                            return Center(
                                              child: TextButton(
                                                  onPressed: (){Navigator.pop(context);},
                                                  child: Text(index==0?"냉장고":index==1?"의류":index==2?"자취방":
                                                  index==3?"모니터":index==4?"책":index==5?"기타":"없음", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),)),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        }, child: Text("알림 키워드: ${mySetting.selectedCategoryAlarm??"없음"}"),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          )
        ],
      ),
    );
  }
}


