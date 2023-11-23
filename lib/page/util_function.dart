
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/board_entity.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';

Future<bool>? homePageBuilder;
Future<bool>? subHomePageBuilder;
Future<bool>? favoritePageBuilder;
Future<bool>? sellingPageBuilder;
Future<bool>? buyingPageBuilder;
Future<bool>? searchPageBuilder;
Future<bool>? categoryPageBuilder;
Future<bool>? masterItemPageBuilder;
Future<bool>? quickSellPageBuilder;
Future<bool>? alarmPageBuilder;
Future<bool>? qnaPageBuilder;
Future<bool>? qnaSearchPageBuilder;
Future<bool>? boardPageBuilder;
Future<bool>? myQnaPageBuilder;
Future<bool>? subChattingPageBuilder;
Future<bool>? subSubHomePageCommentsPageBuilder;

String? fcmToken;

Future<bool> setAlarmInDevice (bool check) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("set alarm in device");
  pref.setBool('isAlarm', check);
  mySetting.chattingAlarm = await getAlarmInDevice();
  return true;
}

Future<bool> getAlarmInDevice() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try{
    print("get isAlarm In device Complete => ${pref.getBool('isAlarm')}");
    return pref.getBool('isAlarm')!;
  }catch(e){
    print("get isAlarm In device Error");
    return false;
  }
}

Future<bool> setPasswordInDevice (String password) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("set password in device");
  pref.setString('password', password);

  myUserInfo.password = await getPasswordInDevice();
  return true;
}

Future<String> getPasswordInDevice() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try{
    print("get Password In device Complete => ${pref.getString('password')}");
    return pref.getString('password')!;
  }catch(e){
    print("get Password In device Error");
    return "error";
  }
}

Future<bool> getMyInfo() async{

  print("get My Info");
  //도형코드~
  debugPrint("LogInPage : auth/userInfo : 유저 정보 Response 받아오기");
  var token = await firebaseAuth.currentUser?.getIdToken();
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  // dio.options.responseType = ResponseType.plain; // responseType 설정
  String url = 'http://kdh.supomarket.com/auth/userInfo'; // 수정요망 (https://) 일단 뺌  --> 앞에 http든 https 든 꼭 있어야되구나!!

  try {
    Response response = await dio.get(url);
    dynamic jsonData = response.data;

    String studentNumber = jsonData['studentNumber'] as String;
    myUserInfo.userStudentNumber = studentNumber;
    int id = jsonData['id'] as int;
    myUserInfo.id = id;
    String Email = jsonData['Email'] as String;
    myUserInfo.email = Email;
    String username = jsonData['username'] as String;
    myUserInfo.userName = username;
    String userstatus = jsonData['userstatus'] as String;
    myUserInfo.userStatus = convertStringToEnum(userstatus);
    String imageUrl = jsonData['imageUrl'] as String;
    myUserInfo.imagePath = imageUrl;
    List<dynamic> interestedId = jsonData['interestedId'] as List<dynamic>;
    myUserInfo.userInterestedId = interestedId;
    String uid = jsonData['uid'] as String;
    myUserInfo.userUid = uid;
    String grade = jsonData['userGrade'] as String;
    myUserInfo.userGrade = grade;
    int score = jsonData['userScore'] as int;
    myUserInfo.userScore = score;

    print("uid : $uid");

    //getMyInfoRequestList();

  }catch (e) {
    print('Error sending GET request : $e');
  }

  return true;
}

Future<bool> getMyInfoRequestList() async {

  print("get Request List");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/auth/request';

  try {
    Response response = await dio.get(url);
    dynamic jsonData = response.data;

    final splitList = jsonData['request'] as String;
    Map<String, String>? temp = {'itemId' : splitList[0], 'userId' : splitList[1]};
    myUserInfo.requestList?.add(temp);
  }
  catch (e) {
    print('Error sending GET request : $e');
  }

  return true;
}


Future<AUser> getUserInfo(Item item) async {
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getUserData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/itemId/${item.itemID}';


  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;

    int id = jsonData['id'] as int;
    String Email = jsonData['Email'] as String;
    String username = jsonData['username'] as String;
    String userstatus = jsonData['userstatus'] as String;
    String imageUrl = jsonData['imageUrl'] as String;
    List<dynamic> interestedId = jsonData['interestedId'] as List<dynamic>;
    String studentNumber = jsonData['studentNumber'] as String;
    String uid = jsonData['uid'] as String;

    return AUser(id: id, email: Email, userName: username, imagePath: imageUrl, isUserLogin: true, userStatus: convertStringToEnum(userstatus), userStudentNumber: studentNumber, userInterestedId: interestedId, userUid : uid);

  } catch (e) {

    print('Error sending GET request : $e');
    return AUser(id: 0, email: "", userName : "", imagePath: "", isUserLogin: false, userStatus: UserStatus.NORMAL, userStudentNumber: "", userInterestedId: [], userUid : "");

  }
}

