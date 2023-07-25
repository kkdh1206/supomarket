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

class AUser {
  String? email;
  String? password;
  String? userName;
  String? userSchoolNum;

  AUser({this.email, this.password, this.userName, this.userSchoolNum});

  //toMap 함수 -> Map 구조로 변환
  Map<String, dynamic> toMap(){
    return {
      'email' : email,
      'password' : password,
      'userName' : userName,
      'userSchoolNum' : userSchoolNum,
    };
  }
}