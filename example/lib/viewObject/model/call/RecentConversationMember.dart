import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";

class RecentConversationMember extends MapObject<RecentConversationMember> {
  RecentConversationMember({
    this.recentConversationMemberEdge,
    this.recentConversationPageInfo,
    this.id,
  }) {
    super.sorting = sorting;
  }

  List<RecentConversationMemberEdge>? recentConversationMemberEdge;
  PageInfo? recentConversationPageInfo;
  String? id;

  @override
  RecentConversationMember? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationMember(
          recentConversationPageInfo:
              PageInfo().fromMap(dynamicData["pageInfo"]),
          recentConversationMemberEdge: RecentConversationMemberEdge()
              .fromMapList(dynamicData["edges"] == null
                  ? null
                  : dynamicData["edges"] as List<dynamic>),
          id: dynamicData["id"] == null ? null : dynamicData["id"] as String);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationMember? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["pageInfo"] = PageInfo().toMap(object.recentConversationPageInfo);
      data["edges"] = object.recentConversationMemberEdge != null
          ? RecentConversationMemberEdge()
              .toMapList(object.recentConversationMemberEdge!)
          : null;
      data["sorting"] = object.sorting;
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationMember>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RecentConversationMember> basketList =
        <RecentConversationMember>[];
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
      List<RecentConversationMember>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationMember data in objectList) {
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
        if (RecentConversationMember()
                .toMap(clientInfo as RecentConversationMember)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.id as String);
        }
      }
    }
    return filterParamList;
  }

  @override
  String getPrimaryKey() {
    return id!;
  }
}

class AllMemberConversation extends MapObject<AllMemberConversation> {
  AllMemberConversation({
    this.recentConversationMember,
  }) {
    super.sorting = sorting;
  }

  List<RecentConversationMember>? recentConversationMember =
      <RecentConversationMember>[];

  @override
  AllMemberConversation? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllMemberConversation(
        recentConversationMember: RecentConversationMember().fromMapList(
            dynamicData["allMemberConversation"] == null
                ? null
                : dynamicData["allMemberConversation"] as List<dynamic>),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllMemberConversation? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["allMemberConversation"] = object.recentConversationMember != null
          ? RecentConversationMember()
              .toMapList(object.recentConversationMember)
          : null;
      data["sorting"] = object.sorting;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllMemberConversation>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllMemberConversation> basketList = <AllMemberConversation>[];
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
      List<AllMemberConversation>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllMemberConversation data in objectList) {
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
        if (AllMemberConversation()
                .toMap(clientInfo as AllMemberConversation)!["$key"] ==
            value) {
          filterParamList.add(clientInfo.getPrimaryKey());
        }
      }
    }
    return filterParamList;
  }

  @override
  String getPrimaryKey() {
    return "id";
  }
}
