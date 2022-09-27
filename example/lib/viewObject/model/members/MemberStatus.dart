import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

enum ConversationType { Call, Message, VoiceMail }

class MemberStatus extends Object<MemberStatus> {
  MemberStatus({
    this.id,
    this.online,
  });

  String? id;
  bool? online;

  @override
  bool operator ==(dynamic other) => other is MemberStatus && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  MemberStatus? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberStatus(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        online: dynamicData["online"] == null
            ? null
            : dynamicData["online"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberStatus? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["online"] = object.online;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberStatus>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MemberStatus> basketList = <MemberStatus>[];

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
  List<Map<String, dynamic>>? toMapList(List<MemberStatus>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberStatus data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
