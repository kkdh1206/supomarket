class User {
  String? userName;
  String? userState;
  String? imagePath;
  String? userSchoolNum;
  int? userGoodsNum;

  User
    ({
      required this.userName,
      required this.userState,
      required this.imagePath,
      this.userSchoolNum,
      required this.userGoodsNum,
    });

}