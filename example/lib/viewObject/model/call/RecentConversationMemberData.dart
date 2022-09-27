import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversationMember.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class RecentConversationMemberData
    extends Object<RecentConversationMemberData> {
  RecentConversationMemberData({
    this.status,
    this.recentConversationMember,
    this.error,
  });

  int? status;
  RecentConversationMember? recentConversationMember;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  RecentConversationMemberData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationMemberData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        recentConversationMember:
            RecentConversationMember().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationMemberData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] =
          RecentConversationMember().toMap(object.recentConversationMember);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationMemberData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationMemberData> login =
        <RecentConversationMemberData>[];
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
      List<RecentConversationMemberData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationMemberData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
