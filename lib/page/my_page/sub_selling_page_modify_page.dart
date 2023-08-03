import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import '../../entity/item_entity.dart';

Color postechRed = Color(0xffac145a);
String temp = "";

class SubSellingPageModifyPage extends StatefulWidget {

  final Item item;
  const SubSellingPageModifyPage({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubSellingPageModifyPageState();
  }

}

class _SubSellingPageModifyPageState extends State<SubSellingPageModifyPage> {

  late Item originalItem;
  Item modifiedItem = Item(sellingTitle: "", itemType: ItemType.ETC, itemQuality: ItemQuality.HIGH, sellerName: "", sellingPrice: 0, uploadDate: "", sellerImage: "", isLiked : false, uploadDateForCompare: DateTime(2000, 12, 31), sellerSchoolNum: "20000000", imageListA : [], imageListB: [], itemStatus: ItemStatus.TRADING);
  FixedExtentScrollController? firstController;
  FixedExtentScrollController? secondController;
  bool isFastSellForToggle = false;

  @override
  void initState(){
    super.initState();

    debugPrint("modifyPage initiate");
    firstController = FixedExtentScrollController(initialItem: 0);
    secondController = FixedExtentScrollController(initialItem: 0);
    originalItem = widget.item;

    //temp modified item 에 얕은 복사
    modifiedItem.sellingTitle = originalItem.sellingTitle;
    modifiedItem.itemType = originalItem.itemType;
    modifiedItem.itemQuality = originalItem.itemQuality;
    modifiedItem.sellingPrice = originalItem.sellingPrice;
    modifiedItem.imageListB = originalItem.imageListB;
    modifiedItem.itemDetail = originalItem.itemDetail;
    modifiedItem.itemStatus = originalItem.itemStatus;
    modifiedItem.itemType = originalItem.itemType;
    isFastSellForToggle = (originalItem.itemStatus == ItemStatus.FASTSELL);
  }

