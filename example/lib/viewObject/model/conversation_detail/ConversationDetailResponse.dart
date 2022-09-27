import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversationData.dart";

class ConversationDetailResponse extends Object<ConversationDetailResponse> {
  RecentConversationData? conversationData;

  ConversationDetailResponse({this.conversationData});

  @override
  ConversationDetailResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ConversationDetailResponse(
        conversationData: dynamicData["conversation"] != null
            ? RecentConversationData().fromMap(dynamicData["conversation"])
            : null,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ConversationDetailResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.conversationData != null) {
      data["conversation"] =
          RecentConversationData().toMap(object.conversationData);
    }
    return data;
  }

  @override
  List<ConversationDetailResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ConversationDetailResponse> basketList =
        <ConversationDetailResponse>[];
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
      List<ConversationDetailResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ConversationDetailResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
