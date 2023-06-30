import 'package:flutter/material.dart';
import '../entity/chat_room_entity.dart';

Color postechRed = Color(0xffac145a);

class SubChatPage extends StatelessWidget {

  final ChatRoom chatRoom;

  const SubChatPage({Key? key, required this.chatRoom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: postechRed),
      backgroundColor: Colors.white,
      body: Column(
      ),
    );
  }
}