Future<AUser> getUserInfo2(Board board) async {
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getUserData in Board');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/boards/boardId/${board.id}';


  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;

    int id = jsonData['id'] as int;
    String Email = jsonData['Email'] as String;
    String username = jsonData['username'] as String;
    String userstatus = jsonData['userstatus'] as String;
    String imageUrl = jsonData['imageUrl'] as String;
    List<dynamic> interestedId = jsonData['interestedId'] as List<dynamic>;
    String studentNumber = jsonData['studentNumber'] as String;
    String uid = jsonData['uid'] as String;

    return AUser(id: id, email: Email, userName: username, imagePath: imageUrl, isUserLogin: true, userStatus: convertStringToEnum(userstatus), userStudentNumber: studentNumber, userInterestedId: interestedId, userUid : uid);

  } catch (e) {

    print('Error sending GET request : $e');
    return AUser(id: 0, email: "", userName : "", imagePath: "", isUserLogin: false, userStatus: UserStatus.NORMAL, userStudentNumber: "", userInterestedId: [], userUid : "");

  }
}

Future<bool> getItem(int page, SortType type, ItemStatus status) async{

  ItemType? tempItemType;
  ItemStatus? tempItemStatus;
  ItemQuality? tempItemQuality;
  String? tempSellerName;
  String? tempSellerSchoolNum;
  int pageSize = 10;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&page=${page}&status=${ConvertEnumToString(status)}&pageSize=${pageSize}';

  if(page == 1){
    itemList.clear();
  }

  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;


    print("jsonData" + jsonData.toString());


    for (var data in jsonData) {
      int id = data['id'] as int;
      String title = data['title'] as String;
      String description = data['description'] as String;
      int price = data['price'] as int;

      String status = data['status'] as String; //--> 이 부분은 수정 코드 주면 그때 실행하기
      tempItemStatus = convertStringToEnum(status);

      String quality = data['quality'] as String;
      tempItemQuality = convertStringToEnum(quality);

      String category = data['category'] as String;
      tempItemType = convertStringToEnum(category);

      String updatedAt = data['updatedAt'] as String;
      List<String> imageUrl = List<String>.from(data['ImageUrls']);

      // 사진도 받아야하는데
      DateTime dateTime = DateTime.parse(updatedAt);

      // 시간 어떻게 받아올지 고민하기!!!!!!
      // 그리고 userId 는 현재 null 상태 해결해야함!!!
      itemList.add(Item(sellingTitle: title, itemType:tempItemType, itemQuality: tempItemQuality!, sellerName: "정태형", sellingPrice: price, uploadDate: "10일 전", uploadDateForCompare: dateTime, itemDetail:description,sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: imageUrl, itemStatus: tempItemStatus!, itemID: id));
    }

  } catch (e) {
    print('Error sending GET request : $e');
  }
  return true;
}

dynamic convertStringToEnum(String string){
  if(string =="REFRIGERATOR"){
    return ItemType.REFRIGERATOR;
  }
  else if(string == "CLOTHES"){
    return ItemType.CLOTHES;
  }
  else if(string == "ROOM"){
    return ItemType.ROOM;
  }
  else if(string == "MONITOR"){
    return ItemType.MONITOR;
  }
  else if(string == "BOOK"){
    return ItemType.BOOK;
  }
  else if(string == "ETC"){
    return ItemType.ETC;
  }
  else if(string == "TRADING"){
    return ItemStatus.TRADING;
  }
  else if(string == "SOLDOUT"){
    return ItemStatus.SOLDOUT;
  }
  else if(string == "USERFASTSELL"){
    return ItemStatus.USERFASTSELL;
  }
  else if(string == "SUPOFASTSELL"){
    return ItemStatus.SUPOFASTSELL;
  }
  else if(string == "RESERVED"){
    return ItemStatus.RESERVED;
  }
  else if(string == "HIGH"){
    return ItemQuality.HIGH;
  }
  else if(string == "MID"){
    return ItemQuality.MID;
  }
  else if(string == "LOW"){
    return ItemQuality.LOW;
  }
  else if(string == "DATEASCEND"){
    return SortType.DATEASCEND;
  }
  else if(string == "PRICEDESCEND"){
    return SortType.PRICEDESCEND;
  }
  else if(string == "PRICEASCEND"){
    return SortType.PRICEASCEND;
  }
  else if(string == "DATEDESCEND"){
    return SortType.DATEDESCEND;
  }
  else if(string == "NORMAL"){
    return UserStatus.NORMAL;
  }
  else if(string == "ADMIN"){
    return UserStatus.ADMIN;
  }
  else if(string == "BANNED"){
    return UserStatus.BANNED;
  }
  else if(string == "PUBLIC"){
    return BoardStatus.PUBLIC;
  }
  else if(string == "PRIVATE"){
    return BoardStatus.PRIVATE;
  }
  else if(string == "DELETED"){
    return BoardStatus.DELETED;
  }
}


