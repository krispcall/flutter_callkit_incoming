import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessage.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CreateChatMessageData extends Object<CreateChatMessageData> {
  CreateChatMessageData({
    this.status,
    this.messages,
    this.error,
  });

  int? status;
  CreateChatMessage? messages;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  CreateChatMessageData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CreateChatMessageData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        messages: CreateChatMessage().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CreateChatMessageData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = CreateChatMessage().toMap(object.messages);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CreateChatMessageData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CreateChatMessageData> login = <CreateChatMessageData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<CreateChatMessageData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CreateChatMessageData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
