class User {
  String? id;
  String? password;
  String? userName;
  String? imagePath;
  String? userSchoolNum;
  int? userGoodsNum;
  bool? isUserLogin;
  bool? isMaster;

  User
    ({
      required this.id,
      required this.password,
      required this.userName,
      required this.imagePath,
      this.userSchoolNum,
      required this.userGoodsNum,
      required this.isUserLogin,
      required this.isMaster,
    });

}