import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

class ChatBubbless_old extends StatefulWidget {
  String text;
  bool isUserMessage;
  String? userImage;
  String? username;
  String currentTime;
  String checkRead;

  ChatBubbless_old(this.text, this.isUserMessage, this.userImage, this.username,
      this.currentTime, this.checkRead, {Key? key});

  @override
  State<StatefulWidget> createState() {
    return ChatBubblessState();
  }

}

class ChatBubblessState extends State<ChatBubbless_old>{

  String? checkRead;
  String? text;
  bool? isUserMessage;
  String? userImage;
  String? username;
  String? currentTime;

  @override
  void initState() {
    checkRead = widget.checkRead;
    text = widget.text;
    isUserMessage = widget.isUserMessage;
    userImage = widget.userImage;
    username = widget.username;
    currentTime = widget.currentTime;
    print("initState ChatBubble");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatBubbless_old oldWidget) {
    checkRead = widget.checkRead;
    text = widget.text;
    isUserMessage = widget.isUserMessage;
    userImage = widget.userImage;
    username = widget.username;
    currentTime = widget.currentTime;
    print("did Update Widget : $text + $checkRead");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("전달된 값은: $checkRead");
    print("전달된 메시지는: $text");
    return Stack(children: [
      Row(
      mainAxisAlignment: isUserMessage! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if(isUserMessage!)
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment:isUserMessage!
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   username,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, color: Colors.white),
                    // ),
                    Text(
                      text!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Container(
        //   padding: const EdgeInsets.only(top: 50, left: 8, right: 6),
        //   child: Text(
        //     currentTime,
        //     style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 10),
        //   ),
        // ),
        if(!isUserMessage!)
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 10, 0, 0),
            child: ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.black,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment:isUserMessage!
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   username,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, color: Colors.white),
                    // ),
                    Text(
                      text!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
          child: Text(
            currentTime!,
            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    ),
      if(!isUserMessage!)
        Positioned(
          top: 0,
          right: isUserMessage! ? 5 : null,
          left: isUserMessage! ? null : 5,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage ?? ""),
          ),
        ),
      if(!isUserMessage!)
        Positioned(
          top: 5,
          right: isUserMessage! ? 10 : null,
          left: isUserMessage! ? null : 50,
          child: Row(
            children: [
              Text(
                username!,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
              ),
              if(!isUserMessage! && checkRead == 'false')
                Icon(
                  Icons.music_note,
                  color: Colors.black,
                ),
            ],
          ),
        ),
      if(isUserMessage!)
        Positioned(
          top: 5,
          right: isUserMessage! ? null : 10,
          left: isUserMessage! ? 300 : null,
          child: Row(
            children: [
              if(isUserMessage! && checkRead == 'false')
                Icon(
                  Icons.music_note,
                  color: Colors.black,
                ),
            ],
          ),
        ),
    ]);
  }
}