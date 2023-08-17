import 'package:flutter/material.dart';
import 'package:supo_market/page/chatting_page/sub_chat_page.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';
import '../../entity/chat_room_entity.dart';

class ChattingPage extends StatefulWidget {
  final List<ChatRoom>? list;

  const ChattingPage({Key? key, this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChattingPageState();
  }
}

class ChattingPageState extends State<ChattingPage>{

  List<ChatRoom> list = [];

  @override
  void initState() {
    super.initState();
    list.add(ChatRoom(traderName: "이지현", traderImage: "", itemName: "임시 채팅방", sellingTitle: ""));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Container(
        child: Center(
          child: ListView.builder(itemBuilder: (context, position) {
            //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
            return GestureDetector(
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(top:10, bottom:10,left:10, right:10),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              child: Image.asset("assets/images/supi_logo.jpeg", width:80, height: 80, fit: BoxFit.contain),
                            ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                                children: [
                                  Row(
                                    children: [
                                       Expanded(
                                         flex: 1,
                                         child: Text(list![position].traderName!, style: const TextStyle(fontSize:20),overflow: TextOverflow.ellipsis),
                                       ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(list![position].lastChattingDay??"방금 전", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(list![position].lastChattingSentence??"안녕하세요", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        ),
                      )
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubChatPage(chatRoom: list[position])));
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SubChattingPageChatbotPage()));
                }
            );
          },
            itemCount: list!.length, //아이템 개수만큼 스크롤 가능
          ),
        ),
       ),
    );
  }

}


