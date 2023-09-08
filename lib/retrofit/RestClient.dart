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

  RoomData({
    this.id,
    this.buyerID,
    this.sellerID,
    this.roomName,
    this.goodsID
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

  Room ({
    this.id,
    this.buyerID,
    this.sellerID,
    this.roomName,
    this.goodsID
  });
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable()
class Chat {
  //String? id;
  String? message;
  String? senderName;
  String? createdAt;

  Chat({
    //this.id,
    this.message,
    this.senderName,
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