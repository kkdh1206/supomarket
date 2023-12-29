import 'dart:convert';
import 'dart:io';

// import 'package:chatting_app/chatting/chat/RoomInfo.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';
import 'package:supo_market/page/chatting_page/widgets/chatting_page_widgets.dart';

import '../../infra/my_info_data.dart';
import '../../retrofit/RestClient.dart';
import '../util_function.dart';
import '../welcome_page.dart';
import 'Info_entity.dart';
import 'chat_bubble_entity.dart';
import 'package:image_picker/image_picker.dart';

class MessageEntity {
  String? message;
  String? nickname;
}

class SubChattingPage extends StatefulWidget {
  const SubChattingPage(
      {Key? key,
      required this.roomID,
      this.traderName,
      this.buyerID,
      this.sellerID})
      : super(key: key);
  final String? roomID;
  final String? traderName;
  final String? buyerID;
  final String? sellerID;

  @override
  State<SubChattingPage> createState() => _SubChattingPageState();
}

class _SubChattingPageState extends State<SubChattingPage> {
  String real_traderName = "";
  io.Socket? socket;
  RestClient? client;
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  final myInfo = {
    'nickname': '',
    'id': '',
    'room': {
      'roomId': '',
      'roomName': '',
    }
  };
  List<MessageEntity> chatMessages = [];
  List<Chat> pastMsg = [];
  List<Chat> localMsg = [];
  final myMessage = {'nickname': '', 'message': ''};
  userData userdata =
      userData(userID: myUserInfo.userUid, nickname: myUserInfo.userName);
  Time? time;
  bool? isUserMessage;
  String? image;
  ScrollController _scrollController = ScrollController();
  String? checkRead;
  String? sendName;
  String? sendToken;
  List imageList = [];
  final picker = ImagePicker();
  XFile? _image;
  List<String>? imageUrlList;
  bool? isListened;
  bool? isEnded;

  //Future<bool>? subChattingPageBuilder;

  int page = 1;
  int pageSize = 10;

