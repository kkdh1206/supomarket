import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    mySetting.chattingAlarm = await getKeyword(isClicked);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black45),
                iconSize: 30)),
      ),
      body: FutureBuilder(
          future: alarmPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Column(children: [
                    //const Text(환경 설정)
                    const SizedBox(
                        width: 500,
                        child: Divider(color: Colors.black, thickness: 0.1)),
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
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(width: 18),
                                  CupertinoSwitch(
                                    // 급처분 여부
                                    value: mySetting.chattingAlarm!,

                                    activeColor: CupertinoColors.activeOrange,
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
                          SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 18),
                                Text(
                                  "키워드 알림",
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 18),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CategoryButton(text: '냉장고', isClicked: isClicked.contains('냉장고')),
                                const SizedBox(width: 10),
                                CategoryButton(text: '의류', isClicked: isClicked.contains('의류')),
                                const SizedBox(width: 10),
                                CategoryButton(text: '자취방', isClicked: isClicked.contains('자취방')),
                                const SizedBox(width: 10),
                                CategoryButton(text: '책', isClicked: isClicked.contains('책')),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CategoryButton(text: '모니터', isClicked: isClicked.contains('모니터')),
                                const SizedBox(width: 10),
                                CategoryButton(text: '기타', isClicked: isClicked.contains('기타')),
                              ],
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

    await fetchMyInfo();

    setState(() {
      _isLoading = false;
    });
  }
}


class CategoryButton extends StatefulWidget{
  const CategoryButton({Key? key, required this.text, required this.isClicked}) : super(key: key);

  final String text;
  final bool isClicked;

  @override
  State<StatefulWidget> createState() {
    return _CategoryButtonState();
  }
}

class _CategoryButtonState extends State<CategoryButton>{

  bool? isClicked;

  @override
  void initState() {
    isClicked = widget.isClicked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialButton(
        color: isClicked!? postechRed : Colors.grey,
      child: Text(widget.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      onPressed: (){
          setState(() {
            isClicked = !isClicked!;
          });

          if(isClicked!){
            postKeyword(widget.text);
          }
          else{
            patchKeyword(widget.text);
          }
      });
  }

}


Future<void> postKeyword(String text) async {

  print("post Keyword");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/myAlarmCategory';

  var data = {'category' : text};

  try {
    Response response = await dio.post(url, data: data);
  } catch (e) {
    print('Error sending POST request : $e');
  }

  return;

}

Future<void> patchKeyword(String text) async {

  print("patch Keyword");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/myAlarmCategory';

  var data = {'category' : text};

  try {
    Response response = await dio.patch(url, data: data);
  } catch (e) {
    print('Error sending POST request : $e');
  }

  return;

}

Future<bool> getKeyword(List<String> list) async {

  print("get Keyword");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/myAlarmCategory';

  list.clear();

  try {
        Response response = await dio.get(url);
        dynamic jsonData = response.data;

        print("??");
        for(int i=0; i<jsonData.length; i++){
          list.add(jsonData[i]);
        }
        //print(jsonData[0]);
        // list = List<String>.from(jsonData['alarmList']);
        print(list.toString());


    } catch (e) {
    print('Error sending GET request : $e');
  }

  return true;

}

