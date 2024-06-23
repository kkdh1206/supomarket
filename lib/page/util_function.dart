
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supo_market/widgets/util_widgets.dart';
import '../entity/board_entity.dart';
import '../entity/item_entity.dart';
import '../entity/user_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';
import '../infra/my_info_data.dart';
import '../infra/users_info_data.dart';
import '../usecases/util_usecases.dart';
import 'my_page/sub_selling_page_evaluation_page.dart';

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
Future<bool>? chattingPageBuilder;
Future<bool>? subSubHomePageCommentsPageBuilder;
Future<bool>? mainPageBuilder;
Future<bool>? managementPageBuilder;


String? fcmToken;

String setCategoryName(String category) {
  if(category == "ItemType.REFRIGERATOR") {
    return "전자기기";
  }
  else if(category == "ItemType.BOOK") {
    return "책";
  }
  else if(category == "ItemType.CLOTHES") {
    return "가구";
  }
  else if(category == "ItemType.ROOM") {
    return "자취방";
  }
  else if(category == "ItemType.MONITOR") {
    return "이동수단";
  }
  else if(category == "ItemType.HELP") {
    return "구인";
  }
  else {
    return "기타";
  }
}

Future<bool> setChatAlarmInDevice (bool check) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("set chatAlarm in device");
  pref.setBool('isChatAlarm', check);
  mySetting.chatAlarmOnOff = await getChatAlarmInDevice();
  return true;
}

Future<bool> getChatAlarmInDevice() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try{
    print("get isChatAlarm In device Complete => ${pref.getBool('isChatAlarm')}");
    return pref.getBool('isChatAlarm')!;
  }catch(e){
    print("get isChatAlarm In device Error");
    return false;
  }
}

Future<bool> setCategoryAlarmInDevice (bool check) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  debugPrint("set CategoryAlarm in device");
  pref.setBool('isCategoryAlarm', check);
  mySetting.categoryAlarmOnOff = await getCategoryAlarmInDevice();
  return true;
}

Future<bool> getCategoryAlarmInDevice() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  try{
    print("get isAlarm In device Complete => ${pref.getBool('isCategoryAlarm')}");
    return pref.getBool('isCategoryAlarm')!;
  }catch(e){
    print("get isCategoryAlarm In device Error");
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
  String url = 'https://kdh.supomarket.com/auth/userInfo'; // 수정요망 (https://) 일단 뺌  --> 앞에 http든 https 든 꼭 있어야되구나!!

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

    getMyInfoRequestList();

  }catch (e) {
    print('Error sending GET request : $e');
  }

  return true;
}
//
// Future<bool> getMyInfoRequestList() async {
//
//   print("get Request List");
//
//   String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
//
//   Dio dio = Dio();
//   dio.options.headers['Authorization'] = 'Bearer $token';
//   String url = 'https://kdh.supomarket.com/auth/request';
//
//   try {
//     Response response = await dio.get(url);
//     dynamic jsonData = response.data;
//
//     var splitList = jsonData as List<dynamic>;
//     Map<String,String>? temp = {'itemId' : '' , 'userId' : ''};
//     for(int i = 0; i<splitList.length; i++){
//       temp?['itemId'] = splitList[i].split(' ')[0];
//       temp?['userId'] = splitList[i].split(' ')[1];
//       myUserInfo.requestList?.add(temp!);
//       print(myUserInfo.requestList?[i].toString());
//     }
//
//   }
//   catch (e) {
//     print('Error sending GET request : $e');
//   }
//
//   return true;
// }

String itemName = "";
String sellerName = "";

Future<String> getItemById(String id) async{

  print("getItemById : $id");
  String itemName = "";
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();

  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/id/$id';

  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;

    String name = jsonData as String;
    itemName = name;
  } catch (e) {

    print('Error sending GET request : $e');
  }
  print("getItemById : $itemName");
  return itemName;

}

Future<List<dynamic>> getItemNameById(List<String> id) async{

  print("getItemNameById : $id");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();

  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/idList';
  List<dynamic> nameList = [];

  try {
    var data = {'id' : id};
    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;

    nameList = jsonData as List<dynamic>;
    print(nameList);

  } catch (e) {
    print('Error sending GET request : $e');
  }

  return nameList;
}

Future<List<dynamic>> getItemImageById(List<String> id) async {

  print("getItemImageById : $id");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();

  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/imgList';
  List<dynamic> imageList = [];

  try {
    var data = {'id' : id};
    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;

    imageList = jsonData as List<dynamic>;
    print(imageList);

  } catch (e) {
    print('Error sending GET request : $e');
  }

  return imageList;
}

