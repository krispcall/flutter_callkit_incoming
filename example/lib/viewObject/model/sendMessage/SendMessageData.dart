import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/sendMessage/Messages.dart";

class SendMessageData extends Object<SendMessageData> {
  SendMessageData({
    this.status,
    this.messages,
    this.error,
  });

  int? status;
  Messages? messages;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SendMessageData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SendMessageData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        messages: Messages().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SendMessageData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Messages().toMap(object.messages);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SendMessageData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<SendMessageData> login = <SendMessageData>[];
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
  List<Map<String, dynamic>>? toMapList(List<SendMessageData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final SendMessageData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
