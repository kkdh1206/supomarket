import 'package:flutter/cupertino.dart';
import 'package:supo_market/page/util_function.dart';

import 'item_entity.dart';

enum UserStatus {NORMAL, ADMIN, BANNED, DELETED}

class AUser{
  int? id; //email과 다름
  String? email;
  String? password;
  String? userName;
  String? realName;
  String? imagePath;
  String? userStudentNumber;
  int? userItemNum;
  bool? isUserLogin;
  UserStatus userStatus;
  List<dynamic>? userInterestedId;
  String? userUid;
  int? userScore;
  String? userGrade;
  List<Map<String, String>>? requestList;

  AUser
    ({
      this.id,
      required this.email,
      this.password,
      required this.userName,
      this.realName,
      required this.imagePath,
      this.userStudentNumber,
      this.userItemNum,
      required this.isUserLogin,
      required this.userStatus,
      this.userInterestedId,
      this.userUid,
      this.userScore,
      this.userGrade,
      this.requestList,
    });
}
