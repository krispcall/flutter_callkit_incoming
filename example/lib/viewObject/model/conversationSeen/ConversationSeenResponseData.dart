import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/conversationSeen/ConversationSeen.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class ConversationSeenResponseData
    extends Object<ConversationSeenResponseData> {
  int? status;
  ResponseError? error;
  ConversationSeen? conversationSeen;

  ConversationSeenResponseData({
    this.status,
    this.error,
    this.conversationSeen,
  });

  @override
  ConversationSeenResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ConversationSeenResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        error: ResponseError().fromMap(dynamicData["error"]),
        conversationSeen: ConversationSeen().fromMap(dynamicData["data"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ConversationSeenResponseData? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = object!.status;
    data["error"] = ResponseError().toMap(object.error);
    data["data"] = ConversationSeen().toMap(object.conversationSeen);
    return data;
  }

  @override
  List<ConversationSeenResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ConversationSeenResponseData> basketList =
        <ConversationSeenResponseData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<ConversationSeenResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ConversationSeenResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
