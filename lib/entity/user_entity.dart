enum UserStatus {NORMAL, ADMIN, BANNED}

class AUser {
  int? id; //email과 다름
  String? email;
  String? password;
  String? userName;
  String? imagePath;
  String? userStudentNumber;
  int? userItemNum;
  bool? isUserLogin;
  UserStatus userStatus;
  List<dynamic>? userInterestedId;
  String? userUid;

  AUser
    ({
      this.id,
      required this.email,
      this.password,
      required this.userName,
      required this.imagePath,
      this.userStudentNumber,
      this.userItemNum,
      required this.isUserLogin,
      required this.userStatus,
      this.userInterestedId,
      this.userUid,
    });

}
