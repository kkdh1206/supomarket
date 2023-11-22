import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/page/my_page/sub_selling_page_evaluation_page.dart';

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
  final String itemName;
  final String traderName;

  const ReallyBoughtPopUp({super.key, required this.itemId, required this.traderId, required this.itemName, required this.traderName, });

  @override
  State<StatefulWidget> createState() {
    return ReallyBoughtPopUpState();
  }
}

class ReallyBoughtPopUpState extends State<ReallyBoughtPopUp> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text("Open Popup"),
      onPressed: () {
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
                                    child: Text(widget.itemName)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text('판매자 :',
                                    style: TextStyle(fontFamily: 'KBO-B')),
                                Expanded(child: Text(widget.traderName)),
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
                                      await utilUsecase.postReallyBought('9','9');
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubSellingPageEvaluationPage(
                                                      userID: int.parse(widget.traderId))));
                                    }),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    child: Text("아니오"),
                                    onPressed: () {
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
      },
    );
  }
}