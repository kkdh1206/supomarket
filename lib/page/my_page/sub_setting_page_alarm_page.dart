import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/usecases/my_page_usecases.dart';
import 'package:supo_market/page/my_page/widgets/my_page_widgets.dart';
import 'package:supo_market/page/util_function.dart';
import '../../entity/item_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/my_info_data.dart';

List<String> isClicked = [];

class SubSettingPageAlarmPage extends StatefulWidget {
  const SubSettingPageAlarmPage({Key? key}) : super(key: key);

  @override
  _SubSettingPageAlarmPageState createState() =>
      _SubSettingPageAlarmPageState();
}

class _SubSettingPageAlarmPageState extends State<SubSettingPageAlarmPage> {
  FixedExtentScrollController? thirdController;

  bool isLoading = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    alarmPageBuilder = initAlarm();
  }

  Future<bool> initAlarm() async {
    await _getKeyword(isClicked);
    mySetting.chatAlarmOnOff = await getChatAlarmInDevice();
    mySetting.categoryAlarmOnOff = await getCategoryAlarmInDevice();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: alarmPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Column(children: [
                    SizedBox(height: 30),
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                  Text(
                                    "채팅 알림",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'KBO-M',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: CupertinoSwitch(
                                      // 급처분 여부
                                      value: mySetting.chatAlarmOnOff!,
                                      activeColor: mainColor,
                                      onChanged: (bool? value) async{
                                        // 스위치가 토글될 때 실행될 코드
                                        setState(() {
                                          mySetting.chatAlarmOnOff = value ?? false;
                                          isLoading = true;
                                        });

                                        await patchChatAlarmOnOff(mySetting.chatAlarmOnOff!);
                                        await setChatAlarmInDevice(mySetting.chatAlarmOnOff!);

                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.075,),
                                  Text(
                                    "카테고리 알림",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'KBO-M',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                  CupertinoSwitch(
                                    // 급처분 여부
                                    value: mySetting.categoryAlarmOnOff!,
                                    activeColor: mainColor,
                                    onChanged: (bool? value) async{
                                      // 스위치가 토글될 때 실행될 코드
                                      setState(() {
                                        mySetting.categoryAlarmOnOff = value ?? false;
                                        isLoading = true;
                                      });

                                      await patchCategoryAlarmOnOff(mySetting.categoryAlarmOnOff!);
                                      await setCategoryAlarmInDevice(mySetting.categoryAlarmOnOff!);

                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          SizedBox(
                            height: 50,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(children: [
                                SizedBox(width: 18),
                                AlarmTitle(),
                              ]),
                            ),
                          ),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    KeywordAlarm(text: "냉장고",
                                        displayText: "전자기기",
                                        isClicked: isClicked.contains("냉장고"),
                                        delay: delay,
                                    ),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "의류",
                                        displayText: "가구",
                                        isClicked: isClicked.contains("의류"),
                                      delay: delay),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "자취방",
                                        displayText: "자취방",
                                        isClicked: isClicked.contains("자취방"),
                                      delay: delay,),
                                  ]),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    KeywordAlarm(text: "책",
                                        displayText: "책",
                                        isClicked: isClicked.contains("책"),
                                      delay: delay,),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "모니터",
                                        displayText: "이동수단",
                                        isClicked: isClicked.contains("모니터"),
                                      delay: delay,),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "구인",
                                        displayText: "구인",
                                        isClicked: isClicked.contains("구인"),
                                      delay: delay,),
                                  ]),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  KeywordAlarm(text: "기타", displayText: "기타", isClicked: isClicked.contains("기타"), delay: delay,),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.only(top: 35, left: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          iconSize: 30)),
                  isLoading ? Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ) : const SizedBox(width: 0, height: 0),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void delay() async{
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1), (){
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> patchCategoryAlarm() async {
    print("카테모리 알람 변경");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      _isLoading = true;
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/auth/patch/userinformation/username';

    var data = {'selectedCategory': mySetting.selectedCategoryAlarm};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      _isLoading = false;
    });
  }


  Future<void> _postKeyword(String text) async {
    await myPageUsecase.postKeyword(text);
    return;
  }

  Future<void> _patchKeyword(String text) async {
    await myPageUsecase.patchKeyword(text);
    return;
  }

  Future<bool> _getKeyword(List<String> list) async {
    await myPageUsecase.getKeyword(list);
    return true;
  }

  Future<bool> patchChatAlarmOnOff(bool onOff) async{
    print("알람 On/Off 변경");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      _isLoading = true;
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/setChatAlarm';

    var data = {'bool': onOff};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      _isLoading = false;
    });
    return true;
  }

  Future<bool> patchCategoryAlarmOnOff(bool onOff) async { // cupertino 스위치중 카테고리 알람임
    print("알람 On/Off 변경");

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    setState(() {
      _isLoading = true;
    });

    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/setCategoryAlarm';

    var data = {'bool': onOff};

    try {
      Response response = await dio.patch(url, data: data);
    } catch (e) {
      print('Error sending PATCH request : $e');
    }

    await getMyInfo();

    setState(() {
      _isLoading = false;
    });
    return true;
  }

}
