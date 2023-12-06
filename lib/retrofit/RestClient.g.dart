// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestClient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Records _$RecordsFromJson(Map<String, dynamic> json) => Records(
      message: json['message'] as String?,
      senderName: json['senderName'] as String?,
    );

Map<String, dynamic> _$RecordsToJson(Records instance) => <String, dynamic>{
      'message': instance.message,
      'senderName': instance.senderName,
    };

Rooms _$RoomsFromJson(Map<String, dynamic> json) => Rooms(
      userID: json['userID'] as String?,
      roomuuID: json['roomuuID'] as String?,
      roomName: json['roomName'] as String?,
      userName: json['userName'] as String?,
    );

Map<String, dynamic> _$RoomsToJson(Rooms instance) => <String, dynamic>{
      'userID': instance.userID,
      'roomuuID': instance.roomuuID,
      'roomName': instance.roomName,
      'userName': instance.userName,
    };

RoomData _$RoomDataFromJson(Map<String, dynamic> json) => RoomData(
      id: json['id'] as String?,
      buyerID: json['buyerID'] as String?,
      sellerID: json['sellerID'] as String?,
      roomName: json['roomName'] as String?,
      goodsID: json['goodsID'] as String?,
      buyerToken: json['buyerToken'] as String?,
      sellerToken: json['sellerToken'] as String?,
      resentTime: json['resentTime'] as String?,
      resentMessage: json['resentMessage'] as String?,
      resentCheck: json['resentCheck'] as String?,
    );

Map<String, dynamic> _$RoomDataToJson(RoomData instance) => <String, dynamic>{
      'id': instance.id,
      'buyerID': instance.buyerID,
      'sellerID': instance.sellerID,
      'roomName': instance.roomName,
      'goodsID': instance.goodsID,
      'buyerToken': instance.buyerToken,
      'sellerToken': instance.sellerToken,
      'resentTime': instance.resentTime,
      'resentMessage': instance.resentMessage,
      'resentCheck': instance.resentCheck,
    };

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String?,
      buyerID: json['buyerID'] as String?,
      sellerID: json['sellerID'] as String?,
      roomName: json['roomName'] as String?,
      goodsID: json['goodsID'] as String?,
      buyerToken: json['buyerToken'] as String?,
      sellerToken: json['sellerToken'] as String?,
      resentTime: json['resentTime'] as String?,
      resentMessage: json['resentMessage'] as String?,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'buyerID': instance.buyerID,
      'sellerID': instance.sellerID,
      'roomName': instance.roomName,
      'goodsID': instance.goodsID,
      'buyerToken': instance.buyerToken,
      'sellerToken': instance.sellerToken,
      'resentTime': instance.resentTime,
      'resentMessage': instance.resentMessage,
    };

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      senderID: json['senderID'] as String?,
      message: json['message'] as String?,
      senderName: json['senderName'] as String?,
      checkRead: json['checkRead'] as String?,
      createdAt: json['createdAt'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'senderID': instance.senderID,
      'message': instance.message,
      'senderName': instance.senderName,
      'checkRead': instance.checkRead,
      'createdAt': instance.createdAt,
      'imageUrl': instance.imageUrl,
    };

DeleteId _$DeleteIdFromJson(Map<String, dynamic> json) => DeleteId(
      id: json['id'] as String?,
    );

Map<String, dynamic> _$DeleteIdToJson(DeleteId instance) => <String, dynamic>{
      'id': instance.id,
    };

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      created_at: json['created_at'] as String?,
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      'created_at': instance.created_at,
    };

Check _$CheckFromJson(Map<String, dynamic> json) => Check(
      checkRead: json['checkRead'] as String?,
    );

Map<String, dynamic> _$CheckToJson(Check instance) => <String, dynamic>{
      'checkRead': instance.checkRead,
    };

Notificate _$NotificateFromJson(Map<String, dynamic> json) => Notificate(
      token: json['token'] as String?,
      title: json['title'] as String?,
      sentence: json['sentence'] as String?,
      roomId: json['roomId'] as String?,
    );

Map<String, dynamic> _$NotificateToJson(Notificate instance) =>
    <String, dynamic>{
      'token': instance.token,
      'title': instance.title,
      'sentence': instance.sentence,
      'roomId': instance.roomId,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      buyerToken: json['buyerToken'] as String?,
      sellerToken: json['sellerToken'] as String?,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'buyerToken': instance.buyerToken,
      'sellerToken': instance.sellerToken,
    };

Resent _$ResentFromJson(Map<String, dynamic> json) => Resent(
      resentMessage: json['resentMessage'] as String?,
      messageTime: json['messageTime'] as String?,
    );

Map<String, dynamic> _$ResentToJson(Resent instance) => <String, dynamic>{
      'resentMessage': instance.resentMessage,
      'messageTime': instance.messageTime,
    };

SellGoods _$SellGoodsFromJson(Map<String, dynamic> json) => SellGoods(
      sellerId: json['sellerId'] as String?,
      goodsId: json['goodsId'] as String?,
    );

Map<String, dynamic> _$SellGoodsToJson(SellGoods instance) => <String, dynamic>{
      'sellerId': instance.sellerId,
      'goodsId': instance.goodsId,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      imageUrl: (json['imageUrl'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
    };

Pages _$PagesFromJson(Map<String, dynamic> json) => Pages(
      page: json['page'] as int?,
      pageSize: json['pageSize'] as int?,
    );

Map<String, dynamic> _$PagesToJson(Pages instance) => <String, dynamic>{
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://jtaeh.supomarket.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<Records>> getChatDetail() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Records>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Records.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Rooms>> getRoomDetail() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Rooms>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/rooms',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Rooms.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<void> postRoomDetail(roomData) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(roomData.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/boards/roomr',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<List<Room>> getRoomrDetail() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Room>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/room',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Room.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Chat>> getChatById({
    id,
    page,
    pageSize,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'pageSize': pageSize,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Chat>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Chat.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<Room>> getRoomById({id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Room>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/room/${id}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Room.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<void> deleteRoom(deleteId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteId.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/boards/delete',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<Time> getTimeByMessage({message}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Time>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/${message}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Time.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> updateCheck(
    message,
    check,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(check.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/boards/${message}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<void> postNotification(notificate) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(notificate.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/boards/push',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<Token> getTokenById({roomId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Token>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/token/${roomId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Token.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> updateResent(
    roomId,
    resent,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(resent.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/boards/roomr/${roomId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<List<Room>> getReqRoomNum(
    sellerId,
    goodsId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'goodsId': goodsId};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<Room>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/roomnumber/${sellerId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => Room.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Images> getImage({roomId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch<Map<String, dynamic>>(_setStreamType<Images>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/boards/images/${roomId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Images.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
