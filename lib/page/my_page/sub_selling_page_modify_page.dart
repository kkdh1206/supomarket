import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:supo_market/usecases/util_usecases.dart';
import '../../entity/item_entity.dart';
import '../../entity/util_entity.dart';
import '../util_function.dart';

String temp = "";

class SubSellingPageModifyPage extends StatefulWidget {
  final Item item;

  const SubSellingPageModifyPage({Key? key, required this.item})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubSellingPageModifyPageState();
  }
}

class _SubSellingPageModifyPageState extends State<SubSellingPageModifyPage> {
  late Item originalItem;
  Item modifiedItem = Item(
      sellingTitle: "",
      itemType: ItemType.ETC,
      itemQuality: ItemQuality.HIGH,
      sellerName: "",
      sellingPrice: 0,
      uploadDate: "",
      sellerImage: "",
      isLiked: false,
      uploadDateForCompare: DateTime(2000, 12, 31),
      sellerSchoolNum: "20000000",
      imageListA: [],
      imageListB: [],
      itemStatus: ItemStatus.TRADING,
      itemID: 1);
  FixedExtentScrollController? firstController;
  FixedExtentScrollController? secondController;
  bool isFastSellForToggle = false;

  @override
  void initState() {
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
    modifiedItem.imageListA = originalItem.imageListA;
    modifiedItem.imageListB = originalItem.imageListB;
    modifiedItem.itemDetail = originalItem.itemDetail;
    modifiedItem.itemStatus = originalItem.itemStatus;
    modifiedItem.itemType = originalItem.itemType;
    modifiedItem.itemID = originalItem.itemID;
    isFastSellForToggle = (originalItem.itemStatus == ItemStatus.USERFASTSELL);
    debugPrint(
        "총 list수 ${modifiedItem.imageListA.length.toString() + modifiedItem.imageListB.length.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("modify page dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(color: Colors.white),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Padding(
            padding: const EdgeInsets.only(top: 0, left: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      ReturnData(
                        returnType: 'exit',
                        sellingTitle: modifiedItem.sellingTitle ?? "",
                        imagePath: modifiedItem.imageListB.isEmpty
                            ? []
                            : modifiedItem.imageListB,
                        itemType: modifiedItem.itemType ?? ItemType.ETC,
                        itemQuality:
                            modifiedItem.itemQuality ?? ItemQuality.MID,
                        sellingPrice: modifiedItem.sellingPrice ?? 0,
                        itemDetail: modifiedItem.itemDetail ?? "",
                        itemStatus:
                            modifiedItem.itemStatus ?? ItemStatus.TRADING,
                        itemID: originalItem.itemID!,
                        imageListA: modifiedItem.imageListA,
                        imageListB: modifiedItem.imageListB,
                      ));
                },
                icon: const Icon(Icons.clear, color: Colors.black45),
                iconSize: 30)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (modifiedItem.sellingTitle!.length < 5) {
                _popUp("판매 제목은 5글자 이상이어야 합니다", context);
              } else if (modifiedItem.imageListB.isEmpty) {
                _popUp("최소 하나의 사진을 첨부 해야 합니다", context);
              } else if (modifiedItem.sellingPrice.isNegative ||
                  modifiedItem.sellingPrice.isNaN) {
                _popUp("가격을 제시해 주세요", context);
              } else if (modifiedItem.itemDetail == null ||
                  modifiedItem.itemDetail!.length < 10) {
                _popUp("세부 내용을 10글자 이상 작성해 주세요", context);
              } else {
                setState(() {
                  //DataTime format으로 등록 시간을 받고, control page에서 현재 시간과 비교 및 제출
                  modifiedItem.uploadDate = "방금 전";
                  modifiedItem.uploadDateForCompare = DateTime.now();
                });

                debugPrint("modifiedItem 사진은 ${modifiedItem.imageListA}");
                Navigator.pop(
                    context,
                    ReturnData(
                      returnType: 'modified',
                      sellingTitle: modifiedItem.sellingTitle ?? "",
                      itemType: modifiedItem.itemType ?? ItemType.BOOK,
                      itemQuality: modifiedItem.itemQuality ?? ItemQuality.MID,
                      sellingPrice: modifiedItem.sellingPrice ?? 0,
                      itemDetail: modifiedItem.itemDetail ?? "",
                      imagePath: modifiedItem.imageListB ?? [],
                      itemStatus: modifiedItem.itemStatus ?? ItemStatus.TRADING,
                      itemID: originalItem.itemID!,
                      imageListA:
                          modifiedItem.imageListA ?? originalItem.imageListA,
                      imageListB: modifiedItem.imageListB,
                    ));
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text(
              "수정하기",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black45,
                fontFamily: 'KBO-M',
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Flexible(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  alignment: Alignment.center,
                  width: 350.0,
                  height: 80.0,
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            modifiedItem.sellingTitle = text;
                          });
                        },
                        initialValue: modifiedItem.sellingTitle,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '판매 제목을 작성하세요',
                          hintStyle: TextStyle(
                            color: Colors.grey[600], // labelText의 텍스트 색상
                            fontSize: 18.0, // labelText의 텍스트 크기 -> 이것
                            fontFamily: 'KBO-L', // 알아서 변경할 것!!
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 활성 상태일 때 밑줄 색상
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 포커스 상태일 때 밑줄 색상
                          ),
                        ),
                      ),
                    ],
                  ))
            ]),
          ),
          const SizedBox(height: 10),

          //사진 추가 위젯
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              LoadImageButton(),
            ],
          ),
          const SizedBox(height: 10),

          //Cupertino Button
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              SizedBox(
                width: 150,
                child: CupertinoButton(
                  minSize: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  color: mainColor,
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
                                          case (0):
                                            modifiedItem.itemType =
                                                ItemType.REFRIGERATOR;
                                          case (1):
                                            modifiedItem.itemType =
                                                ItemType.CLOTHES;
                                          case (2):
                                            modifiedItem.itemType =
                                                ItemType.ROOM;
                                          case (3):
                                            modifiedItem.itemType =
                                                ItemType.MONITOR;
                                          case (4):
                                            modifiedItem.itemType =
                                                ItemType.BOOK;
                                          case (5):
                                            modifiedItem.itemType =
                                                ItemType.ETC;
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
                                              index == 0
                                                  ? "냉장고"
                                                  : index == 1
                                                      ? "의류"
                                                      : index == 2
                                                          ? "자취방"
                                                          : index == 3
                                                              ? "모니터"
                                                              : index == 4
                                                                  ? "책"
                                                                  : "기타",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    "상품 종류 : ${modifiedItem.itemType == ItemType.REFRIGERATOR ? "냉장고" : modifiedItem.itemType == ItemType.MONITOR ? "모니터" : modifiedItem.itemType == ItemType.BOOK ? "책" : modifiedItem.itemType == ItemType.ROOM ? "자취방" : modifiedItem.itemType == ItemType.CLOTHES ? "의류" : "기타"}",
                    textScaleFactor: 1.0,
                    style: const TextStyle(fontFamily: 'KBO-B', fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: CupertinoButton(
                  minSize: 0,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  color: mainColor,
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
                                          case (0):
                                            modifiedItem.itemQuality =
                                                ItemQuality.HIGH;
                                          case (1):
                                            modifiedItem.itemQuality =
                                                ItemQuality.MID;
                                          case (2):
                                            modifiedItem.itemQuality =
                                                ItemQuality.LOW;
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
                                              Index == 0
                                                  ? "상"
                                                  : Index == 1
                                                      ? "중"
                                                      : "하",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    "품질 : ${modifiedItem.itemQuality == ItemQuality.HIGH ? "상" : modifiedItem.itemQuality == ItemQuality.MID ? "중" : "하"}",
                    style: const TextStyle(fontFamily: 'KBO-B', fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          //가격
          Flexible(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  alignment: Alignment.center,
                  width: 350.0,
                  height: 80.0,
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            temp = text;
                            if (temp != "") {
                              modifiedItem.sellingPrice = int.parse(
                                  temp.replaceAll('￦', '').replaceAll(',', ''));
                            } else {
                              modifiedItem.sellingPrice = -1;
                            }
                          });
                        },
                        initialValue: "￦${f.format(modifiedItem.sellingPrice)}",
                        maxLength: 12,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          CurrencyTextInputFormatter(
                            locale: 'ko',
                            decimalDigits: 0,
                            symbol: '￦',
                          ),
                        ],
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '가격(원)',
                          hintStyle: TextStyle(
                            color: Colors.grey[600], // labelText의 텍스트 색상
                            fontSize: 18.0, // labelText의 텍스트 크기 -> 이것
                            fontFamily: 'KBO-L', // 알아서 변경할 것!!
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 활성 상태일 때 밑줄 색상
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 포커스 상태일 때 밑줄 색상
                          ),
                        ),
                      )
                    ],
                  ))
            ]),
          ),
          const SizedBox(height: 10),
          //내용
          Flexible(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  alignment: Alignment.center,
                  width: 350.0,
                  height: 200.0,
                  // 이렇게만 해도 여백이 생겨버리네 (textField라는게 부모 높이 따라가는듯)
                  padding: EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            modifiedItem.itemDetail = text;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        initialValue: modifiedItem.itemDetail,
                        decoration: InputDecoration(
                          hintText: '추가로 알리고 싶은 내용을 적어주세요.',
                          hintStyle: TextStyle(
                            color: Colors.grey[600], // labelText의 텍스트 색상
                            fontSize: 18.0, // labelText의 텍스트 크기 -> 이것
                            fontFamily: 'KBO-L', // 알아서 변경할 것!!
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 활성 상태일 때 밑줄 색상
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFB70001),
                                width: 5), // 포커스 상태일 때 밑줄 색상
                          ),
                        ),
                      )
                    ],
                  ))
            ]),
          ),
        ],
      ),
    );
  }

  Widget LoadImageButton() {
    return modifiedItem.imageListB.isEmpty & modifiedItem.imageListA.isEmpty
        ? PlusMaterialButton()
        : Flexible(
            child: SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    PlusMaterialButton(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: modifiedItem.imageListA!.length +
                            modifiedItem.imageListB!.length,
                        itemBuilder: (BuildContext context, int index) {
                          int countA = modifiedItem.imageListA.length;
                          int countB = modifiedItem.imageListB.length;
                          int allCount = countA + countB;
                          debugPrint("총 list수 ${allCount.toString()}");

                          return Row(
                            children: [
                              Stack(
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        //편집 기능
                                      });
                                    },
                                    child:
                                        differentImage(countA, countB, index),
                                  ),
                                  Positioned(
                                    right: -20,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        if (index >= countB) {
                                          setState(() {
                                            modifiedItem.imageListA!
                                                .removeAt(index - countB);
                                          });
                                        } else {
                                          removeUrlImage(modifiedItem,
                                              modifiedItem.imageListB[index]);
                                          setState(() {
                                            modifiedItem.imageListB!
                                                .removeAt(index);
                                          });
                                        }
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
                )),
          );
  }

  void _popUp(String text, BuildContext context) {
    utilUsecase.popUp(text, context);
  }

  Future<bool> removeUrlImage(Item item, String imageUrl) async {
    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

    Dio dio = Dio();
    print('add Item To Server');
    dio.options.headers['Authorization'] = 'Bearer $token';
    String url =
        'http://kdh.supomarket.com/items/myItems/patch/image/${item.itemID}';

    var data = {"image": imageUrl};

    try {
      Response response = await dio.patch(url, data: data);
      print(response);
    } catch (e) {
      print('Error sending POST request : $e');
    }

    return true;
  }

  Widget differentImage(int countA, int countB, int index) {
    if (index < countB) {
      return Image.network(modifiedItem.imageListB![index],
          width: 100, height: 100, fit: BoxFit.fitHeight);
    } else {
      debugPrint("여기 옴?");
      return Image.file(File(modifiedItem.imageListA[index - countB].path),
          width: 100, height: 100, fit: BoxFit.fitHeight);
    }
  }

  Widget CameraGalleryButton(String text, Icon icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            color: Colors.grey[200],
            icon: icon,
            onPressed: () {
              if (modifiedItem.imageListB.length == 5) {
                _showDialog();
              } else {
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
  XFile? _image;

  // List<XFile>? _imagelist =[];

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);

    if (pickedFile.length + modifiedItem.imageListA.length > 5) {
      _showDialog();
    } else if (pickedFile != null) {
      setState(() {
        int count = pickedFile.length;
        for (int i = 0; i < count; i++) {
          _image = XFile((pickedFile[i].path));
          File file = File(_image!.path);
          modifiedItem.imageListA.add(file);
        }
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() async {
        _image = XFile(pickedFile.path);
        File file = File(_image!.path);
        modifiedItem.imageListA.add(file);
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
          content:
              const SingleChildScrollView(child: Text("업로드 가능한 이미지 수는 5장 입니다")),
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

  Widget PlusMaterialButton() {
    return RawMaterialButton(
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: true,
          barrierColor: Colors.black.withOpacity(0.1),
          constraints: const BoxConstraints(
            //크기 설정
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
                        CameraGalleryButton(
                            "카메라 열기",
                            const Icon(
                              Icons.camera,
                              color: Colors.black45,
                            )),
                        const SizedBox(width: 30),
                        CameraGalleryButton("갤러리 열기",
                            const Icon(Icons.image, color: Colors.black45)),
                      ],
                    ),
                  ],
                ));
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
  int itemID;
  List imageListA;
  List<String> imageListB;

  ReturnData(
      {required this.sellingTitle,
      required this.imagePath,
      required this.itemType,
      required this.itemQuality,
      required this.sellingPrice,
      required this.itemDetail,
      required this.returnType,
      required this.itemStatus,
      required this.itemID,
      required this.imageListA,
      required this.imageListB});
}
