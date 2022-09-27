import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversationData.dart";

class RecentConversationResponse extends Object<RecentConversationResponse> {
  RecentConversationData? recentConversationData;

  RecentConversationResponse({this.recentConversationData});

  @override
  RecentConversationResponse? fromMap(dynamic dynamicData) {
    return RecentConversationResponse(
      recentConversationData: dynamicData["recentConversation"] != null
          ? RecentConversationData().fromMap(dynamicData["recentConversation"])
          : null,
    );
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.recentConversationData != null) {
      data["recentConversation"] =
          RecentConversationData().toMap(object.recentConversationData);
    }
    return data;
  }

  @override
  List<RecentConversationResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversationResponse> basketList =
        <RecentConversationResponse>[];
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
      List<RecentConversationResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
