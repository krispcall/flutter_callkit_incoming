import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";

class RecentConversationMemberEdge
    extends MapObject<RecentConversationMemberEdge> {
  RecentConversationMemberEdge({
    this.cursor,
    this.channelId,
    this.conversationType,
    this.recentConversationMemberNodes,
    this.id,
  }) {
    super.sorting = sorting;
  }

  String? id;
  String? channelId;
  String? conversationType;
  String? cursor;
  RecentConversationMemberNodes? recentConversationMemberNodes;

  @override
  String getPrimaryKey() {
    return cursor!;
  }

  @override
  RecentConversationMemberEdge? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationMemberEdge(
        channelId: dynamicData["channelId"] == null
            ? null
            : dynamicData["channelId"] as String,
        conversationType:
            dynamicData["q"] == null ? null : dynamicData["q"] as String,
        cursor: dynamicData["cursor"] == null
            ? null
            : dynamicData["cursor"] as String,
        recentConversationMemberNodes:
            RecentConversationMemberNodes().fromMap(dynamicData["node"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationMemberEdge? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["cursor"] = object.cursor;
      data["node"] = object.recentConversationMemberNodes != null
          ? RecentConversationMemberNodes()
              .toMap(object.recentConversationMemberNodes!)
          : null;
      data["sorting"] = object.sorting;
      data["channelId"] = object.channelId;
      data["q"] = object.conversationType;
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationMemberEdge>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationMemberEdge> basketList =
        <RecentConversationMemberEdge>[];
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
  List<Map<String, dynamic>>? toMapList(
      List<RecentConversationMemberEdge>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationMemberEdge data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.cursor as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<dynamic>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamList = <String>[];
    if (mapList != null) {
      for (final dynamic clientInfo in mapList) {
        if (RecentConversationMemberEdge()
                .toMap(clientInfo as RecentConversationMemberEdge)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.id as String);
        }
      }
    }
    return filterParamList;
  }

  Map toJson() {
    final Map data = {};
    data["cursor"] = cursor;
    data["node"] = recentConversationMemberNodes != null
        ? RecentConversationMemberNodes().toMap(recentConversationMemberNodes!)
        : null;
    data["sorting"] = sorting;
    data["channelId"] = channelId;
    data["q"] = conversationType;
    data["id"] = id;
    return data;
  }
}