dynamic ConvertEnumToString(dynamic ENUM){
  if(ENUM==ItemType.REFRIGERATOR){
    return "REFRIGERATOR";
  }
  else if(ENUM == ItemType.CLOTHES){
    return "CLOTHES";
  }
  else if(ENUM == ItemType.ROOM){
    return "ROOM";
  }
  else if(ENUM == ItemType.MONITOR){
    return "MONITOR";
  }
  else if(ENUM == ItemType.BOOK){
    return "BOOK";
  }
  else if(ENUM == ItemType.ETC){
    return "ETC";
  }
  else if(ENUM == ItemStatus.TRADING){
    return "TRADING";
  }
  else if(ENUM == ItemStatus.SOLDOUT){
    return "SOLDOUT";
  }
  else if(ENUM == ItemStatus.USERFASTSELL){
    return "USERFASTSELL";
  }
  else if(ENUM == ItemStatus.SUPOFASTSELL){
    return "SUPOFASTSELL";
  }
  else if(ENUM == ItemStatus.RESERVED){
    return "RESERVED";
  }
  else if(ENUM == ItemQuality.HIGH){
    return "HIGH";
  }
  else if(ENUM == ItemQuality.MID){
    return "MID";
  }
  else if(ENUM == ItemQuality.LOW){
    return "LOW";
  }
  else if(ENUM == SortType.DATEASCEND){
    return "DATEASCEND";
  }
  else if(ENUM == SortType.PRICEDESCEND){
    return "PRICEDESCEND";
  }
  else if(ENUM == SortType.PRICEASCEND){
    return "PRICEASCEND";
  }
  else if(ENUM == SortType.DATEDESCEND){
    return "DATEDESCEND";
  }
  else if(ENUM == UserStatus.NORMAL){
    return "NORMAL";
  }
  else if(ENUM == UserStatus.BANNED){
    return "BANNED";
  }
  else if(ENUM == UserStatus.ADMIN){
    return "ADMIN";
  }
  else if(ENUM == BoardStatus.PUBLIC){
    return "PUBLIC";
  }
  else if(ENUM == BoardStatus.PRIVATE){
    return "PRIVATE";
  }
  else if(ENUM == BoardStatus.DELETED){
    return "DELETED";
  }
}

//(현재 Date) - (등록 Data) => 업로드 시간 표시
String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inMinutes < 1) {
    return '방금 전';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} 분 전';
  } else if (difference.inDays < 1) {
    return '${difference.inHours} 시간 전';
  } else {
    return '${date.year}.${date.month}.${date.day}';
  }
}

String formatDateOnlyDate(DateTime date) {
  return '${date.year}.${date.month}.${date.day}';
}


Future<void> patchToken(String fcmToken) async{

  print("token 변경");
  print("fcmToken : " + fcmToken);

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';

  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/auth/fcmToken';

  var data = {'fcmToken' : fcmToken};

  try {
    Response response = await dio.patch(url, data:data);
  } catch (e) {
    print('Error sending PATCH request : $e');
  }

}

Future<String> getToken(String uid) async{

  print("token 서버에서 가져오기 ");
  String? userToken;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/auth/fcmToken';

  var data = {'uid' : uid};

  try {
    Response response = await dio.get(url, data:data);
    dynamic jsonData = response.data;
    userToken = jsonData as String;
    print("fcmToken ${userToken}을 받았습니다");
  } catch (e) {
    print('Error sending GET request : $e');
  }

  return userToken??"";

}


Future reqIOSPermission(FirebaseMessaging fbMsg) async {
  NotificationSettings settings = await fbMsg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}