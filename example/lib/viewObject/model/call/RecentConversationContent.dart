import "package:mvp/viewObject/common/Object.dart";

class RecentConversationContent extends Object<RecentConversationContent> {
  String? body;
  String? callDuration;
  String? callTime;
  String? duration;
  String? transferredAudio;

  RecentConversationContent(
      {this.body,
      this.callDuration,
      this.callTime,
      this.duration,
      this.transferredAudio});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  RecentConversationContent fromMap(dynamic dynamicData) {
    return RecentConversationContent(
        body:
            dynamicData["body"] != null ? dynamicData["body"] as String : null,
        callDuration: dynamicData["callDuration"] == null
            ? null
            : dynamicData["callDuration"] as String,
        callTime: dynamicData["callTime"] == null
            ? null
            : dynamicData["callTime"] as String,
        duration: dynamicData["duration"] == null
            ? null
            : dynamicData["duration"] as String,
        transferredAudio: dynamicData["transferedAudio"] == null
            ? null
            : dynamicData["transferedAudio"] as String);
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationContent? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["body"] = object!.body;
    data["callDuration"] = object.callDuration;
    data["callTime"] = object.callTime;
    data["duration"] = object.duration;
    data["transferedAudio"] = object.transferredAudio;
    return data;
  }

  @override
  List<RecentConversationContent>? fromMapList(List? dynamicDataList) {
    final List<RecentConversationContent> basketList =
        <RecentConversationContent>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<RecentConversationContent>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationContent data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
