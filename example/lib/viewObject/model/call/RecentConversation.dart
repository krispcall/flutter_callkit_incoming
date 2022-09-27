import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/call/RecentConversationData.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";

class RecentConversation extends MapObject<RecentConversation> {
  RecentConversation({
    this.recentConversationPageInfo,
    this.recentConversationEdges,
    this.id,
  }) {
    super.sorting = sorting;
  }

  PageInfo? recentConversationPageInfo;
  List<RecentConversationEdges>? recentConversationEdges;
  String? id;

  @override
  String getPrimaryKey() {
    return "id";
  }

  @override
  RecentConversation? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversation(
        recentConversationPageInfo: PageInfo().fromMap(dynamicData["pageInfo"]),
        recentConversationEdges: RecentConversationEdges().fromMapList(
            dynamicData["edges"] == null
                ? null
                : dynamicData["edges"] as List<dynamic>),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversation? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["pageInfo"] = PageInfo().toMap(object.recentConversationPageInfo);
      data["edges"] =
          RecentConversationEdges().toMapList(object.recentConversationEdges);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversation>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversation> listMessages = <RecentConversation>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as RecentConversation)!);
        }
      }
    }
    return dynamicList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<RecentConversation>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamList = <String>[];
    if (mapList != null) {
      for (final dynamic clientInfo in mapList) {
        if (RecentConversationData()
                .toMap(clientInfo as RecentConversationData)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.getPrimaryKey());
        }
      }
    }
    return filterParamList;
  }
}
