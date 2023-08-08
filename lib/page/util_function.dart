

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../entity/item_entity.dart';
import '../entity/util_entity.dart';
import '../infra/item_list_data.dart';

Future<bool>? homePageBuilder;

Future<bool> fetchData(int page, SortType type) async{

  ItemType? tempItemType;
  ItemStatus? tempItemStatus;
  ItemQuality? tempItemQuality;
  String? tempSellerName;
  String? tempSellerSchoolNum;
  int pageSize = 10;

  String token = await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  print(token);
  Dio dio = Dio();
  print('여긴가??');
  dio.options.headers['Authorization'] = 'Bearer $token';
  String url = 'http://kdh.supomarket.com/items?sort=${ConvertEnumToString(type)}&page=${page}&pageSize=${pageSize}';

  if(page == 1){
    itemList.clear();
  }

  try {
    Response response = await dio.get(url);
    // Map<String, dynamic> JsonData = json.decode(response.data);
    dynamic jsonData = response.data;

    print(jsonData);

    for (var data in jsonData) {
      int id = data['id'] as int;
      String title = data['title'] as String;
      String description = data['description'] as String;
      int price = data['price'] as int;

      String status = data['status'] as String; //--> 이 부분은 수정 코드 주면 그때 실행하기
      tempItemStatus = ConvertStringToEnum(status);

      String quality = data['quality'] as String;
      tempItemQuality = ConvertStringToEnum(quality);

      String category = data['category'] as String;
      tempItemType = ConvertStringToEnum(category);

      String updatedAt = data['updatedAt'] as String;
      List<String> imageUrl = List<String>.from(data['ImageUrls']);

      // 사진도 받아야하는데
      DateTime dateTime = DateTime.parse(updatedAt);

      // 시간 어떻게 받아올지 고민하기!!!!!!
      // 그리고 userId 는 현재 null 상태 해결해야함!!!
      itemList.add(Item(sellingTitle: title, itemType:tempItemType, itemQuality: tempItemQuality!, sellerName: "정태형", sellingPrice: price, uploadDate: "10일 전", uploadDateForCompare: dateTime, itemDetail:description,sellerImage: "https://firebasestorage.googleapis.com/v0/b/supomarket-b55d0.appspot.com/o/assets%2Fimages%2Fuser.png?alt=media&token=3b060089-e652-4e59-9900-54d59349af96", isLiked : false, sellerSchoolNum: "20220000", imageListA: [], imageListB: imageUrl, itemStatus: tempItemStatus!));
    }

  } catch (e) {
    print('Error sending GET request : $e');
  }
  return true;
}

dynamic ConvertStringToEnum(String string){
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



