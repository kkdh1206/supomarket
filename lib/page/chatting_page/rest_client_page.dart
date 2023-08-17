// import 'package:json_annotation/json_annotation.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:dio/dio.dart';
//
// part 'RestClient.g.dart';
//
// @RestApi(baseUrl: 'http://jtaeh.supomarket.com')
// abstract class RestClient {
//   factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
//
//   @GET('/boards')
//   Future<List<Records>> getChatDetail();
//
//   @GET('/boards/rooms')
//   Future<List<Rooms>> getRoomDetail();
//
//   @POST('/boards/roomr')
//   Future<void> postRoomDetail(@Body() RoomData roomData);
//
// }
//
// @JsonSerializable()
// class Records {
//   //int? id;
//   //String? roomuuID;
//   String? message;
//   String? senderName;
//   //String? createdAt;
//
//   Records({
//     //this.id,
//     //this.roomuuID,
//     this.message,
//     this.senderName,
//     //this.createdAt,
//   });
//   factory Records.fromJson(Map<String, dynamic> json) => _$RecordsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$RecordsToJson(this);
// }
//
// @JsonSerializable()
// class Rooms {
//   String? userID;
//   String? roomuuID;
//   String? roomName;
//   String? userName;
//
//   Rooms({
//     this.userID,
//     this.roomuuID,
//     this.roomName,
//     this.userName
//   });
//   factory Rooms.fromJson(Map<String, dynamic> json) => _$RoomsFromJson(json);
//
//   Map<String, dynamic> toJson() => _$RoomsToJson(this);
// }
//
// @JsonSerializable()
// class RoomData {
//   String? id;
//   String? buyerID;
//   String? sellerID;
//   String? roomName;
//   String? goodsID;
//
//   RoomData({
//     this.id,
//     this.buyerID,
//     this.sellerID,
//     this.roomName,
//     this.goodsID
//   });
//   factory RoomData.fromJson(Map<String, dynamic> json) => _$RoomDataFromJson(json);
//   Map<String, dynamic> toJson() => _$RoomDataToJson(this);
// }