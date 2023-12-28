import 'dart:io';
import 'dart:async';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supo_market/entity/util_entity.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/infra/users_info_data.dart';
import 'package:supo_market/page/util_function.dart';
import 'package:supo_market/page/entity/util_entity.dart';
import '../entity/item_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

String temp = "";
Map<String, int> myData = Map();

class SubAddItemPage extends StatefulWidget {
  final List<Item> list;

  const SubAddItemPage({Key? key, required this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubAddItemPageState();
  }
}

class _SubAddItemPageState extends State<SubAddItemPage> {
  List<Item>? list;
  bool isFastSellForToggle = false;
  FixedExtentScrollController? firstController;
  FixedExtentScrollController? secondController;
  Item newItem = Item(
    sellingTitle: "",
    itemType: ItemType.REFRIGERATOR,
    itemQuality: ItemQuality.HIGH,
    sellerName: "",
    sellingPrice: -1,
    uploadDate: "",
    sellerImage: myUserInfo.imagePath,
    isLiked: false,
    uploadDateForCompare: DateTime.now(),
    sellerSchoolNum: '20000000',
    imageListA: [],
    imageListB: [],
    itemStatus: ItemStatus.TRADING,
    itemID: 4,
  );

  final CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter();
  final picker = ImagePicker();
  XFile? _image;

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);

