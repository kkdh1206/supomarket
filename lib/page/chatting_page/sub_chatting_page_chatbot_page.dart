import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class SubChattingPageChatbotPage extends StatefulWidget {
  @override
  _SubChattingPageChatbotPageState createState() =>
      _SubChattingPageChatbotPageState();
}

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.userName, {Key? key}) : super(key: key);

  final String message;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  // 채팅을 말풍선으로 감싸는 클래스
  final String text;
  final bool isUserMessage;
  final String username;
  final String userImage;

  ChatMessage(
      {required this.text,
      required this.isUserMessage,
      required this.username,
      required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isUserMessage)
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
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   username,
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, color: Colors.white),
                      // ),
                      Text(
                        text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!isUserMessage)
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
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      if (!isUserMessage)
        Positioned(
          top: 0,
          right: isUserMessage ? 5 : null,
          left: isUserMessage ? null : 5,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      if (!isUserMessage)
        Positioned(
          top: 5,
          right: isUserMessage ? 10 : null,
          left: isUserMessage ? null : 60,
          child: Text(
            username,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
        ),
    ]);
  }
}

class _SubChattingPageChatbotPageState
    extends State<SubChattingPageChatbotPage> {
  String response = "";
  String inputText = "";
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController(); // scroll하는걸 컨트롤함
  List<ChatMessage> _messages = [];
  Map<String, dynamic> chatTree = {
    // 넣어야할것 1. 기능설명 , 2. 만든 목적 , 3. 급처분 기능 설명 , 4. 기타
    "": {
      "response": "무엇을 도와드릴까요?",
      "options": ["슈포마켓?", "급처분이란?", "기타"]
    },

    "처음으로": {
      "response": "무엇을 도와드릴까요?",
      "options": ["슈포마켓?", "급처분이란?", "기타"]
    },

    "슈포마켓?": {
      "response": "저희는 포스텍 중고거래 앱입니다.",
      "options": ["앱 기능설명", "제작된 목적", "처음으로"]
    },
    "급처분이란?": {
      "response": "사용자가 물건을 빠르게 팔 수 있도록 도와주는 기능입니다.",
      "options": ["제작된 목적", "급처분 구조", "처음으로"]
    },
    "기타": {
      "response": "자세한 문의는 메일 00000@postech.ac.kr 또는 010-xxxx-xxxx으로 연락바랍니다.",
      "options": ["처음으로"]
    },
    "앱 기능설명": {
      "response": "저희 앱은 중고거래 앱입니다. 팔고싶은 물건을 올리고 사고 싶은 물건을 구매하 실 수 있습니다.",
      "options": ["처음으로"]
    },
    "제작된 목적": {
      "response":
          "포스텍에서 중고거래 플랫폼이 빈약하다 느껴서 학생들의 복지를 위해 제작 되었습니다. 또한 학교라는 특수성 때문에 방학 입학 졸업등의 이유로 중고 거래에서 수요와 공급이 변하기에 저희 앱은 급처분 기능으로 이 문제를 해결해 줍니다.",
      "options": ["급처분이란?", "처음으로"]
    },
    "제작된 이유": {
      "response":
          "대학교는 입학과 졸업이 존재합니다. 그래서 주로 입학때는 물건을 구매하고 졸업을 할때는 물건을 판매합니다. 또, 한학기만 쓰고 버리는 책, 기숙사를 퇴사하면서 생긴 가전제품등 곤란한 상황이 생깁니다. 우리는 이를 해결하고자 급처분을 만들었습니다.",
      "options": ["급처분 구조", "처음으로"]
    },
    "급처분 구조": {
      "response":
          "사용자들이 급하게 팔아야하는 물건을 저희 슈포마켓에서 구매를 합니다. 저희 슈포마켓은 이를 보관하고 있다가 추후 필요한 사람이 나타나면 물건을 제공합니다.",
      "options": ["제작된 목적", "처음으로"]
    }
  };

  void addMessage(String text, bool isUserMessage) {
    String username;
    String userImage;
    if (isUserMessage) {
      username = 'ME';
      userImage =
          'https://i.ibb.co/w6bZk45/image.jpg'; // 여기에 서버에서 받아와서 주소 넣으면 됨   -- 사실상 자기 자신이라 꺼라 안해도 될듯 ㅋㅋ
    } else {
      username = '슈피';
      userImage = 'https://i.ibb.co/Q6qtSKx/image.png';
    }
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: isUserMessage,
        username: username,
        userImage: userImage,
      )); // insert에 0넣으면 새메서지가 리스트 맨위에 추가됨
    });
  }

  void processUserInput(String input) {
    setState(() {
      if (chatTree.containsKey(input)) {
        response = chatTree[input]["response"];
        // If there are options, display them for the user to choose
        // if (chatTree[input]["options"].isNotEmpty) {
        //   response+= "\nOptions: ${chatTree[input]["options"].join(', ')}";
        // }
      } else {
        response = "죄송합니다 이해하지 못했어요 ㅠㅠ";
      }
      addMessage(response, false); // bot의 대답
      // inputText = "";
    });
  }

  void selectOption(String option) {
    setState(() {
      inputText = option;
    });
    processUserInput(option);
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // String input = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Supi",
            style: const TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontFamily: 'KBO-M',
                fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              reverse: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var message in _messages)
                    ChatMessage(
                        text: message.text,
                        isUserMessage: message.isUserMessage,
                        username: message.username,
                        userImage: message.userImage)
                  // Display chat history
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    controller: _textController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.7),
                      ),
                      hintText: '메시지를 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        inputText = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print(inputText);

                    if (inputText == '') {
                    } else {
                      addMessage(inputText, true);
                      scrollToBottom();
                      if (chatTree.containsKey(inputText)) {
                        print('있음');
                        processUserInput(inputText);
                        inputText = '';
                        _textController.clear();
                      } else {
                        print('없음');
                        processUserInput(inputText);
                        inputText = '';
                        _textController.clear();
                      }
                    }
                    // Process user input and update chat history
                    // Call processUserInput(inputText)
                  },
                  icon: const Icon(Icons.send, color: Colors.grey),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (chatTree.containsKey(
                    inputText)) // 이거 안쓰면 에러남  근데 신기한건 괄호 안써도 잘됨 오히려 괄호 치면 에러남
                  for (var option in chatTree[inputText]["options"])
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  addMessage(option, true);
                                  selectOption(option);
                                  scrollToBottom();
                                },
                                style: ElevatedButton.styleFrom(
                                    textStyle: TextStyle(fontSize: 11)),
                                child: Text(option))))
              ],
            ),
          )
        ],
      ),
    );
  }
}
