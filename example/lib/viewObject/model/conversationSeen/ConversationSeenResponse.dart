import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/conversationSeen/ConversationSeenResponseData.dart";

class ConversationSeenResponse extends Object<ConversationSeenResponse> {
  ConversationSeenResponseData? conversationSeenResponseData;

  ConversationSeenResponse({this.conversationSeenResponseData});

  @override
  ConversationSeenResponse ?fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ConversationSeenResponse(
        conversationSeenResponseData: dynamicData["conversationSeen"] != null
            ? ConversationSeenResponseData()
                .fromMap(dynamicData["conversationSeen"])
            : null,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ConversationSeenResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.conversationSeenResponseData != null) {
      data["conversationSeen"] = ConversationSeenResponseData()
          .toMap(object.conversationSeenResponseData!);
    }
    return data;
  }

  @override
  List<ConversationSeenResponse> ?fromMapList(List<dynamic>? dynamicDataList) {
    final List<ConversationSeenResponse> basketList =
        <ConversationSeenResponse>[];
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
      List<ConversationSeenResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ConversationSeenResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