    if (pickedFile.length + newItem.imageListA.length > 5) {
      _showDialog();
    } else if (pickedFile != null) {
      setState(() {
        int count = pickedFile.length;
        for (int i = 0; i < count; i++) {
          _image = XFile((pickedFile[i].path));
          File file = File(_image!.path);
          // FormData formdata =  FormData.fromMap({
          // 'image': await MultipartFile.fromFile(file.path, filename: 'image.jpg'),});
          newItem.imageListA.add(file);
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
        // FormData formdata =  FormData.fromMap({
        //   'image': await MultipartFile.fromFile(file.path, filename: 'image.jpg'),});
        newItem.imageListA.add(file);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // newItem.imageList[0].path = "assets/images/main_logo.jpg";
    newItem.sellerImage = myUserInfo!.imagePath!;
    newItem.sellerImage = myUserInfo!.userName!;
    firstController = FixedExtentScrollController(initialItem: 0);
    secondController = FixedExtentScrollController(initialItem: 0);
    list = widget.list;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("add page dispose");
  }

  bool completed = true; // --> 이런식으로 외부에 선언해야 초기화 안되고 막음
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Completer<bool> doubleRequest = Completer<bool>();
    // doubleRequest.complete(false);
    // print("~~~~~~~~~");
    // print(doubleRequest.isCompleted);
    // bool completed = true;  ---> 이딴식으로 함수안에 선언 하면 누를때마다 새로 초기화 되서 다 뚫림
    final _lock = Lock();

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
                  Navigator.pop(
                      context, ReturnData(item: newItem, returnType: "exit"));
                },
                icon: const Icon(Icons.clear, color: Colors.black),
                iconSize: 30)),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(!completed) {
                print("업로드 중입니다!!!!");
                // print(doubleRequest.isCompleted);
                popUp("업로드 중입니다");
                return;
              }else{
                try{
                  //print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
                  if (newItem.sellingTitle!.length < 5) {
                    popUp("판매 제목은 5글자 이상이어야 합니다");
                  } else if (newItem.imageListA.isEmpty) {
                    popUp("최소 하나의 사진을 첨부 해야 합니다");
                  } else if (newItem.sellingPrice.isNegative ||
                      newItem.sellingPrice.isNaN) {
                    popUp("가격을 제시해 주세요");
                  } else if (newItem.itemDetail == null ||
                      newItem.itemDetail!.length < 10) {
                    popUp("세부 내용을 10글자 이상 작성해 주세요");
                  } else {
                    setState(() {
                      isLoading = true;
                      completed = false;
                    });

                    setState(() {
                      newItem.uploadDate = "방금 전";
                      newItem.uploadDateForCompare = DateTime.now();
                    });


                    //--도형 코드---
                    print("전송전");
                    String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

                    Dio dio = Dio();
                    print('add Item To Server');
                    dio.options.headers['Authorization'] = 'Bearer $token';
                    String url = 'https://kdh.supomarket.com/items';

                    print("itemQauilty : ${newItem.itemQuality}");
                    FormData formData = FormData.fromMap({
                      'title': newItem.sellingTitle ?? "무제",
                      'description': newItem.itemDetail ?? "",
                      'price': newItem.sellingPrice ?? -1,
                      'category': ConvertEnumToString(newItem.itemType) ?? ItemType.ETC,
                      'status': ConvertEnumToString(newItem.itemStatus) ?? ItemStatus.TRADING,
                      'quality': ConvertEnumToString(newItem.itemQuality) ?? ItemQuality.MID,
                    });
                    for (int i = 0; i < newItem.imageListA.length; i++) {
                      formData.files.add(MapEntry(
                          'image',
                          await MultipartFile.fromFile(newItem.imageListA[i].path,
                              filename: 'image.jpg')));
                    }

                    print(formData);
                    try {
                      Response response = await dio.post(url, data: formData);
                      print(response);
                      print("전송완료");
                      //doubleRequest.complete(true);

                    } catch (e) {
                      print('Error sending POST request : $e');
                    }
                    //--도형 코드---
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(
                        context, ReturnData(item: newItem, returnType: "add"));

                  }
                }finally {
                  completed = true;
                }
              }
              
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: const Text(
              "등록하기",
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
      body: Stack(
        children: [
          Column(
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
                          TextField(
                            onChanged: (text) {
                              setState(() {
                                newItem.sellingTitle = text;
                              });
                            },
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
              const SizedBox(height: 5),

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
                                                newItem.itemType =
                                                    ItemType.REFRIGERATOR;
                                              case (1):
                                                newItem.itemType = ItemType.CLOTHES;
                                              case (2):
                                                newItem.itemType = ItemType.ROOM;
                                              case (3):
                                                newItem.itemType = ItemType.MONITOR;
                                              case (4):
                                                newItem.itemType = ItemType.BOOK;
                                              case (5):
                                                newItem.itemType = ItemType.ETC;
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
                        "상품 종류 : ${newItem.itemType == ItemType.REFRIGERATOR ? "냉장고" : newItem.itemType == ItemType.MONITOR ? "모니터" : newItem.itemType == ItemType.BOOK ? "책" : newItem.itemType == ItemType.ROOM ? "자취방" : newItem.itemType == ItemType.CLOTHES ? "의류" : "기타"}",
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
                                                newItem.itemQuality =
                                                    ItemQuality.HIGH;
                                              case (1):
                                                newItem.itemQuality =
                                                    ItemQuality.MID;
                                              case (2):
                                                newItem.itemQuality =
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
                        "품질 : ${newItem.itemQuality == ItemQuality.HIGH ? "상" : newItem.itemQuality == ItemQuality.MID ? "중" : "하"}",
                        style: const TextStyle(fontFamily: 'KBO-B', fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              //급처분 버튼
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Text("급처분 : ",
                      style: TextStyle(fontFamily: 'KBO-B', fontSize: 18)),
                  CupertinoSwitch(
                    // 급처분 여부
                    value: isFastSellForToggle,
                    activeColor: mainColor,
                    onChanged: (bool? value) {
                      // 스위치가 토글될 때 실행될 코드
                      setState(() {
                        newItem.itemStatus = (value == true
                            ? ItemStatus.USERFASTSELL
                            : ItemStatus.TRADING);
                        isFastSellForToggle = value ?? false;
                      });
                    },
                  ),
                ],
              ),

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
                            maxLength: 12,
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              setState(() {
                                temp = text;
                                if (temp != "") {
                                  newItem.sellingPrice = int.parse(
                                      temp.replaceAll('￦', '').replaceAll(',', ''));
                                } else {
                                  newItem.sellingPrice = -1;
                                }
                              });
                            },
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
                          TextField(
                            onChanged: (text) {
                              setState(() {
                                newItem.itemDetail = text;
                              });
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
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
          isLoading ? Container(
            color: Colors.transparent,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: const Color(0xFFB70001),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ) : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }

  Widget LoadImageButton() {
    debugPrint(newItem.imageListA.length.toString());
    return newItem.imageListA.isEmpty
        ? PlusMaterialButton()
        : Flexible(
      child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              PlusMaterialButton(),
              const SizedBox(width: 5),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newItem.imageListA?.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                child: Image.file(
                                    File(newItem.imageListA![index].path),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fitHeight)),
                            Positioned(
                              right: -20,
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    newItem.imageListA!.removeAt(index);
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
                        const SizedBox(width: 5),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
    );
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
              if (newItem.imageListA.length == 5) {
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

  // Future<void> performDioRequest() async {
  //   String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  //
  //   Dio dio = Dio();
  //   print('add Item To Server');
  //   dio.options.headers['Authorization'] = 'Bearer $token';
  //   String url = 'https://kdh.supomarket.com/items';
  //
  //   print("itemQauilty : ${newItem.itemQuality}");
  //   FormData formData = FormData.fromMap({
  //     'title': newItem.sellingTitle ?? "무제",
  //     'description': newItem.itemDetail ?? "",
  //     'price': newItem.sellingPrice ?? -1,
  //     'category': ConvertEnumToString(newItem.itemType) ?? ItemType.ETC,
  //     'status': ConvertEnumToString(newItem.itemStatus) ?? ItemStatus.TRADING,
  //     'quality': ConvertEnumToString(newItem.itemQuality) ?? ItemQuality.MID,
  //   });
  //   for (int i = 0; i < newItem.imageListA.length; i++) {
  //     formData.files.add(MapEntry(
  //         'image',
  //         await MultipartFile.fromFile(newItem.imageListA[i].path,
  //             filename: 'image.jpg')));
  //   }
  //
  //   print(formData);
  //   try {
  //     Response response = await dio.post(url, data: formData);
  //     print(response);
  //   } catch (e) {
  //     print('Error sending POST request : $e');
  //   }
  // }

  void popUp(String value) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(child: Text(value)),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
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
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }

  void updateList() {
    debugPrint("update List");
    setState(() {
      homePageBuilder = getItem(1, SortType.DATEASCEND, ItemStatus.TRADING);
    });
  }
}

class ReturnData {
  Item item;
  String returnType;

  ReturnData({required this.item, required this.returnType});
}