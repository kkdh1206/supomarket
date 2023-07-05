import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entity/goods_entity.dart';
import 'package:flutter/cupertino.dart';

Color postechRed = Color(0xffac145a);
Goods newGoods = Goods(sellingTitle: "", goodsType: "", goodsQuality: "", sellerName: "", imagePath_1: "", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false,isQuickSell: false);
String temp = "";

class SubAddGoodsPage extends StatefulWidget {

  final List<Goods> list;
  const SubAddGoodsPage({Key? key, required this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubAddGoodsPageState();
  }

}

class _SubAddGoodsPageState extends State<SubAddGoodsPage> {

  List<Goods>? list;
  FixedExtentScrollController? firstController;
  FixedExtentScrollController? secondController;

  @override
  void initState(){
    super.initState();
    debugPrint("addGoodsPage initiate, 현재 list 3번은 ${list?[2].goodsQuality} 퀄리티이다.");
    newGoods.imagePath_1 = "assets/images/main_logo.jpg";
    newGoods.sellerImage = "assets/images/user.png";
    firstController = FixedExtentScrollController(initialItem: 0);
    secondController = FixedExtentScrollController(initialItem: 0);
    list = widget.list;
  }

  @override
  void dispose(){
    super.dispose();
    debugPrint(list?[2].goodsQuality);
    newGoods.goodsType = "";
    newGoods.goodsQuality = "";
    newGoods.sellingPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Padding(padding: const EdgeInsets.only(top:10, left: 10),
            child: IconButton (onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.clear, color: Colors.black45), iconSize: 30)
        ),
        actions: <Widget>[TextButton(
          onPressed: (){
            setState(() {
              widget.list?.add(newGoods);
              Navigator.of(context).pop(1);
            });
          },
          style: OutlinedButton.styleFrom(backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ), child: const Text("등록하기" ,style: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),),),
        const SizedBox(width:10),
        ],
      ),
      body: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left:10, right:10),
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                      enabledBorder: UnderlineInputBorder(
                      ),
                    hintText: '판매 제목을 작성하세요',
                  ),
                  onChanged: (text) {
                    setState((){newGoods.sellingTitle = text;});
                  },
                ),
              )
            ),
            const SizedBox(height: 10),

            //사진 추가 위젯
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width:10),
                RawMaterialButton(
                    onPressed: (){
                      //사진 추가
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: const Icon(Icons.add, color: Colors.grey),
                    )
                ),
              ],
            ),
            const SizedBox(height: 10),

            //Cupertino Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  color: postechRed,
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
                              scrollController: firstController,
                              onSelectedItemChanged: (index){
                                setState(() {
                                  switch(index){
                                    case(0) : newGoods.goodsType = "냉장고";
                                    case(1) : newGoods.goodsType = "의류";
                                    case(2) : newGoods.goodsType = "자취방";
                                    case(3) : newGoods.goodsType= "모니터";
                                    case(4) : newGoods.goodsType = "책";
                                    case(5) : newGoods.goodsType = "기타";
                                  }
                                });
                              },
                              children: List<Widget>.generate(6, (index){
                                return Center(
                                  child: TextButton(
                                      onPressed: (){Navigator.pop(context);},
                                      child: Text(index==0?"냉장고":index==1?"의류":index==2?"자취방":
                                        index==3?"모니터":index==4?"책":"기타", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),)),
                                );
                              }),
                            ),
                          ),
                        ],
                        ),
                      );
                    }
                  );
                }, child: Text("카테고리 : ${newGoods.goodsType}"),),
                const SizedBox(width: 10),
                CupertinoButton(
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  color: postechRed,
                  onPressed: (){
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 400,
                            width: 400,
                            child: Column(
                              children: [
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 50,
                                    backgroundColor: Colors.white,
                                    scrollController: secondController,
                                    onSelectedItemChanged: (Index){
                                      setState(() {
                                        switch(Index){
                                          case(0) : newGoods.goodsQuality = "상";
                                          case(1) : newGoods.goodsQuality = "중";
                                          case(2) : newGoods.goodsQuality = "하";
                                        }
                                      });
                                    },
                                    children: List<Widget>.generate(3, (Index){
                                      return Center(
                                        child: TextButton(
                                            onPressed: (){Navigator.pop(context);},
                                            child: Text(Index==0?"상":Index==1?"중":"하", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),)),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  }, child: Text("품질 : ${newGoods.goodsQuality}"),),
              ],
            ),
            const SizedBox(height: 10),

            //급처분 버튼
            Row(
              children: [
                const SizedBox(width: 20),
                const Text("급처분 : ", style: TextStyle(fontSize:15)),
                CupertinoSwitch(
                  // 급처분 여부
                  value: newGoods.isQuickSell,
                  activeColor: CupertinoColors.activeOrange,
                  onChanged: (bool? value) {
                    // 스위치가 토글될 때 실행될 코드
                    setState(() {
                      newGoods.isQuickSell = value ?? false;
                    });
                  },
                ),
              ],
            ),

            //가격
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left:10, right:10),
                  child: TextField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      enabledBorder: UnderlineInputBorder(
                      ),
                      hintText: '가격 (원)',
                    ),
                      keyboardType: TextInputType.number,
                      // inputFormatters: <TextInputFormatter>[
                      //   CurrencyTextInputFormatter(
                      //     locale: 'ko',//한국화폐
                      //     decimalDigits: 0, //10진수
                      //     symbol: '￦', //원
                      //   ),
                      // ],
                    onChanged: (text) {
                        setState((){temp = text; newGoods.sellingPrice =  int.parse(temp);});
                      },
                  ),
                )
            ),
            const SizedBox(height: 10),
            //내용
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left:10, right:10),
                  child: TextField(
                    maxLines: 10,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      enabledBorder: UnderlineInputBorder(
                      ),
                      hintText: '추가로 알리고 싶은 내용을 적어주세요',
                    ),
                    onChanged: (text) {
                      setState((){newGoods.goodsDetail = text;});
                    },
                  ),
                )
            ),
        ],
      ),
    );
  }
}