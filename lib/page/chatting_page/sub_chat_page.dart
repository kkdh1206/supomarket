import 'dart:convert';
// import 'package:chatting_app/chatting/chat/RoomInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';

import '../../infra/my_info_data.dart';
import '../../retrofit/RestClient.dart';
import 'Info_entity.dart';
import 'chat_bubble_entity.dart';

class MessageEntity{
  String? message;
  String? nickname;
}

class SubChattingPage extends StatefulWidget {
  const SubChattingPage ({Key? key, required this.roomID}) : super(key: key);
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
  List<Chat> pastMsg = [];
  final myMessage = {
    'nickname': '',
    'message': ''
  };
  userData userdata = userData(userID: myUserInfo.userUid, nickname: myUserInfo.userName);
  Time? time;
  bool? isUserMessage;
  String? image = myUserInfo.imagePath;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();
    client = RestClient(dio);
    socketInit();
    enterChatRoom();
    getData();
    getMessage();
  }
  void socketInit() {
    print("init");
    socket = io.io('http://jtaeh.supomarket.com/',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build()
    );
    socket?.connect();

    socket!.onConnect((_) {
      print('Socket 연결됨');

    });

    String? jsonuserdata = jsonEncode(userdata);
    socket?.emit('setInited', jsonuserdata);

    socket!.onDisconnect((_) {
      print('Socket 해제됨');
    });
  }
  void getData() async {
    print(widget.roomID! + "!!!!");
    var res = await client!.getChatById(id: widget.roomID);
    setState(() {
      pastMsg = res;
    });
  }
  void getMessage() {
    socket!.on('getMessages', (data) {

      try {
        String id = data['id'];
        String? nickname = data['nickname'];
        String message = data['message'];
        String? time = data['time'];

        print(nickname);
        MessageEntity m = MessageEntity();

        m.message = message;
        m.nickname = nickname;

        pastMsg.add(Chat(message: m.message!, senderName: m.nickname!, createdAt: time));

        setState(() {
          // myMessage['message'] = m.message!;
          // myMessage['nickname'] = m.nickname!;
        });
      } catch (e) {
        print('Error during data processing: $e');
      }
    });
  }
  void sendMessage(String message) {
    if(socket!.connected) {
      socket!.emit('sendMessage', message);
    }
    else {
      print('연결이 필요합니다.');
    }
  }
  void enterChatRoom() {
    final String? roomID = widget.roomID;
    socket!.emit('enterChatRoom', roomID);
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
      body: WillPopScope(
        onWillPop: () async {
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
                  DateTime parseTime = DateTime.parse(pastMsg[index].createdAt!);
                  String showTime = DateFormat('HH:mm').format(parseTime);
                  if(myUserInfo.userName == pastMsg[index].senderName) {
                    isUserMessage = true;
                  }
                  else {
                    isUserMessage = false;
                  }
                  return ChatBubbless(
                    pastMsg[index].message!,
                    isUserMessage!,
                    image,
                    pastMsg[index].senderName!,
                    showTime,
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
                      decoration: InputDecoration(labelText: 'Send a message'),
                      onChanged: (value) {
                        setState(() {
                          _userEnterMessage = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_userEnterMessage.isNotEmpty) {
                        _controller.clear();
                      }
                      sendMessage(_userEnterMessage);
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
      ),
    );
  }
}