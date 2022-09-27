import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/model/call/ClientDNDInfo.dart";
import "package:quiver/core.dart";

class RecentConversationClientInfo
    extends MapObject<RecentConversationClientInfo> {
  RecentConversationClientInfo({
    this.id,
    this.name,
    this.country,
    this.createdBy,
    this.profilePicture,
    this.number,
    this.blocked,
    this.dndInfo,
  });

  String? id;
  String? name;
  String? country;
  String? createdBy;
  String? profilePicture;
  String? number;
  bool? blocked;
  bool? dndEnabled;
  int? dndDuration;
  int? dndEndtime;
  ClientDNDInfo? dndInfo;

  @override
  bool operator ==(dynamic other) =>
      other is RecentConversationClientInfo && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  RecentConversationClientInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationClientInfo(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        country: dynamicData["country"] == null
            ? null
            : dynamicData["country"] as String,
        createdBy: dynamicData["createdBy"] == null
            ? null
            : dynamicData["createdBy"] as String,
        profilePicture: dynamicData["profilePicture"] == null
            ? null
            : dynamicData["profilePicture"] as String,
        number: dynamicData["number"] == null
            ? null
            : dynamicData["number"] as String,
        blocked: dynamicData["blocked"] == null
            ? null
            : dynamicData["blocked"] as bool,
        dndInfo: dynamicData["dndInfo"] != null
            ? ClientDNDInfo().fromMap(dynamicData["dndInfo"])
            : null,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationClientInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["name"] = object.name;
      data["country"] = object.country;
      data["createdBy"] = object.createdBy;
      data["profilePicture"] = object.profilePicture;
      data["number"] = object.number;
      data["blocked"] = object.blocked;
      data["dndInfo"] =
          object.dndInfo != null ? ClientDNDInfo().toMap(object.dndInfo) : null;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationClientInfo>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationClientInfo> basketList =
        <RecentConversationClientInfo>[];
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
      List<RecentConversationClientInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationClientInfo data in objectList) {
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
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<dynamic>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamlist = <String>[];
    if (mapList != null) {
      for (final dynamic clientInfo in mapList) {
        if (RecentConversationClientInfo()
                .toMap(clientInfo as RecentConversationClientInfo)!["$key"] ==
            value) {
          filterParamlist.add(clientInfo.id as String);
        }
      }
    }
    return filterParamlist;
  }
}
