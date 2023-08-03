enum UserStatus {NORMAL, ADMIN, BANNED}

class AUser {
  String? id;
  String? password;
  String? userName;
  String? imagePath;
  String? userSchoolNum;
  int? userItemNum;
  bool? isUserLogin;
  UserStatus userStatus;

  AUser
    ({
      required this.id,
      required this.password,
      required this.userName,
      required this.imagePath,
      this.userSchoolNum,
      required this.userItemNum,
      required this.isUserLogin,
      required this.userStatus,
    });

}
