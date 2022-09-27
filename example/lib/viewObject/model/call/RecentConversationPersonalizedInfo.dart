import "package:mvp/viewObject/common/MapObject.dart";
import "package:quiver/core.dart";

class RecentConversationPersonalizedInfo
    extends MapObject<RecentConversationPersonalizedInfo> {
  RecentConversationPersonalizedInfo({
    this.pinned,
    this.seen,
    this.favourite,
    // this.dndMissed,
    this.reject,
  });

  bool? pinned;
  bool? seen;
  bool? favourite;
  // bool dndMissed;
  bool? reject;

  @override
  bool operator ==(dynamic other) =>
      other is RecentConversationPersonalizedInfo && pinned == other.pinned;

  @override
  int get hashCode {
    return hash2(pinned.hashCode, pinned.hashCode);
  }

  @override
  String getPrimaryKey() {
    return "id";
  }

  @override
  RecentConversationPersonalizedInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationPersonalizedInfo(
        pinned: dynamicData["pinned"] == null
            ? null
            : dynamicData["pinned"] as bool,
        seen: dynamicData["seen"] == null ? null : dynamicData["seen"] as bool,
        favourite: dynamicData["favourite"] == null
            ? null
            : dynamicData["favourite"] as bool,
        // dndMissed: dynamicData["dndMissed"] as bool,
        reject: dynamicData["reject"] == null
            ? null
            : dynamicData["reject"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationPersonalizedInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["pinned"] = object.pinned;
      data["seen"] = object.seen;
      data["favourite"] = object.favourite;
      // data["dndMissed"] = object.dndMissed;
      data["reject"] = object.reject;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationPersonalizedInfo>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationPersonalizedInfo> basketList =
        <RecentConversationPersonalizedInfo>[];
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
      List<RecentConversationPersonalizedInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationPersonalizedInfo data in objectList) {
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
        if (RecentConversationPersonalizedInfo().toMap(
                clientInfo as RecentConversationPersonalizedInfo)!["$key"] ==
            value) {
          filterParamlist.add(clientInfo.getPrimaryKey());
        }
      }
    }
    return filterParamlist;
  }
}
