

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';

Future<bool>? homePageBuilder;
Future<bool>? subHomePageBuilder;
Future<bool>? favoritePageBuilder;

Future<bool> fetchMyInfo() async{

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

    print("Response는 ${response}");

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

    if (response.statusCode == 200){;
    }
    else {
      print('Failed to get response. Status code: ${response.statusCode}');
    }
  }catch (e) {
    print('Error sending GET request : $e');
  }
  //~도형코드


  Reference ref = FirebaseStorage.instance.ref().child('users').child(firebaseAuth.currentUser!.uid).child("profile"+".jpg");
  if(ref!=null) {
    try{
      String url = await ref.getDownloadURL();
      //setState(() {
        myUserInfo.imagePath = url;
        debugPrint("프로필 사진 가져오기");
      //});
    } catch (e, stack) {
      myUserInfo.imagePath = "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96";
      debugPrint("업로드된 이미지가 아직 없습니다");
    }
  }

  return true;
}

Future<AUser> fetchUserInfo(Item item) async {
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('fetchUserData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/${item.itemID}';


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

Future<bool> fetchItem(int page, SortType type) async{

  ItemType? tempItemType;
  ItemStatus? tempItemStatus;
  ItemQuality? tempItemQuality;
  String? tempSellerName;
  String? tempSellerSchoolNum;
  int pageSize = 10;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('fetchData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&page=${page}&pageSize=${pageSize}';

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

Future<bool> fetchMyItem(int page, SortType type) async{

  ItemType? tempItemType;
  ItemStatus? tempItemStatus;
  ItemQuality? tempItemQuality;
  String? tempSellerName;
  String? tempSellerSchoolNum;
  int pageSize = 10;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('fetchData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items/myItems';

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
  else if(string == "FASTSELL"){
    return ItemStatus.FASTSELL;
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
  else if(string == "MID"){
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
  else if(ENUM == ItemStatus.FASTSELL){
    return "FASTSELL";
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