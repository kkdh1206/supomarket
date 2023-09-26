import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'RestClient.g.dart';

@RestApi(baseUrl: 'http://jtaeh.supomarket.com')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/boards')
  Future<List<Records>> getChatDetail();

  @GET('/boards/rooms')
  Future<List<Rooms>> getRoomDetail();

  @POST('/boards/roomr')
  Future<void> postRoomDetail(@Body() RoomData roomData);

  @GET('/boards/room')
  Future<List<Room>> getRoomrDetail();

  @GET('/boards/{id}')
  Future<List<Chat>> getChatById({@Path() String? id});

  @GET('/boards/room/{id}')
  Future<List<Room>> getRoomById({@Path() String? id});

  @POST('/boards/delete')
  Future<void> deleteRoom(@Body() DeleteId deleteId);

  @GET('/boards/{message}')
  Future<Time> getTimeByMessage({@Path() String? message});

  @PATCH('/boards/{message}')
  Future<void> updateCheck(@Path() String? message, @Body() Check check);

  @POST('/boards/push')
  Future<void> postNotification(@Body() Notificate notificate);

  @GET('/boards/token/{roomId}')
  Future<Token> getTokenById({@Path() String? roomId});

}



@JsonSerializable()
class Records {
  //int? id;
  //String? roomuuID;
  String? message;
  String? senderName;
  //String? createdAt;

  Records({
    //this.id,
    //this.roomuuID,
    this.message,
    this.senderName,
    //this.createdAt,
  });
  factory Records.fromJson(Map<String, dynamic> json) => _$RecordsFromJson(json);

  Map<String, dynamic> toJson() => _$RecordsToJson(this);
}

@JsonSerializable()
class Rooms {
  String? userID;
  String? roomuuID;
  String? roomName;
  String? userName;

  Rooms({
    this.userID,
    this.roomuuID,
    this.roomName,
    this.userName
  });
  factory Rooms.fromJson(Map<String, dynamic> json) => _$RoomsFromJson(json);

  Map<String, dynamic> toJson() => _$RoomsToJson(this);
}

@JsonSerializable()
class RoomData {
  String? id;
  String? buyerID;
  String? sellerID;
  String? roomName;
  String? goodsID;
  String? buyerToken;
  String? sellerToken;
  String? resentTime;

  RoomData({
    this.id,
    this.buyerID,
    this.sellerID,
    this.roomName,
    this.goodsID,
    this.buyerToken,
    this.sellerToken,
    this.resentTime,
  });
  factory RoomData.fromJson(Map<String, dynamic> json) => _$RoomDataFromJson(json);
  Map<String, dynamic> toJson() => _$RoomDataToJson(this);
}
@JsonSerializable()
class Room {
  String? id;
  String? buyerID;
  String? sellerID;
  String? roomName;
  String? goodsID;
  String? buyerToken;
  String? sellerToken;

  Room ({
    this.id,
    this.buyerID,
    this.sellerID,
    this.roomName,
    this.goodsID,
    this.buyerToken,
    this.sellerToken
  });
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable()
class Chat {
  String? senderID;
  String? message;
  String? senderName;
  String? checkRead;
  String? createdAt;

  Chat({
    this.senderID,
    this.message,
    this.senderName,
    this.checkRead,
    this.createdAt,
  });
  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@JsonSerializable()
class DeleteId {
  String? id;

  DeleteId({
    this.id,
  });
  factory DeleteId.fromJson(Map<String, dynamic> json) => _$DeleteIdFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteIdToJson(this);
}

@JsonSerializable()
class Time {
  String? created_at;

  Time({
    this.created_at,
  });
  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);
}

@JsonSerializable()
class Check {
  String? checkRead;

  Check({
    this.checkRead,
  });
  factory Check.fromJson(Map<String, dynamic> json) => _$CheckFromJson(json);
  Map<String, dynamic> toJson() => _$CheckToJson(this);
}

@JsonSerializable()
class Notificate {
  String? token;
  String? title;
  String? sentence;
  String? roomId;

  Notificate({
    this.token,
    this.title,
    this.sentence,
    this.roomId
  });
  factory Notificate.fromJson(Map<String, dynamic> json) => _$NotificateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificateToJson(this);
}

@JsonSerializable()
class Token {
  String? buyerToken;
  String? sellerToken;

  Token({
    this.buyerToken,
    this.sellerToken
  });
  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}