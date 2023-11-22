import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:supo_market/infra/item_list_data.dart';
import 'package:supo_market/page/chatting_page/sub_chat_page.dart';
import 'package:supo_market/page/chatting_page/sub_chatting_page_chatbot_page.dart';
import 'package:supo_market/page/chatting_page/widgets/chatting_page_widgets.dart';
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

class ChattingPageState extends State<ChattingPage> {
  RestClient? client;
  List<Room> roomList = [];
  String? InputRoomName;
  String? EnterText;
  List<ChatRoom> list = [];

  @override
  void initState() {
    super.initState();
    myUserInfo.userUid;
    list.add(ChatRoom(
        traderName: "이지현",
        traderImage: "",
        itemName: "임시 채팅방",
        sellingTitle: ""));
    Dio dio = Dio();
    client = RestClient(dio);
    roomList.clear();
    getChatRoomId(myUserInfo.userUid!);
    print("userUid" + myUserInfo.userUid!);
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
        roomName: roomData.roomName));

    setState(() {});
  }

  void getChatRoomId(String uid) async {
    var res = await client!.getRoomById(id: uid);
    print("유저 아이디는: ${uid}");
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
                  itemCount: roomList.length + 1,
                  itemBuilder: (context, position) {
                    //context는 위젯 트리에서 위젯의 위치를 알림, position(int)는 아이템의 순번
                    return GestureDetector(
                      onTap: () {
                        if (position == roomList.length) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubChattingPageChatbotPage(),
                              ));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubChattingPage(
                                        roomID: roomList[position].id,
                                        traderName: roomList[position].roomName,
                                      ))).then((value) {
                            getChatRoomId(myUserInfo.userUid!);
                          });
                      },
                      child: Stack(
                        children: [
                          Card(
                            elevation: 0,
                            margin: EdgeInsets.only(
                                top: 5, bottom: 5, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 7, bottom: 7, left: 7, right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: position == roomList.length
                                        ? Image.asset("assets/images/supi_logo.jpeg",
                                            width: 65,
                                            height: 65,
                                            fit: BoxFit.contain)
                                        : Image.asset(
                                            'assets/images/icons/product.png',
                                            //Image.network(
                                            //roomList[position].sellerID..sellerImage,
                                            width: 65,
                                            height: 65,
                                            fit: BoxFit.contain),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            if (position == roomList.length)
                                              const Text(
                                                "Supi",
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            else
                                              Text(
                                                roomList[position].roomName ??
                                                    "익명",
                                                style: const TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 7),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                position == roomList.length
                                                    ? "챗봇입니다"
                                                    : roomList[position]
                                                            .resentMessage ??
                                                        "",
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    overflow:
                                                        TextOverflow.ellipsis),
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
                          Positioned(
                            right: 3,
                            top: 3,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.black45),
                              onPressed: () async {
                                popUp("정말로 삭제하시겠습니까?", position);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void popUp(String value, int position) {
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
                  onPressed: () async {
                    await client!
                        .deleteRoom(DeleteId(id: roomList[position].id));
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
                  onPressed: () async {
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
