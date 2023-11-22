import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChattingRooms extends StatelessWidget {
  const ChattingRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, left: 7, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset("assets/images/icons/product.png",
                        width: 65, height: 65, fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "김포닉스",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                "방금 전",
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "안녕하세요",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbless extends StatefulWidget {
  String text;
  bool isUserMessage;
  String? userImage;
  String? username;
  String currentTime;
  String checkRead;

  ChatBubbless(this.text, this.isUserMessage, this.userImage, this.username,
      this.currentTime, this.checkRead,
      {Key? key});

  @override
  State<StatefulWidget> createState() {
    return ChatBubblessState();
  }
}

class ChatBubblessState extends State<ChatBubbless> {
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
  void didUpdateWidget(covariant ChatBubbless oldWidget) {
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
        mainAxisAlignment:
            isUserMessage! ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [

          //my bubble
          if (isUserMessage!)
            Row(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top : 30,
                          right : 7,
                          child: isUserMessage! && checkRead == 'false'
                              ? Icon(
                                  Icons.music_note,
                                  color: Colors.grey[400],
                                  size: 17,
                                )
                              : const SizedBox(),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.only(top: 50, left: 8, right: 3),
                          child: Text(
                            currentTime!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 20),
                    backGroundColor: Colors.grey[400],
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: isUserMessage!
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            text!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          //trader bubble
          if (!isUserMessage!)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(45, 0, 0, 20),
                  child: ChatBubble(
                    clipper:
                        ChatBubbleClipper1(type: BubbleType.receiverBubble),
                    margin: EdgeInsets.only(top: 20, left: 25),
                    backGroundColor: Colors.grey[700],
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Column(
                        crossAxisAlignment: isUserMessage!
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
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
                  padding: const EdgeInsets.only(
                      top: 12, left: 3, right: 8, bottom: 10),
                  child: Column(
                    children: [
                      if (!isUserMessage! && checkRead == 'false')
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.music_note,
                            color: Colors.grey[700],
                            size: 17,
                          ),
                        ),
                      SizedBox(height: 3),
                      Text(
                        currentTime!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),

      //trader 사진 표시
      if (!isUserMessage!)
        Positioned(
          top: 0,
          right: isUserMessage! ? 5 : null,
          left: isUserMessage! ? null : 5,
          child: Container(
            width: 60,
            height: 60,
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage(userImage ?? ""), //나중에 이미지 url로 불러오는 걸로 바꿔야 됨
            ),
          ),
        ),

      //trader 이름 표시
      if (!isUserMessage!)
        Positioned(
          top: 0,
          right: isUserMessage! ? 10 : null,
          left: isUserMessage! ? null : 70,
          child: Row(
            children: [
              Text(
                username!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ],
          ),
        ),
    ]);
  }
}
