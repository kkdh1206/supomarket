class User {
  String? userName;
  String? userState;
  String? imagePath;
  String? userSchoolNum;

  User
    ({
      required this.userName,
      required this.userState,
      required this.imagePath,
      this.userSchoolNum
    });

}