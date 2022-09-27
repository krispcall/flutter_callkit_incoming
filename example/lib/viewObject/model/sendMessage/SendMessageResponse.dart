import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/sendMessage/SendMessageData.dart";

class SendMessageResponse extends Object<SendMessageResponse> {
  SendMessageData? sendMessage;

  SendMessageResponse({this.sendMessage});

  @override
  SendMessageResponse? fromMap(dynamic dynamic) {
    return SendMessageResponse(
        sendMessage: dynamic["sendMessage"] != null
            ? SendMessageData().fromMap(dynamic["sendMessage"])
            : null);
  }

  Map<String, dynamic>? toMap(SendMessageResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.sendMessage != null) {
      data["sendMessage"] = SendMessageData().toMap(object.sendMessage);
    }
    return data;
  }

  @override
  List<SendMessageResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<SendMessageResponse> list = <SendMessageResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<SendMessageResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as SendMessageResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
