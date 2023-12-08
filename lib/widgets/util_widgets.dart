import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/sub_selling_page_evaluation_page.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';
import '../entity/user_entity.dart';
import '../infra/my_info_data.dart';
import '../page/util_function.dart';
import '../usecases/util_usecases.dart';

class SupoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('슈포마켓',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'KBO-B',
              fontWeight: FontWeight.w700,
              fontSize: 35)),
    );
  }
}

class ItemName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          alignment: Alignment.center,
          width: 325.0,
          height: 80.0,
          padding: EdgeInsets.all(5),
          child: Stack(
            children: [
              TextField(
                onChanged: (event) {
                  // 알아서 넣어
                },
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '판매 제목을 작성하세요',
                  hintStyle: TextStyle(
                    color: Colors.grey[600], // labelText의 텍스트 색상
                    fontSize: 16.0, // labelText의 텍스트 크기 -> 이것
                    fontFamily: 'Tenada', // 알아서 변경할 것!!
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 활성 상태일 때 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 포커스 상태일 때 밑줄 색상
                  ),
                ),
              )
            ],
          ))
    ]);
  }
}

// 사진 넣는 + 넣는 아이콘은 기존거랑 동일하므로 추가하지 않음

class ItemPrice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          alignment: Alignment.center,
          width: 325.0,
          height: 80.0,
          padding: EdgeInsets.all(5),
          child: Stack(
            children: [
              TextField(
                onChanged: (event) {
                  // 알아서 넣어
                },
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '가격(원)',
                  hintStyle: TextStyle(
                    color: Colors.grey[600], // labelText의 텍스트 색상
                    fontSize: 16.0, // labelText의 텍스트 크기 -> 이것
                    fontFamily: 'Tenada', // 알아서 변경할 것!!
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 활성 상태일 때 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 포커스 상태일 때 밑줄 색상
                  ),
                ),
              )
            ],
          ))
    ]);
  }
}

class ItemDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          alignment: Alignment.center,
          width: 325.0,
          height: 200.0,
          // 이렇게만 해도 여백이 생겨버리네 (textField라는게 부모 높이 따라가는듯)
          padding: EdgeInsets.all(5),
          child: Stack(
            children: [
              TextField(
                onChanged: (event) {
                  // 알아서 넣어
                },
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: '추가로 알리고 싶은 내용을 적어주세요.',
                  hintStyle: TextStyle(
                    color: Colors.grey[600], // labelText의 텍스트 색상
                    fontSize: 16.0, // labelText의 텍스트 크기 -> 이것
                    fontFamily: 'Tenada', // 알아서 변경할 것!!
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 활성 상태일 때 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFB70001), width: 5), // 포커스 상태일 때 밑줄 색상
                  ),
                ),
              )
            ],
          ))
    ]);
  }
}

class ReallyBoughtPopUp extends StatefulWidget {

  final String itemId;
  final String traderId;

  const ReallyBoughtPopUp({super.key, required this.itemId, required this.traderId});

  @override
  State<StatefulWidget> createState() {
    return ReallyBoughtPopUpState();
  }
}

class ReallyBoughtPopUpState extends State<ReallyBoughtPopUp> with TickerProviderStateMixin {
  late AnimationController _bellController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  bool isLoading = false;
  String itemName = "";
  String traderName = "";
  String itemId = ""; String userId = '"';
  AUser user = AUser(email: "", userName: "", imagePath: "", isUserLogin: false, userStatus: UserStatus.NORMAL);

  @override
  void initState() {
    super.initState();
    itemId = widget.itemId; userId = widget.traderId;
    print("Really Bought Pop Up");
    print("initiate : $itemId + $userId");
    getInitInfo();
  }

  void getInitInfo() async{
    print("get User Info");
    user = await getUserInfo3(itemId);
    print("getUserInfo");
    traderName = user.userName!;
    itemName = await getItemById(itemId);
    print("getItemInfo");
  }

  @override
  void dispose() {
    //_controller.dispose(); // 페이지가 dispose 될 때 컨트롤러 해제
    _bellController.dispose();
    super.dispose();
    print("dispose");
  }

  @override
  void didUpdateWidget(ReallyBoughtPopUp oldWidget) {
    print("re build");
    super.didUpdateWidget(oldWidget);
    if (widget.itemId != oldWidget.itemId || widget.traderId != oldWidget.traderId) {
      setState(() {
        if(myUserInfo.requestList!.isNotEmpty) {
          itemId = myUserInfo.requestList![0]['itemId']!;
          userId = myUserInfo.requestList![0]['userId']!;
          _bellController.repeat();
        }
      });
    }
    print("didChange : $itemId + $userId");
    if(itemId == '-1' || userId == '=1'){
      print("stop");
      _bellController.stop();
    }

    getInitInfo();
  }

  @override
  Widget build(BuildContext context) {

    if(myUserInfo.requestList!.isNotEmpty){
      itemId = myUserInfo.requestList![0]['itemId']!;
      userId = myUserInfo.requestList![0]['userId']!;
    }


    return IconButton(
      splashRadius: 50,
      iconSize: 50,
      icon: Lottie.asset(LottieFiles.$63128_bell_icon,
          controller: _bellController,
          height: 30,
          fit: BoxFit.cover),

      onPressed: () {
        if(myUserInfo.requestList!.isNotEmpty){
          _bellController.repeat();
          setState(() {});
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('해당 물품을 거래하셨나요?'),
                  content: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Text('제목 :', style: TextStyle(fontFamily: 'KBO-B')),
                                  Expanded(
                                      child: Text(itemName)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text('판매자 :',
                                      style: TextStyle(fontFamily: 'KBO-B')),
                                  Expanded(child: Text(traderName)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      child: Text("예"),
                                      onPressed: () async {

                                        setState(() {
                                          isLoading = true;
                                        });

                                        await utilUsecase.patchRequestList(userId, itemId);
                                        await utilUsecase.postBuyingList(itemId);

                                        setState(() {
                                          isLoading = false;
                                        });
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubSellingPageEvaluationPage(
                                                        userID: int.parse(userId))));

                                        if (myUserInfo.requestList!.isEmpty && _bellController.isAnimating) { // 이거를 request 있을때로 바꾸어 줘야함
                                          _bellController.stop();
                                        } else {
                                          _bellController.repeat();
                                        }
                                      }
                                      ),

                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                      child: Text("아니오"),
                                      onPressed: () async{
                                        setState(() {
                                          isLoading = true;
                                        });
                                        print("userId : $userId");
                                        await utilUsecase.patchRequestList(userId, itemId);
                                        setState(() {
                                          isLoading = false;
                                        });

                                        await getMyInfoRequestList();
                                        if (myUserInfo.requestList!.isEmpty && _bellController.isAnimating) { // 이거를 request 있을때로 바꾸어 줘야함
                                          _bellController.stop();
                                        } else {
                                          _bellController.repeat();
                                        }

                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      isLoading ? const Center(
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
                      ) : const SizedBox(width: 0, height: 0),
                    ],
                  ),
                );
              });
        }else{
          _bellController.stop();
          print("stop");
          setState(() {});
        }
      },
    );
  }
}