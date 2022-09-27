import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberData.dart";

class MemberConversationDetailResponse
    extends Object<MemberConversationDetailResponse> {
  RecentConversationMemberData ?conversationData;

  MemberConversationDetailResponse({this.conversationData});

  @override
  MemberConversationDetailResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberConversationDetailResponse(
        conversationData: dynamicData["chatHistory"] != null
            ? RecentConversationMemberData().fromMap(dynamicData["chatHistory"])
            : null,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberConversationDetailResponse ?object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.conversationData != null) {
      data["chatHistory"] =
          RecentConversationMemberData().toMap(object.conversationData);
    }
    return data;
  }

  @override
  List<MemberConversationDetailResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<MemberConversationDetailResponse> basketList =
        <MemberConversationDetailResponse>[];
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
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<MemberConversationDetailResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberConversationDetailResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
