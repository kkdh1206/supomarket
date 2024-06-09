import 'package:flutter/material.dart';
import 'package:supo_market/infra/my_info_data.dart';
import 'package:supo_market/page/my_page/sub_selling_page_evaluation_page.dart';

import '../../../retrofit/RestClient.dart';
import '../../control_page.dart';
import '../../home_page/home_page.dart';
import '../../my_page/sub_selling_page_selection_page.dart';

PopUpUseCase popUpUseCase = PopUpUseCase();

class PopUpUseCase {
  void bannedUserPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              const SingleChildScrollView(child: Text("해당 유저는 접속할 수 없습니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
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

  void notUserPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("유저 정보가 없습니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
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

  void wrongInfoPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("아이디 또는 비밀번호가\n 올바르지 않습니다.")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
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

  void wrongPasswordPopUp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("올바른 정보가 아닙니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
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

  void isSoldOutPopUp(BuildContext context, int? chatRoomNum, String itemId, List<String> nameList, List<String> userUidList) {

    print("isSoldOutPopUp : ${nameList.toString()}");
    showDialog(
      context: context,
      barrierDismissible: false, //여백을 눌러도 닫히지 않음
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(child: Text("판매 완료 상태로 전환합니다")),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text("예"),
                  onPressed: () {
                    if (nameList.isEmpty) {
                      Navigator.popUntil(context, ModalRoute.withName("control"));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ControlPage()));
                    } else {
                      Navigator.popUntil(context, ModalRoute.withName("control"));
                      Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (context, animation,
                              secondaryAnimation) {
                            //여기서 상대방 ID 줘야함 ㅁㄴㅇㄹ
                            // nameList = ['김도형'];
                            // userUidList = ['asdfafafsf'];
                            // itemId = '9';
                            return SubSellingPageSelectionPage(
                              nameList: nameList, userUidList: userUidList, itemId: itemId); // 화면을 반환하는 부분
                          }));
                    }
                  }
                ),
                TextButton(
                  child: const Text("아니오"),
                  onPressed: () {
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