  @override
  void dispose(){
    super.dispose();
    debugPrint("modify page dispose");
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
            child: IconButton (onPressed: () {
              Navigator.pop(context,
                ReturnData(returnType: 'exit',
                    sellingTitle: modifiedItem.sellingTitle??"",
                    imagePath: modifiedItem.imageListB.isEmpty?[]:modifiedItem.imageListB,
                    itemType: modifiedItem.itemType??ItemType.ETC,
                    itemQuality: modifiedItem.itemQuality??ItemQuality.MID,
                    sellingPrice: modifiedItem.sellingPrice??0,
                    itemDetail: modifiedItem.itemDetail??"",
                    itemStatus: modifiedItem.itemStatus??ItemStatus.TRADING));
              },
                icon: const Icon(Icons.clear, color: Colors.black45), iconSize: 30)
        ),
        actions: <Widget>[TextButton(
          onPressed: (){
            setState(() {
              //DataTime format으로 등록 시간을 받고, control page에서 현재 시간과 비교 및 제출
              modifiedItem.uploadDate = "방금 전";
              modifiedItem.uploadDateForCompare = DateTime.now();
            });
            Navigator.pop(context, ReturnData(returnType: 'modified',
                sellingTitle: modifiedItem.sellingTitle??"",
                itemType: modifiedItem.itemType??ItemType.BOOK,
                itemQuality: modifiedItem.itemQuality??ItemQuality.MID,
                sellingPrice: modifiedItem.sellingPrice??0,

                itemDetail: modifiedItem.itemDetail??"",
                imagePath: modifiedItem.imageListB??[],
                itemStatus : modifiedItem.itemStatus??ItemStatus.TRADING,
            )
            );
          },
          style: OutlinedButton.styleFrom(backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ), child: const Text("수정하기" ,style: TextStyle(fontSize: 15, color: Colors.black45, fontWeight: FontWeight.bold),),),
          const SizedBox(width:10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left:10, right:10),
                child: TextFormField(
                  initialValue : modifiedItem.sellingTitle,
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
                    setState((){modifiedItem.sellingTitle = text;});
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
                                        case(0) : modifiedItem.itemType = ItemType.REFRIGERATOR;
                                        case(1) : modifiedItem.itemType = ItemType.CLOTHES;
                                        case(2) : modifiedItem.itemType = ItemType.ROOM;
                                        case(3) : modifiedItem.itemType= ItemType.MONITOR;
                                        case(4) : modifiedItem.itemType = ItemType.BOOK;
                                        case(5) : modifiedItem.itemType = ItemType.ETC;
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
                }, child: Text("상품 종류 : ${modifiedItem.itemType == ItemType.REFRIGERATOR? "냉장고":
                  modifiedItem.itemType == ItemType.MONITOR? "모니터":
                  modifiedItem.itemType == ItemType.BOOK? "책":
                  modifiedItem.itemType == ItemType.ROOM? "자취방":
                  modifiedItem.itemType == ItemType.CLOTHES? "옷": "기타"}", textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.w400), textAlign: TextAlign.start),
                  ),
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
                                        case(0) : modifiedItem.itemQuality = ItemQuality.HIGH;
                                        case(1) : modifiedItem.itemQuality = ItemQuality.MID;
                                        case(2) : modifiedItem.itemQuality = ItemQuality.LOW;
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
                }, child:  Text("품질 : ${modifiedItem.itemQuality == ItemQuality.HIGH? "상" :
              modifiedItem.itemQuality == ItemQuality.MID? "중" :"하"}"),
              ),
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
                value: isFastSellForToggle,
                activeColor: CupertinoColors.activeOrange,
                onChanged: (bool? value) {
                  // 스위치가 토글될 때 실행될 코드
                  setState(() {
                    modifiedItem.itemStatus = (value==true? ItemStatus.FASTSELL : ItemStatus.TRADING);
                    isFastSellForToggle = value??false;
                  });
                },
              ),
            ],
          ),

          //가격
          Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left:10, right:10),
                child: TextFormField(
                  initialValue: modifiedItem.sellingPrice.toString(),
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
                  onChanged: (text) {
                    setState((){temp = text; modifiedItem.sellingPrice =  int.parse(temp);});
                  },
                ),
              )
          ),
          const SizedBox(height: 10),
          //내용
          Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left:10, right:10),
                child: TextFormField(
                  initialValue : modifiedItem.itemDetail,
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
                    setState((){modifiedItem.itemDetail = text;});
                  },
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget LoadImageButton() {
    debugPrint(modifiedItem.imageListB.length.toString());
    return modifiedItem.imageListB.isEmpty ?
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
                itemCount: modifiedItem.imageListB?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Stack(
                        children: [
                          RawMaterialButton(onPressed: () {
                            setState(() {
                              //편집 기능
                            });
                          },
                              child: Image.network(
                                  modifiedItem.imageListB![index], width: 100, height: 100, fit: BoxFit.fitHeight)),
                          Positioned(
                            right: -20,
                            child: RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  modifiedItem.imageListB!.removeAt(index);
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
                          const SizedBox(width: 10),
                        ],
                      ),
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
              if(modifiedItem.imageListB.length == 5){
                _showDialog();
              }
              else{
                text == "카메라 열기" ? getImageFromCamera() : getImage();
              }
            },
          ),
        ),
        Text(text),
      ],
    );
  }


  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000
    );

    if(pickedFile.length + modifiedItem.imageListB.length> 5){
      _showDialog();
    }
    else if(pickedFile != null) {
      setState(() {
        modifiedItem.imageListA.addAll(pickedFile);
        //B로 변환
        for(int i = 0; i<pickedFile.length; i++){
          modifiedItem.imageListB.add("https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Frefri_sample.png?alt=media&token=9133fb86-40a9-4b89-b54b-0883039cbb63");
        }
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
        modifiedItem.imageListA.add(pickedFile);
        //A를 B로 변환
        modifiedItem.imageListB.add("https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Frefri_sample.png?alt=media&token=9133fb86-40a9-4b89-b54b-0883039cbb63");

      });
    }
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
  String sellingTitle;
  List<String> imagePath;
  ItemType itemType;
  ItemQuality itemQuality;
  ItemStatus itemStatus;
  int sellingPrice;
  String itemDetail;
  String returnType;

  ReturnData(
      {required this.sellingTitle,
        required this.imagePath,
        required this.itemType,
        required this.itemQuality,
        required this.sellingPrice,
        required this.itemDetail,
        required this.returnType,
        required this.itemStatus,});
}