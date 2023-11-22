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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    alarmPageBuilder = initAlarm();
  }

  Future<bool> initAlarm() async {
    mySetting.chattingAlarm = await _getKeyword(isClicked);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        //toolbarHeight: 60,
        leading: Padding(
            padding: const EdgeInsets.only(top: 0, left: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                iconSize: 30)),
      ),
      body: FutureBuilder(
          future: alarmPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Column(children: [
                    Expanded(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 50,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SizedBox(width: 18),
                                  Text(
                                    "앱 알림",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'KBO-M',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 18),
                                  CupertinoSwitch(
                                    // 급처분 여부
                                    value: mySetting.chattingAlarm!,

                                    activeColor: mainColor,
                                    onChanged: (bool? value) {
                                      // 스위치가 토글될 때 실행될 코드
                                      setState(() {
                                        mySetting.chattingAlarm =
                                            value ?? false;
                                      });
                                      setAlarmInDevice(
                                          mySetting.chattingAlarm!);
                                    },
                                  ),
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
                                        isClicked: isClicked.contains("냉장고")),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "의류",
                                        isClicked: isClicked.contains("의류")),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "자취방",
                                        isClicked: isClicked.contains("자취방")),
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
                                        isClicked: isClicked.contains("책")),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "모니터",
                                        isClicked: isClicked.contains("모니터")),
                                    const SizedBox(width: 5),
                                    KeywordAlarm(text: "기타",
                                        isClicked: isClicked.contains("기타")),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ])
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
    );
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
        'http://kdh.supomarket.com/auth/patch/userinformation/username';

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
}