  Future getImage() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);

    if (pickedFile != null) {
      setState(() {
        int count = pickedFile.length;
        for (int i = 0; i < count; i++) {
          _image = XFile(pickedFile[i].path);
          File file = File(_image!.path);
          FlutterDialog();
          imageList.add(file);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("sub chat page : buyer ${widget.buyerID} seller ${widget.sellerID}");
    Dio dio = Dio();
    client = RestClient(dio);
    subChattingPageBuilder = getData(page);
    socketInit();
    enterChatRoom();
    socket?.on('enterMessage', (data) async {
      int? count = data['userNum'];
      print("지금 들어온 사람 수: $count");

      if (count == 2) {
        readAll();
        if (mounted) setState(() {});
      }
    });
    getMessage();
    fcmToken;
    isListened = false;
    isEnded = false;
    page = 1;
    pageSize = 10;
    image = myUserInfo.imagePath;
    _scrollController!.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    exitChatRoom();
  }

  void socketInit() async {
    print("init");
    socket = io.io(
        'http://jtaeh.supomarket.com/',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build());
    socket?.connect();

    socket!.onConnect((_) {
      print('Socket 연결됨');
    });

    String? jsonuserdata = jsonEncode(userdata);
    socket?.emit('setInited', jsonuserdata);

    socket!.onDisconnect((_) {
      print('Socket 해제됨');
    });

    final response = await client?.getTokenById(roomId: widget.roomID);
    final token = Token(
        buyerToken: response?.buyerToken, sellerToken: response?.sellerToken);
    if (token.buyerToken != fcmToken) {
      sendToken = token.buyerToken;
    } else if (token.sellerToken != fcmToken) {
      sendToken = token.sellerToken;
    }
    print("sendToken: .....$sendToken");
  }

  Future<bool> getData(int page) async {
    // await Future.delayed(Duration(seconds: 5));
    //Pages page = Pages(page: pageNum, pageSize: 15);

    //상대 이름 받기
    if (widget.buyerID == myUserInfo.userUid) {
      real_traderName = await getUserName(widget.sellerID!);
    } else {
      real_traderName = await getUserName(widget.buyerID!);
    }

    var data =
        await client!.getChatById(id: widget.roomID, page: page, pageSize: 15);

    setState(() {
      pastMsg = data;
    });

    for (int index = 0; index < pastMsg.length; index++) {
      localMsg.add(pastMsg[index]);
    }

    if (widget.buyerID == myUserInfo.userUid) {
      String name = await getUserName(widget.sellerID!);
      print("buyer name ${name}을 받았습니다.");
      await _getImageByID(name);
    } else {
      String name = await getUserName(widget.buyerID!);
      print("seler name ${name}을 받았습니다.");
      await _getImageByID(name);
    }

    return true;
  }

  void readAll() {
    for (var data in localMsg) {
      data.checkRead = "true";
    }
    if (mounted) {
      setState(() {});
    }
  }

  void getMessage() {
    socket!.on('getMessages', (data) {
      try {
        String id = data['id'];
        String? nickname = data['nickname'];
        String message = data['message'];
        String? check = data['checkRead'];
        int? count = data['count'];
        String? time = data['time'];
        String? recieveImg = data['imageUrl'];

        print(nickname);
        MessageEntity m = MessageEntity();

        final resent = Resent(resentMessage: message, messageTime: time);
        client?.updateResent(widget.roomID, resent);

        if (count == 2) {
          checkRead = true.toString();
          final check = Check(
            checkRead: true.toString(),
          );
          client?.updateCheck(message, check);
        } else if (count != 2) {
          checkRead = check;
        } else {
          checkRead = check;
        }
        localMsg = localMsg.reversed.toList();
        localMsg.add(Chat(
            senderID: id,
            message: message!,
            senderName: nickname!,
            checkRead: checkRead,
            createdAt: time,
            imageUrl: recieveImg));
        localMsg = localMsg.reversed.toList();

        if (mounted)
          setState(() {
            // myMessage['message'] = m.message!;
            // myMessage['nickname'] = m.nickname!;
          });
      } catch (e) {
        print('Error during data processing: $e');
      }
    });
  }

  void sendMessage(String message, String myImageUrl, String sendName) async {
    sendData senddata = sendData(
        message: message,
        myImageUrl: myImageUrl,
        checkRead: 'false',
        imageUrl: "NoImage");
    String? changeData = jsonEncode(senddata);
    print('입력받은 데이터ㅋㅋㅋㅋㅋㅋㅋㅋㅋ: $sendName');
    print('입력받은 데이터ㅋㅋㅋㅋㅋㅋㅋㅋㅋ: $fcmToken');
    print('입력받은 데이터ㅋㅋㅋㅋㅋㅋㅋㅋㅋ: $message');
    print('입력받은 데이터ㅋㅋㅋㅋㅋㅋㅋㅋㅋ: ${widget.roomID}');
    final notification = Notificate(
      token: sendToken,
      title: sendName,
      sentence: message,
      roomId: widget.roomID,
    );
    if (socket!.connected) {
      socket!.emit('sendMessage', changeData);
      await client?.postNotification(notification);
    } else {
      print('연결이 필요합니다.');
    }
  }

  void enterChatRoom() async {
    sendName = myUserInfo.userName;
    print("누군가 들어옴");
    final String? roomID = widget.roomID;
    socket!.emit('enterChatRoom', roomID);
    await getEnterSignal();
    localMsg.clear();
  }

  void exitChatRoom() {
    print("한명 나감");
    var roomId = widget.roomID;
    final String? roomID = roomId;
    socket!.emit('exitChatRoom', roomID);
  }

  Future<void> getEnterSignal() async {
    print("enter somebody");

    socket?.on('enterMessage', (data) async {
      int? count = data['userNum'];
      print("지금 들어온 사람 수: $count");

      if (count == 2) {
        readAll();
        if (mounted) setState(() {});
      }
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollAnimate() {
    _scrollController.animateTo(MediaQuery.of(context).viewInsets.bottom,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  void scrollListener() {
    if (_scrollController!.offset + 500 >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange &&
        !isListened!) {
      page++;
      isListened = true;
      updateList();
    }
  }

  void updateList() async {
    await getData(page);
    isListened = false;
  }

  // void setInitialData() {
  //   final nickname = '플러터 유저'; // 초기 설정에 사용할 닉네임 (변경 가능)
  //   socket?.emit('setInit', {'nickname': nickname});
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: FutureBuilder(
          future: subChattingPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WillPopScope(
                onWillPop: () async {
                  //exitChatRoom();
                  socket?.disconnect();
                  Navigator.pop(context, true);
                  return true;
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            controller: _scrollController,
                            itemCount: localMsg.length,
                            itemBuilder: (context, index) {
                              // if(index == localMsg.length){
                              //   print("scroll To bottom");
                              //   WidgetsBinding.instance?.addPostFrameCallback((_) {
                              //     //scrollToBottom();
                              //   });
                              //   return const SizedBox();
                              // }

                              //sendName = pastMsg[index].senderName;
                              DateTime parseTime = DateTime.parse(localMsg[index].createdAt!);
                              String showTime =
                                  DateFormat('HH:mm').format(parseTime);
                              if (myUserInfo.userUid ==
                                  localMsg[index].senderID) {
                                isUserMessage = true;
                              } else {
                                isUserMessage = false;
                              }
                              if (localMsg[index].senderID !=
                                      myUserInfo.userUid &&
                                  localMsg[index].checkRead == 'false') {
                                localMsg[index].checkRead = true.toString();
                                final check = Check(
                                  checkRead: 'true',
                                );
                                client?.updateCheck(
                                    pastMsg[index].message, check);
                              }
                              return ChatBubbless(
                                localMsg[index].message!,
                                isUserMessage!,
                                image,
                                localMsg[index].senderName!,
                                showTime,
                                localMsg[index].checkRead!,
                                localMsg[index].imageUrl!,
                              );
                            },
                          ),
                        ),
                        Container(
                          color : Colors.black,
                          margin: EdgeInsets.only(top: 0),
                          padding: EdgeInsets.all(8),
                          child: SafeArea(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        enableDrag: true,
                                        isDismissible: true,
                                        barrierColor:
                                            Colors.black.withOpacity(0.1),
                                        constraints: const BoxConstraints(
                                            minHeight: 100,
                                            maxHeight: 150,
                                            minWidth: 500,
                                            maxWidth: 500),
                                        builder: (BuildContext context) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CameraGalleryButton(
                                                    "갤러리 열기",
                                                    const Icon(
                                                      Icons.image,
                                                      color: Colors.black45,
                                                    )),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.add_circle_outline,
                                      color: Colors.black.withOpacity(0.7),
                                      size: 30),
                                  color: Colors.blue,
                                ),
                                //ExpandImage(""),
                                Expanded(
                                  child: TextField(
                                    maxLines: null,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.grey.withOpacity(0.3),
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0,
                                          bottom: 8.0,
                                          top: 8.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                      hintText: '메시지를 입력하세요',
                                      hintStyle:
                                          TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) {
                                      _userEnterMessage = value;
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (_userEnterMessage.isNotEmpty) {
                                      _controller.clear();
                                    }

                                    sendMessage(_userEnterMessage, image!,
                                        sendName!);
                                    scrollToBottom();
                                  },
                                  icon: const Icon(Icons.send,
                                      color: Colors.grey),
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top : 55,
                      left : 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 60,
                      left : 10,
                      right : 10,
                      child: Container(
                        //color : Colors.black,
                        width : MediaQuery.of(context).size.width * 0.8,
                        child: Align(
                          alignment : Alignment.center,
                          child: Text(real_traderName,
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.black,
                                  fontFamily: 'KBO-M',
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child : CircularProgressIndicator(),
              );
            }
          }),
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
              getImage();
            },
          ),
        ),
        Text(text),
      ],
    );
  }

  void FlutterDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("이미지 전송"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "선택한 이미지를 전송하시겠습니까?",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  imageList.clear();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: new Text("확인"),
                onPressed: () async {
                  Images? images;
                  FormData formData = FormData.fromMap({});
                  for (int i = 0; i < imageList.length; i++) {
                    formData.files.add(MapEntry(
                        'image',
                        await MultipartFile.fromFile(imageList[i].path,
                            filename: 'image.jpg')));
                  }
                  try {
                    Dio dio = Dio();
                    await dio.post(
                        'http://jtaeh.supomarket.com/boards/images/${widget.roomID}',
                        data: formData);
                  } catch (e) {
                    print('Error sending Post request : $e');
                  }
                  print("전송하는 방의 아이디는::::::::::::");
                  print(widget.roomID);
                  var res = await client?.getImage(roomId: widget.roomID);
                  setState(() {
                    images = res;
                  });
                  imageUrlList = images?.imageUrl;
                  for (String imgUrl in imageUrlList!) {
                    print("받은 이미지의 유알앨은 ???????");
                    sendData send = sendData(
                        message: "이미지를 보냈습니다.",
                        myImageUrl: myUserInfo.imagePath,
                        checkRead: 'false',
                        imageUrl: imgUrl);
                    String? changeData = jsonEncode(send);
                    if (socket!.connected) {
                      socket!.emit('sendMessage', changeData);
                    }
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<bool> _getImageByID(String userName) async {
    print(userName);
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain; // responseType 설정
    String url = 'https://kdh.supomarket.com/auth/userToImage';

    Map<String, String> data = {'username': userName};

    try {
      Response response = await dio.get(url, data: data);
      dynamic jsonData = response.data;
      String result = jsonData as String;
      image = result;

      print("image ${result}을 받았습니다");
    } catch (e) {
      print('Error sending GET request : $e');
    }

    return true;
  }
}
