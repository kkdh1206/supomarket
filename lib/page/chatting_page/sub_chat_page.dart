import 'dart:convert';

// import 'package:chatting_app/chatting/chat/RoomInfo.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';

import '../../infra/my_info_data.dart';
import '../../retrofit/RestClient.dart';
import '../util_function.dart';
import '../welcome_page.dart';
import 'Info_entity.dart';
import 'chat_bubble_entity.dart';

class MessageEntity {
  String? message;
  String? nickname;
}

class SubChattingPage extends StatefulWidget {
  const SubChattingPage({Key? key, required this.roomID}) : super(key: key);
  final String? roomID;

  @override
  State<SubChattingPage> createState() => _SubChattingPageState();
}

class _SubChattingPageState extends State<SubChattingPage> {


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
  List<dynamic> pastMsg = [];
  final myMessage = {'nickname': '', 'message': ''};
  userData userdata =
      userData(userID: myUserInfo.userUid, nickname: myUserInfo.userName);
  Time? time;
  bool? isUserMessage;
  String? image = myUserInfo.imagePath;
  ScrollController _scrollController = ScrollController();
  String? checkRead;
  String? sendName;
  String? sendToken;

  @override
  void initState() {
    super.initState();
    subChattingPageBuilder = getData();
    Dio dio = Dio();
    client = RestClient(dio);
    socketInit();
    enterChatRoom();
    getMessage();
    fcmToken;
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
    final token = Token(buyerToken: response?.buyerToken, sellerToken: response?.sellerToken);
    if(token.buyerToken != fcmToken) {
      sendToken = token.buyerToken;
    }
    else if(token.sellerToken != fcmToken) {
      sendToken = token.sellerToken;
    }
    print("sendToken: .....$sendToken");
  }

  Future<bool> getData() async {
    // await Future.delayed(Duration(seconds: 5));
    var data = await client!.getChatById(id: widget.roomID);

    setState(() {
      pastMsg = data;
    });
    return true;
    //pastMsg = res;
  }

  readAll() {
    for (var data in pastMsg) {
      data.checkRead = "true";
    }
    setState(() {});
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

        print(nickname);
        MessageEntity m = MessageEntity();

        m.message = message;
        m.nickname = nickname;

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

        pastMsg.add(Chat(
            senderID: id,
            message: m.message!,
            senderName: m.nickname!,
            checkRead: checkRead,
            createdAt: time));

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
    sendData senddata =
        sendData(message: message, myImageUrl: myImageUrl, checkRead: 'false');
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
    await getData();
    final String? roomID = widget.roomID;
    socket!.emit('enterChatRoom', roomID);
    await getEnterSignal();
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
        // await getData();
        setState(() {});
      }
    });
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollAnimate() {
    _scrollController.animateTo(MediaQuery.of(context).viewInsets.bottom,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  // void setInitialData() {
  //   final nickname = '플러터 유저'; // 초기 설정에 사용할 닉네임 (변경 가능)
  //   socket?.emit('setInit', {'nickname': nickname});
  // }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: subChattingPageBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return WillPopScope(
                onWillPop: () async {
                  exitChatRoom();
                  socket?.disconnect();
                  Navigator.pop(context, true);
                  return true;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: false,
                        controller: _scrollController,
                        itemCount: pastMsg.length,
                        itemBuilder: (context, index) {
                          //sendName = pastMsg[index].senderName;
                          DateTime parseTime =
                              DateTime.parse(pastMsg[index].createdAt!);
                          String showTime =
                              DateFormat('HH:mm').format(parseTime);
                          if (myUserInfo.userUid == pastMsg[index].senderID) {
                            isUserMessage = true;
                          } else {
                            isUserMessage = false;
                          }
                          if (pastMsg[index].senderID != myUserInfo.userUid &&
                              pastMsg[index].checkRead == 'false') {
                            pastMsg[index].checkRead = true.toString();
                            final check = Check(
                              checkRead: 'true',
                            );
                            client?.updateCheck(pastMsg[index].message, check);
                          }
                          return ChatBubbless(
                            pastMsg[index].message!,
                            isUserMessage!,
                            image,
                            pastMsg[index].senderName!,
                            showTime,
                            pastMsg[index].checkRead!,
                          );
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              // onTap: () {
                              //   scrollAnimate();
                              // },
                              maxLines: null,
                              controller: _controller,
                              decoration:
                                  InputDecoration(labelText: 'Send a message'),
                              onChanged: (value) {
                                _userEnterMessage = value;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_userEnterMessage.isNotEmpty) {
                                _controller.clear();
                              }
                              sendMessage(_userEnterMessage, image!, sendName!);
                              scrollToBottom();
                              // pastMsg.add(Records(message: myMessage['message'], userName: myMessage['nickname']));
                              // setState(() {
                              //
                              // });
                            },
                            icon: Icon(Icons.send),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Column(
                children: [
                  Row(
                    children: [],
                  )
                ],
              );
            }
            ;
          }),
    );
  }
}
