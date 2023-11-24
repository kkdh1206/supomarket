import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:supo_market/page/chatting_page/widgets/chatting_page_widgets.dart';

class ChatBubbless extends StatefulWidget {
  String text;
  bool isUserMessage;
  String? userImage;
  String? username;
  String currentTime;
  String checkRead;
  String imageUrl;

  ChatBubbless(this.text, this.isUserMessage, this.userImage, this.username,
      this.currentTime, this.checkRead, this.imageUrl,
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
  String? imageUrl;

  @override
  void initState() {
    checkRead = widget.checkRead;
    text = widget.text;
    isUserMessage = widget.isUserMessage;
    userImage = widget.userImage;
    username = widget.username;
    currentTime = widget.currentTime;
    imageUrl = widget.imageUrl;
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
          //내가 보낸 메세지
          if (isUserMessage! && imageUrl == "k")
            Row(
              children: [
                //내 현재 시간
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isUserMessage! && checkRead == 'false')
                      Icon(
                        Icons.music_note,
                        color: Colors.grey[400],
                        size: 17,
                      ),
                    //내 현재 시간
                    Container(
                      padding:
                          const EdgeInsets.only(top: 0, left: 0, right: 3),
                      child: Text(
                        currentTime!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),

                //내가 보낸 채팅
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 15),
                  child: ChatBubble(
                    clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                    alignment: Alignment.topRight,
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

          //내가 보낸 이미지
          if (isUserMessage! && imageUrl != "k")
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 220),
                    //내 음표
                    if (isUserMessage! && checkRead == 'false')
                      Icon(
                        Icons.music_note,
                        color: Colors.grey[400],
                        size: 17,
                      ),
                    //내 시간
                    Container(
                      padding:
                      const EdgeInsets.only(top: 3, left: 0, right: 0, bottom: 0),
                      child: Text(
                        currentTime!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),

                //내가 보낸 사진
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 15),
                  child: GestureDetector(
                    child: Container(
                      width: 150,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpandImage(imageUrl!)),
                      );
                    },
                  ),
                ),
              ],
            ),

          //상대방이 보낸 메세지
          if (!isUserMessage! && imageUrl == "k")
            //상대방 프로필
            Row(
              children: [

                //상대방 프로필 유저 이름
                Padding(
                  padding: const EdgeInsets.only(top : 10, left: 10),
                  child: Column(
                    children: [
                      Text(
                        username!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userImage ?? ""),
                        ),
                      ),
                    ],
                  ),
                ),

                //상대방이 보낸 채팅
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: ChatBubble(
                    clipper:
                        ChatBubbleClipper1(type: BubbleType.receiverBubble),
                    margin: EdgeInsets.only(top: 30),
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

                //상대방 채팅 시간
                Container(
                  padding:
                  const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
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

          //상대방이 보낸 그림
          if (!isUserMessage! && imageUrl != "k")
            Row(
              children: [
                //상대방 프로필 이름
                Padding(
                  padding: const EdgeInsets.only(top : 10, left: 10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        username!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userImage ?? ""),
                        ),
                      ),
                    ],
                  ),
                ),

                //상대방 프로필 사진
                Stack(
                  children: [
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: GestureDetector(
                          child: Container(
                            width: 150,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExpandImage(imageUrl!)),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                //상대방 그림 시간
                Container(
                  padding:
                  const EdgeInsets.only(top: 0, left: 3, right: 0, bottom: 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 240),
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
    ]);
  }
}
