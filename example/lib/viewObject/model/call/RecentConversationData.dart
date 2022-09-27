import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/RecentConversation.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class RecentConversationData extends Object<RecentConversationData> {
  RecentConversationData({
    this.status,
    this.recentConversation,
    this.error,
    this.id,
  });

  int? status;
  RecentConversation? recentConversation;
  ResponseError? error;

  String? id;

  @override
  String getPrimaryKey() {
    return "id";
  }

  @override
  RecentConversationData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        recentConversation: RecentConversation().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = RecentConversation().toMap(object.recentConversation);
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversationData> login = <RecentConversationData>[];
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
      List<RecentConversationData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
