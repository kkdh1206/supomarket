import 'dart:io';
import 'dart:async';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supo_market/infra/my_info_data.dart';
import '../entity/goods_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';


Color postechRed = Color(0xffac145a);
String temp = "";
Map<String, int> myData = Map();

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
  Goods newGoods = Goods(sellingTitle: "",
      goodsType: "",
      goodsQuality: "",
      sellerName: "",
      imagePath_1: "",
      sellingPrice: 0,
      uploadDate: "",
      sellerImage: "",
      isLiked: false,
      isQuickSell: false,
      uploadDateForCompare: DateTime.now(),
      sellerSchoolNum: '20000000',
      imageList : []);



  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000
    );

    if(pickedFile.length + newGoods.imageList.length> 5){
      _showDialog();
    }
    else if(pickedFile != null) {
      setState(() {
        newGoods.imageList.addAll(pickedFile);
      });
    }
  }

  Future getImageFromCamera() async{
    final pickedFile = await picker.pickImage(
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000,
        source: ImageSource.camera,
    );

    if(pickedFile != null){
      setState(() {
        newGoods.imageList.add(pickedFile);
      });
    }
  }



    @override
    void initState() {
      super.initState();
      newGoods.goodsType = "";
      newGoods.goodsQuality = "";
      newGoods.sellingPrice = 0;

      debugPrint(
          "addGoodsPage initiate, 현재 list 3번은 ${list?[2].goodsQuality} 퀄리티이다.");
      newGoods.imagePath_1 = "assets/images/main_logo.jpg";
      newGoods.sellerImage = "assets/images/user.png";
      firstController = FixedExtentScrollController(initialItem: 0);
      secondController = FixedExtentScrollController(initialItem: 0);
      list = widget.list;
    }

    @override
    void dispose() {
      super.dispose();
      debugPrint("add page dispose");
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 60,
          leading: Padding(padding: const EdgeInsets.only(top: 10, left: 10),
              child: IconButton(onPressed: () {
                Navigator.pop(
                    context, ReturnData(goods: newGoods, returnType: "exit"));
              },
                  icon: const Icon(Icons.clear, color: Colors.black45),
                  iconSize: 30)
          ),
          actions: <Widget>[TextButton(
            onPressed: () {
              setState(() {
                //DataTime format으로 등록 시간을 받고, control page에서 현재 시간과 비교 및 제출
                newGoods.uploadDate = "방금 전";
                newGoods.uploadDateForCompare = DateTime.now();
              });
              Navigator.pop(
                  context, ReturnData(goods: newGoods, returnType: "add"));
            },
            style: OutlinedButton.styleFrom(backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text("등록하기", style: TextStyle(fontSize: 15,
                color: Colors.black45,
                fontWeight: FontWeight.bold),),),
            const SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                      setState(() {
                        newGoods.sellingTitle = text;
                      });
                    },
                  ),
                )
            ),
            const SizedBox(height: 10),

            //사진 추가 위젯
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                LoadImageButton(),
              ],
            ),
            const SizedBox(height: 10),

            //Cupertino Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 40),
                  color: postechRed,
                  onPressed: () {
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
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        switch (index) {
                                          case(0) :
                                            newGoods.goodsType = "냉장고";
                                          case(1) :
                                            newGoods.goodsType = "의류";
                                          case(2) :
                                            newGoods.goodsType = "자취방";
                                          case(3) :
                                            newGoods.goodsType = "모니터";
                                          case(4) :
                                            newGoods.goodsType = "책";
                                          case(5) :
                                            newGoods.goodsType = "기타";
                                        }
                                      });
                                    },
                                    children: List<Widget>.generate(6, (index) {
                                      return Center(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              index == 0 ? "냉장고" : index == 1
                                                  ? "의류"
                                                  : index == 2 ? "자취방" :
                                              index == 3 ? "모니터" : index == 4
                                                  ? "책"
                                                  : "기타",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight
                                                      .bold),)),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                  child: Text("카테고리 : ${newGoods.goodsType}"),),
                const SizedBox(width: 10),
                CupertinoButton(
                  minSize: 0,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 50),
                  color: postechRed,
                  onPressed: () {
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
                                    onSelectedItemChanged: (Index) {
                                      setState(() {
                                        switch (Index) {
                                          case(0) :
                                            newGoods.goodsQuality = "상";
                                          case(1) :
                                            newGoods.goodsQuality = "중";
                                          case(2) :
                                            newGoods.goodsQuality = "하";
                                        }
                                      });
                                    },
                                    children: List<Widget>.generate(3, (Index) {
                                      return Center(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              Index == 0 ? "상" : Index == 1
                                                  ? "중"
                                                  : "하", style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),)),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                  child: Text("품질 : ${newGoods.goodsQuality}"),),
              ],
            ),
            const SizedBox(height: 10),

            //급처분 버튼
            Row(
              children: [
                const SizedBox(width: 20),
                const Text("급처분 : ", style: TextStyle(fontSize: 15)),
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
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                      setState(() {
                        temp = text;
                        newGoods.sellingPrice = int.parse(temp);
                      });
                    },
                  ),
                )
            ),
            const SizedBox(height: 10),
            //내용
            Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                      setState(() {
                        newGoods.goodsDetail = text;
                      });
                    },
                  ),
                )
            ),
          ],
        ),
      );
    }

    // //사진 권한 요청
    // Future<bool> permission() async {
    //   Map<Permission, PermissionStatus> status =
    //   await [Permission.location].request(); // [] 권한배열에 권한을 작성
    //
    //   if (await Permission.location.isGranted) {
    //     return Future.value(true);
    //   } else {
    //     return Future.value(false);
    //   }
    // }

    Widget LoadImageButton() {
    debugPrint(newGoods.imageList.length.toString());
      return newGoods.imageList.isEmpty ?
        PlusMaterialButton()
        : Flexible(
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                PlusMaterialButton(),
                const SizedBox(width: 10),
                Expanded(child:
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newGoods.imageList?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                          Stack(
                              children: [
                                  RawMaterialButton(onPressed: (){
                                    setState(() {
                                        //편집 기능
                                    });
                                  },
                                     child: Image.file(File(newGoods.imageList![index].path),
                                      width: 100, height: 100, fit: BoxFit.fitHeight)
                                  ),
                                  Positioned(
                                    right: -20,
                                    child: RawMaterialButton(
                                    onPressed: (){
                                      setState(() {
                                        newGoods.imageList!.removeAt(index);
                                      });
                                    },
                                      shape: const CircleBorder(),
                                      fillColor: Colors.white,
                                        child: const Padding(
                                        padding: EdgeInsets.all(0.0),
                                          child: Icon(
                                            Icons.close,
                                            size: 25,
                                            color: Colors.black45,
                                            ),
                                          ),
                                      ),
                                    ),
                              ],
                          ),
                        const SizedBox(width: 10),
                      ],
                    );
                  },
                ),
                ),
              ],
            )
          ),
      );
  }

  Widget CameraGalleryButton(String text, Icon icon) {
    return Column(
      children: [
          Container(
            width: 60, height: 60,
              decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
           child: IconButton(
              color: Colors.grey[200],
              icon: icon,
                onPressed: (){

                  if(newGoods.imageList.length == 5){
                    _showDialog();
                  }
                  else{
                    text == "카메라 열기" ? getImageFromCamera()
                        : getImage();
                  }
                },
              ),
          ),
          Text(text),
        ],
      );
  }

  //5장을 넘길 때 팝업 경고창
  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          //화면 잘리는 것 방지
          content: const SingleChildScrollView(child:Text("업로드 가능한 이미지 수는 5장 입니다")),
          actions: <Widget>[
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget PlusMaterialButton () {
    return RawMaterialButton(
      onPressed: () async {
        showModalBottomSheet(context: context,
          enableDrag: true,
          isDismissible: true,
          barrierColor: Colors.black.withOpacity(0.1),
          constraints: const BoxConstraints( //크기 설정
            minWidth: 500,
            maxWidth: 500,
            minHeight: 100,
            maxHeight: 150,
          ),
          isScrollControlled: true,
          builder: (BuildContext context) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CameraGalleryButton("카메라 열기", const Icon(Icons.camera, color: Colors.black45,)),
                        const SizedBox(width: 30),
                        CameraGalleryButton("갤러리 열기", const Icon(Icons.image, color : Colors.black45)),
                      ],
                    ),
                  ],
                )
            );
          },
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }
}

class ReturnData {
  Goods goods;
  String returnType;

  ReturnData(
      {required this.goods,
        required this.returnType});

}