Future<List<dynamic>> patchItemImageById(List<String> id, int index) async{

  print("patchItemImageById : $id");

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();

  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/imgList';
  List<dynamic> imageList = [];

  try {
    var data = {'id' : id};
    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;

    imageList = jsonData as List<dynamic>;
    print(imageList);

  } catch (e) {
    print('Error sending GET request : $e');
  }

  return imageList;
}

Future<String> getSellerById(String id) async{

  String? itemName;
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/id/${id}';

  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;

    String name = jsonData['title'] as String;
    itemName = name;
  } catch (e) {

    print('Error sending GET request : $e');
  }
  return " ";

}
//
// void checkRequestList(BuildContext context){
//   bool isLoading = false;
//
//   if(myUserInfo.requestList!.isNotEmpty){
//     for(int i=0; i<myUserInfo.requestList!.length; i++){
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               scrollable: true,
//               title: const Text('해당 물품을 거래하셨나요?'),
//               content: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Form(
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             children: [
//                               Text('제목 :', style: TextStyle(fontFamily: 'KBO-B')),
//                               Expanded(
//                                   child: Text(itemName)),
//                             ],
//                           ),
//                           const SizedBox(height: 5),
//                           Row(
//                             children: [
//                               Text('판매자 :',
//                                   style: TextStyle(fontFamily: 'KBO-B')),
//                               Expanded(child: Text(sellerName)),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                   child: Text("예"),
//                                   onPressed: () async {
//                                     isLoading = true;
//
//                                     await utilUsecase.patchRequestList('9','9');
//
//                                     isLoading = false;
//
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 SubSellingPageEvaluationPage(
//                                                     userID: int.parse(myUserInfo.requestList![0]['userId']!))));
//                                     //맨 앞 없애기
//                                     myUserInfo.requestList?.removeAt(0);
//                                   }),
//                               const SizedBox(width: 10),
//                               ElevatedButton(
//                                   child: Text("아니오"),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   })
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   isLoading ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ) : const SizedBox(width: 0, height: 0),
//                 ],
//               ),
//             );
//           });
//     }
//
//   }
// }

// Future<void> deleteReqeustList(int itemId, String sellerName) async {
//
//   print("patch Request");
//
//   String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
//
//   Dio dio = Dio();
//   dio.options.headers['Authorization'] = 'Bearer $token';
//   String url = 'https://kdh.supomarket.com/auth/request';
//
//   //id인데 사실은 sellerName이라는거지 ㅇㅋ
//   var data = {'itemId' : itemId, 'sellerId' : sellerName};
//
//   try {
//     Response response = await dio.patch(url, data: data);
//   } catch (e) {
//     print('Error sending PATCH request : $e');
//   }
//
//   return;
//
// }


Future<AUser> getUserInfo(Item item) async {
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getUserData');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/itemId/${item.itemID}';


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
    String userGrade = jsonData['userGrade'] as String;
    //List<Item> itemList = jsonData['items'] as List<Item>;

    return AUser(id: id, email: Email, userName: username, imagePath: imageUrl, isUserLogin: true, userStatus: convertStringToEnum(userstatus), userStudentNumber: studentNumber, userInterestedId: interestedId, userUid : uid, userGrade: userGrade);

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
  String url = 'https://kdh.supomarket.com/boards/boardId/${board.id}';


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

Future<AUser> getUserInfo3(String itemId) async {



  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  print('getUserData');   print("itemId" + itemId);
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/itemId/${itemId}';


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

Future<List<Item>>? getItemList(int sellerId) async {
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  List<Item> sellerItemList = [];
  ItemType? tempItemType;
  ItemStatus? tempItemStatus;
  ItemQuality? tempItemQuality;
  print(sellerId);
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/items/record/${sellerId}';

  try {
    Response response = await dio.get(url);
    print('Response:');
    print(response);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;
    for(var data in jsonData) {
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

      int view = data['view'] as int;

      String updatedAt = data['updatedAt'] as String;
      List<String> imageUrl = List<String>.from(data['ImageUrls']);

      // 사진도 받아야하는데
      DateTime dateTime = DateTime.parse(updatedAt);
      
      sellerItemList.add(Item(sellingTitle: title, itemType:tempItemType, itemQuality: tempItemQuality!, sellerName: "정태형", sellingPrice: price, uploadDate: "10일 전", uploadDateForCompare: dateTime, itemDetail:description,sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: imageUrl, itemStatus: tempItemStatus!, itemID: id, view: view));
    }
    print("sellerItemList: ");
    print(sellerItemList);
    return sellerItemList;

  } catch (e) {
    print('Error sending GET request : $e');
    return sellerItemList;

  }
}

Future<bool> getItem(int page, SortType type, ItemStatus status, TradeType sellBuy) async{

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
  String url = 'https://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&page=${page}&status=${ConvertEnumToString(status)}&buy=${sellBuy}&pageSize=${pageSize}';

  if(page == 1) {
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

      int view = data['view'] as int;

      String updatedAt = data['updatedAt'] as String;
      List<String> imageUrl = List<String>.from(data['ImageUrls']);

      // 사진도 받아야하는데
      DateTime dateTime = DateTime.parse(updatedAt);

      // 시간 어떻게 받아올지 고민하기!!!!!!
      // 그리고 userId 는 현재 null 상태 해결해야함!!!
      itemList.add(Item(sellingTitle: title, itemType:tempItemType, itemQuality: tempItemQuality!, sellerName: "정태형", sellingPrice: price, uploadDate: "10일 전", uploadDateForCompare: dateTime, itemDetail:description,sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: imageUrl, itemStatus: tempItemStatus!, itemID: id, view: view));
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
  else if(string == "HELP"){
    return ItemType.HELP;
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
  Duration differences = now.difference(date);
  int hour = differences.inHours;
  int minute = differences.inMinutes;
  int second = differences.inSeconds;

  int gap = hour*3600 + minute*60 + second;
  gap = gap + 93505;

  if (gap<0){gap = -gap;}
  if (0<=gap&& gap<=60) {
    return '방금 전';
  } else if (gap < 3600) {
    return '${(gap/60).floor()} 분 전';
  } else if (gap<24*3600) {
    return '${(gap/3600).floor()} 시간 전';
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
  String url = 'https://kdh.supomarket.com/auth/fcmToken';

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
  String url = 'https://kdh.supomarket.com/auth/fcmToken';

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

Future<List<dynamic>> getTokenByCategory(String? category) async{
  print("token 서버에서 가져오기 ");
  String? userToken;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();

  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/auth/fcmTokenByCategory';
  List<dynamic> tokenList = [];

  try {
    var data = {'category' : category};
    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;

    tokenList = jsonData as List<dynamic>;
    print("fcmToken ${userToken}을 받았습니다");
  } catch (e) {
    print('Error sending GET request : $e');
  }

  return tokenList;

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

Future<bool> getMyInfoRequestList() async {

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/auth/request';

  try {

    Response response = await dio.get(url);
    dynamic jsonData = response.data;

      myUserInfo.requestList?.clear();

      List<dynamic> requestList = jsonData as List<dynamic>;
      String inputString = "";

      for(int i = 0; i<requestList.length; i++){
        Map<String, String> map = Map();
        inputString = requestList[i];
        List<String> userIdList = inputString.split(' ');
        map['itemId'] = userIdList[0]; print(userIdList[0]);
        map['userId'] = userIdList[1]; print(userIdList[1]);
        myUserInfo.requestList?.add(map);
      }
      print(myUserInfo.requestList.toString());


  } catch (e) {
    print('Error sending GET request : $e');
  }
  return true;
}

Future<bool?> getChatAlarmById(String? userUid) async {
  String? alarm;
  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  Dio dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'https://kdh.supomarket.com/auth/getChatAlarm';

  try {
    var data = {'uid': userUid};
    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;
    alarm = jsonData as String;
  } catch (e) {
    print('Error sending GET request : $e');
  }
  print("getChatAlarmById 함수에서 받은 알림 유무");
  print(alarm);
  if(alarm == 'true') {
    return true;
  }
  else if(alarm == 'false') {
    return false;
  }
}

Future<bool> assignTrue() async{
  print("assign True");
  return true;
}

Future<String> getUserName(String? userUid) async {
  Dio dio = Dio();
  dio.options.responseType = ResponseType.plain; // responseType 설정
  String url = 'https://kdh.supomarket.com/auth/userUid';

  Map<String, String?> data = {'userUid': userUid};
  try {

    Response response = await dio.get(url, data: data);
    dynamic jsonData = response.data;
    String userName = jsonData as String;

    print("userName ${userName}을 받았습니다");
    return userName;

  } catch (e) {
    print('Error sending GET request : $e');
    return "error";
  }
}