import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/infra/item_list_data.dart';
import 'package:supo_market/page/chatting_page/sub_chat_page.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';
import '../../entity/chat_room_entity.dart';
import '../../infra/my_info_data.dart';
import '../../retrofit/RestClient.dart';

class ChattingPage extends StatefulWidget {
  final List<ChatRoom>? list;

  const ChattingPage({Key? key, this.list}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChattingPageState();
  }
}

class ChattingPageState extends State<ChattingPage>{
  RestClient? client;
  List<Room> roomList = [];
  String? InputRoomName;
  String? EnterText;
  List<ChatRoom> list = [];

  @override
  void initState() {
    super.initState();
    myUserInfo.userUid;
    list.add(ChatRoom(traderName: "이지현", traderImage: "", itemName: "임시 채팅방", sellingTitle: ""));
    Dio dio = Dio();
    client = RestClient(dio);
    roomList.clear();
    getChatRoomId(myUserInfo.userUid!);
  }

  void inputInfo(String sss) async {
    final buyerID = '345601';
    final sellerID = '50508';
    final goodsID = '91751';

    final roomData = RoomData(
      buyerID: buyerID,
      sellerID: sellerID,
      goodsID: goodsID,
      id: buyerID + sellerID + goodsID,
      roomName: sss,
    );

    await client!.postRoomDetail(roomData);

    roomList.add(Room(
        id: roomData.id,
        buyerID: roomData.buyerID,
        sellerID: roomData.sellerID,
        goodsID: roomData.goodsID,
        roomName: roomData.roomName
    ));

    setState(() {

    });

  }

  void getChatRoomId(String uid) async {
    var res = await client!.getRoomById(id: uid);
    setState(() {
      roomList = res;
    });
    print(roomList.length.toString() + "!!!!!");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: [
          Container(
            child: Center(
              child: ListView.builder(
                itemCount: roomList.length,
                itemBuilder: (context, position) {
                  //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                  return GestureDetector(
                      child: Stack(
                        children: [
                          Card(
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
                                              child: Text(roomList[position].roomName??"무제", style: const TextStyle(fontSize:20),overflow: TextOverflow.ellipsis),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text("방금 전", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis,),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text("안녕하세요", style: const TextStyle(fontSize:10),overflow: TextOverflow.ellipsis),
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
                          Positioned(
                            right : 3, top : 3,
                            child: IconButton(
                              icon : const Icon(Icons.close, color: Colors.black45),
                              onPressed: () async{
                                popUp("정말로 삭제하시겠습니까?", position);
                              },
                            ),
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubChattingPage(roomID: roomList[position].id)));
                      }
                  );
                },
              ),
            ),
          ),
        ],
      )
    );
  }

  void popUp(String value, int position){
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
                  onPressed: () async{
                    await client!.deleteRoom(DeleteId(id: roomList[position].id));
                    List<Room> updatedList = List.from(roomList);
                    updatedList.removeAt(position);
                    setState(() {
                    roomList = updatedList;
                    });
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text("아니오"),
                  onPressed: () async{
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
}


