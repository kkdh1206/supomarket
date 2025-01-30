import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/home_page/sub_home_page.dart';
import 'package:supo_market/page/home_page/widgets/home_page_widgets.dart';
import '../../entity/item_entity.dart';
import 'package:intl/intl.dart';
import '../../entity/user_entity.dart';
import '../../entity/util_entity.dart';
import '../../infra/item_list_data.dart';
import '../../notification.dart';
import '../../provider/socket_provider.dart';
import '../../widgets/util_widgets.dart';
import '../util_function.dart';

class HomePage extends StatefulWidget {
  final List<Item>? list;

  const HomePage({Key? key, required this.list}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item>? list;
  int refreshNum = 0;
  final options1 = [
    SortType.DATEASCEND,
    SortType.DATEDESCEND,
    SortType.PRICEDESCEND,
    SortType.PRICEASCEND
  ];

  final options2 = [
    ItemStatus.TRADING,
    // ItemStatus.SUPOFASTSELL, <--- 업데이트 시 급처분 되돌리기
    ItemStatus.RESERVED,
    ItemStatus.SOLDOUT, // 판매 완료 제거
  ];

  final options3 = [
    TradeType.ALL,
    TradeType.SELL,
    TradeType.BUY
  ];

  SortType selectedOption1 = SortType.DATEASCEND;
  ItemStatus selectedOption2 = ItemStatus.TRADING;
  TradeType selectedOption3 = TradeType.ALL;
  bool isMoreRequesting = false;
  bool _showPopup = true;

  int page = 1;
  int pageSize = 10;

  ScrollController scrollController = ScrollController();
  double scrollOffset = 0.0;
  bool isListened = false;
  bool isEnded = false;
  String? userUid = myUserInfo.userUid;
  String? popChecked;

  @override
  void initState() {
    debugPrint("Home Initiate");

    super.initState();
    //showNotification();
    onePageUpdateList();
    // updateList();
    isEnded = false; //리스트 끝에 도달함
    page = 1; //늘어난 page 리스트 수
    list = widget.list;
    refreshNum = 0; //새로고침 시
    selectedOption1 = options1[0];
    selectedOption2 = options2[0];
    selectedOption3 = options3[0];
    scrollOffset = 0.0;
    scrollController!.addListener(_scrollListener); //스크롤뷰 위치 이용 함수
    isMoreRequesting = false; //요청 중이면 circle progress
    isListened = false; //progress가 돌아가고 있으면 추가로 요청하지 않기 (한번만)
    //getUserPopup();
    checkPopUp();
    Request();
  }

  void Request() async {
    print("request home page");
    await getMyInfoRequestList();
    print(myUserInfo.requestList.toString());
  }

  Future<String> getUserPopup() async {
    // String res = await getPopUpState(userUid!);
    // setState(() {
    //   popChecked = res;
    // });
    // print("체크포인트");
    // print(res);
    return await getPopUpState(userUid!);
  }

  Future<void> checkPopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? doNotShowAgain = prefs.getBool('doNotShowAgain');
    String? lastShownDate = prefs.getString('lastShownDate');
    popChecked = await getUserPopup();
    print(popChecked);
    if(popChecked == "true") {
      setState(() {
        _showPopup = false;
      });
    }
    // else if(lastShownDate != null) {
    //   DateTime lastDate = DateTime.parse(lastShownDate);
    //   DateTime today = DateTime.now();
    //
    //   if(DateFormat('yyyy-MM-dd').format(lastDate) == DateFormat('yyyy-MM-dd').format(today)) {
    //     setState(() {
    //       _showPopup = false;
    //     });
    //   }
    // }
    print("체크포인트2");
    print(_showPopup);
    if(_showPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPopUpDialog();
      });
    }
  }

  Future<void> setDoNotShowAgain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setBool('doNotShowAgain', true);
    var token = await firebaseAuth.currentUser?.getIdToken();
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'updateAd': 'true',
    });
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url = 'https://kdh.supomarket.com/auth/ad';
    await dio.patch(url,data:{'updateAd' : 'true'});

    setState(() {
      _showPopup = false;
    });
  }

  Future<void> setDoNotShowToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastShownDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
    setState(() {
      _showPopup = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void _scrollListener() {
    if (scrollController!.offset + 500 >=
        scrollController!.position.maxScrollExtent &&
        !scrollController!.position.outOfRange &&
        !isListened &&
        !isEnded) {
      // 리스트의 마지막에 도달하면 새로운 리스트 아이템을 가져오는 함수 호출
      page++;
      isListened = true;
      updateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        toolbarHeight: 40,
        elevation: 0.0,
        title: Container(
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        //alignment: Alignment.center,
                        height: 25,
                        width: 105,
                        decoration: BoxDecoration(
                            color: Color(0xffB70001),
                            border: Border.all(color: Color(0xffB70001)),
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: const EdgeInsets.only(left: 10, bottom: 2),
                        child: DropdownButton(
                          dropdownColor: Color(0xffB70001),
                          icon: const SizedBox.shrink(),
                          underline: const SizedBox.shrink(),
                          value: selectedOption1,
                          items: options1
                              .map((e) => DropdownMenuItem(
                              value: e,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e == SortType.PRICEASCEND
                                            ? "가격 낮은 순"
                                            : e == SortType.PRICEDESCEND
                                            ? "가격 높은 순"
                                            : e == SortType.DATEASCEND
                                            ? "      최신 순"
                                            : "    오래된 순",
                                        textScaleFactor: 0.8,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ))))
                              .toList(),
                          onChanged: (value) async {
                            setState(() {
                              selectedOption1 = value!;
                              page = 1;
                              isListened = false;
                              isEnded = false;
                            });
                            updateList();
                          },
                          itemHeight: 50.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        //alignment: Alignment.center,
                        height: 25,
                        width: 105,
                        decoration: BoxDecoration(
                            color: Color(0xffB70001),
                            border: Border.all(color: Color(0xffB70001)),
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: const EdgeInsets.only(left: 10, bottom: 2),
                        child: DropdownButton(
                          dropdownColor: Color(0xffB70001),
                          icon: const SizedBox.shrink(),
                          underline: const SizedBox.shrink(),
                          value: selectedOption2,
                          items: options2
                              .map((e) => DropdownMenuItem(
                              value: e,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e == ItemStatus.TRADING
                                            ? "      거래 중"
                                            : e == ItemStatus.SOLDOUT
                                            ? "     판매 완료"
                                            : e == ItemStatus.RESERVED
                                            ? "       예약 중"
                                            : "    급처분 중",
                                        textScaleFactor: 0.8,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                              )
                          )
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedOption2 = value!;
                              page = 1;
                              isListened = false;
                              isEnded = false;
                            });
                            updateList();
                          },
                          itemHeight: 50.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        //alignment: Alignment.center,
                        height: 25,
                        width: 87,
                        decoration: BoxDecoration(
                            color: Color(0xffB70001),
                            border: Border.all(color: Color(0xffB70001)),
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: const EdgeInsets.only(left: 10, bottom: 2),
                        child: DropdownButton(
                          dropdownColor: Color(0xffB70001),
                          icon: const SizedBox.shrink(),
                          underline: const SizedBox.shrink(),
                          value: selectedOption3,
                          items: options3
                              .map((e) => DropdownMenuItem(
                              value: e,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e == TradeType.ALL
                                            ? "      전체"
                                            : e == TradeType.SELL
                                            ? "      팝니다"
                                            : "      삽니다",
                                        textScaleFactor: 0.8,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.arrow_drop_down_sharp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ))))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedOption3 = value!;
                              page = 1;
                              isListened = false;
                              isEnded = false;
                            });
                            updateList();
                          },
                          itemHeight: 50.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
      body: FutureBuilder(
          future: homePageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                //위로 드래그하면 새로고침 -> 업데이트 되는 위젯 (Refresh Indicator)
                child:

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          refreshNum += 1;
                          onePageUpdateList();
                          updateList();
                        },
                        child: ListView.builder(
                          controller: scrollController,
                          itemBuilder: (context, position) {
                            //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                            list![position].uploadDate = formatDate(
                                list![position].uploadDateForCompare ??
                                    DateTime.now());
                            //uploadDate를 현재 시간 기준으로 계속 업데이트하기
                            if (list![position].itemStatus !=
                                ItemStatus.USERFASTSELL) {
                              //급처분 아이템은 보여주지 않기
                              return ItemCard (
                                itemID: list![position].itemID!,
                                image: list![position].imageListB.isEmpty
                                    ? Image.asset("assets/images/main_logo.jpg",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover)
                                    : Image.network(
                                    list![position].imageListB[0],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover),
                                title: list![position].sellingTitle!,
                                date: list![position].uploadDate ?? "",
                                price: list![position].sellingPrice!,
                                view: list![position].view!,
                                onTap: () {
                                  debugPrint(list![position].sellerSchoolNum);
                                  debugPrint(list![position].sellerName);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SubHomePage(
                                            item: list![position],
                                            user: getUserInfo(
                                                list![position]),
                                          )));
                                },
                              );
                            } else {
                              return const SizedBox(height: 0, width: 0);
                            }
                          },
                          itemCount: list?.length,
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        isMoreRequesting
                            ? Container(
                          height: 20.0,
                          width: 20.0,
                          color: Colors.transparent,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                            : const SizedBox(width: 0, height: 0),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: Colors.black45,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  void updateList() async {
    debugPrint("update List 함수 호출");
    await getItemMain(page, selectedOption1, selectedOption2, selectedOption3);
    isListened = false;
  }

  // Future<void> moreSpaceFunction() async {
  //   if (scrollController.hasClients && page != 1) {
  //     scrollController.jumpTo(scrollOffset + 50);
  //     debugPrint("jump to $scrollOffset+50");
  //   }
  //   return;
  // }

  void onePageUpdateList() {
    setState(() {
      homePageBuilder = getItem(1, selectedOption1, selectedOption2, selectedOption3);
    });
  }

  void showPopUpDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '업데이트 및 공지',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: '채팅알림 수신 밑 발신을 위해 꼭 알림을 켜주세요! 알림을 키지 않으면 물건 구매 요청 유무를 알기 힘듭니다.\n\n',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // 기본 텍스트 색상을 설정해야 합니다.
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '물건을 판매하는 탭만이 아니라 구매를 원하는 물건이 있을 때 요청하는 탭도 추가되었습니다. 더불어 배달음식 공동 구매, 짐 옮기기 등 서로의 도움이 필요할 때 서비스를 요청하는 "구인" 카테고리도 추가되었습니다.',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              setDoNotShowToday();
                              Navigator.of(context).pop();
                            },
                            child: Text('오늘 하루 보지 않기'),
                          ),
                          TextButton(
                            onPressed: () {
                              setDoNotShowAgain();
                              Navigator.of(context).pop();
                            },
                            child: Text('다시 보지 않기'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  //homePage에서의 get (나머지는 page 1 로딩을 위한 getData in Control/Add)
  Future<bool> getItemMain(int page, SortType type, ItemStatus status, TradeType sellBuy) async {
    ItemType? tempItemType;
    ItemStatus? tempItemStatus;
    ItemQuality? tempItemQuality;
    String? tempSellerName;
    String? tempSellerSchoolNum;
    int pageSize = 10;

    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'https://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&status=${ConvertEnumToString(status)}&buy=${ConvertEnumToString(sellBuy)}&page=${page}&pageSize=${pageSize}';

    if (page == 1) {
      itemList.clear();
    }

    try {
      Response response = await dio.get(url);
      // Map<String, dynamic> JsonData = json.decode(response.data);
      dynamic jsonData = response.data;

      if (jsonData.toString() != "true") {
        debugPrint("List 개수 update");

        setState(() {
          isMoreRequesting = true;
        });
        await Future.delayed(Duration(milliseconds: 100));

        for (var data in jsonData) {
          int id = data['id'] as int;
          String title = data['title'] as String;
          String description = data['description'] as String;
          int price = data['price'] as int;
          int view = data['view'] as int;

          String status = data['status'] as String; //--> 이 부분은 수정 코드 주면 그때 실행하기
          tempItemStatus = convertStringToEnum(status);

          String quality = data['quality'] as String;
          tempItemQuality = convertStringToEnum(quality);

          String category = data['category'] as String;
          tempItemType = convertStringToEnum(category);

          String updatedAt = data['updatedAt'] as String;
          List<String> imageUrl = List<String>.from(data['ImageUrls']);

          // 사진도 받아야하는데
          DateTime dateTime = DateTime.parse(updatedAt);
          print("date" + dateTime.toString());

          // 시간 어떻게 받아올지 고민하기!!!!!!
          // 그리고 userId 는 현재 null 상태 해결해야함!!!
          itemList.add(Item(
              sellingTitle: title,
              itemType: tempItemType,
              itemQuality: tempItemQuality!,
              sellerName: "정태형",
              sellingPrice: price,
              uploadDate: "10일 전",
              uploadDateForCompare: dateTime,
              itemDetail: description,
              view: view,
              sellerImage:
              "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96",
              isLiked: false,
              sellerSchoolNum: "20220000",
              imageListA: [],
              imageListB: imageUrl,
              itemStatus: tempItemStatus!,
              itemID: id));
        }

        //await moreSpaceFunction();

        setState(() {
          isMoreRequesting = false;
        });
      } else {
        setState(() {
          isEnded = true;
        });
      }
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }
}



//일회성 알림
void showNotification() async {
  print("notiification");

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(1, '제목1', '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: '부가정보' // 부가정보
  );
}


// //서버 푸시 알림
// Future<void> _listenerWithTerminated() async {
//   FlutterLocalNotificationsPlugin _localNotification = FlutterLocalNotificationsPlugin();
//
//   NotificationAppLaunchDetails? details = await _localNotification.getNotificationAppLaunchDetails();
//   if (details != null) {
//     if (details.didNotificationLaunchApp) {
//       if (details.payload != null) {
//         _localNotificationRouter(details.payload!);
//       }
//     }
//   }
// }