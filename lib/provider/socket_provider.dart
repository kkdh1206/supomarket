import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider with ChangeNotifier{
  io.Socket? socket;
  bool isConnected = false;

  Future<void> connectSocket() async{

    print("connect");

    try{socket = io.io('http://jtaeh.supomarket.com/',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setExtraHeaders({'foo': 'bar'})
            .build()
    );

    socket?.connect();
    socket!.onConnect((_) {
      print('Socket 연결됨');
    });

    isConnected = true;

    notifyListeners();
  } catch (error) {
  print('연결 오류: $error');
  }

     await receiveUsersCount();
  }
  // 소켓 연결 메소드




  // 데이터 전송 메소드
  Future<void> receiveUsersCount () async {

    print("receive");

    try {
      //2순위
      socket?.emit('sendUsers' ,{
        socket?.on('getMessages', (data)  {
          int? userNumber = data['userNum'];
          print("!!!!" + userNumber.toString());
          print("!!!!");
        }),
      });
    } catch (error) {
      // 전송 실패 또는 예외 처리
      print('데이터 전송 오류: $error');
    }
  }

  // 소켓 연결 종료 메소드
  Future<void> disconnectSocket() async {
    try {
      // 소켓 연결 종료 로직을 여기에 구현
      // 예: _socket?.close();
      isConnected = false;
      notifyListeners();
    } catch (error) {
      // 종료 실패 또는 예외 처리
      print('소켓 종료 오류: $error');
    }
  }
}