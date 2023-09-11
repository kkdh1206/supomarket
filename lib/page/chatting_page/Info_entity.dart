import 'package:flutter/foundation.dart';

class Info {
  String? id;
  String? buyerID;
  String? sellerID;
  String? roomName;
  String? goodsID;

  Info(this.id, this.buyerID, this.sellerID, this.roomName, this.goodsID);
}

class userData {
  String? userID;
  String? nickname;

  userData({
    this.userID,
    this.nickname
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'nickname': nickname,
    };
  }
}

class sendData {
  String? message;
  String? myImageUrl;
  String? checkRead;

  sendData({
    this.message,
    this.myImageUrl,
    this.checkRead,
  });
  Map<String, dynamic> toJson() {
    return{
      'message': message,
      'myImageUrl': myImageUrl,
      'checkRead': checkRead,
    };
  }
}