import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class RecentConversationSenderMember
    extends Object<RecentConversationSenderMember> {
  RecentConversationSenderMember(
      {this.id, this.firstName, this.lastName, this.picture});

  String? id;
  String? firstName;
  String? lastName;
  String? picture;

  @override
  bool operator ==(dynamic other) =>
      other is RecentConversationSenderMember && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  RecentConversationSenderMember? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecentConversationSenderMember(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        firstName: dynamicData["firstName"] == null
            ? null
            : dynamicData["firstName"] as String,
        lastName: dynamicData["lastName"] == null
            ? null
            : dynamicData["lastName"] as String,
        picture: dynamicData["picture"] == null
            ? null
            : dynamicData["picture"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RecentConversationSenderMember? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["firstName"] = object.firstName;
      data["lastName"] = object.lastName;
      data["picture"] = object.picture;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecentConversationSenderMember>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<RecentConversationSenderMember> basketList =
        <RecentConversationSenderMember>[];

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
      List<RecentConversationSenderMember>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RecentConversationSenderMember data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  Map toJson() {
    final Map data = {};
    data["id"] = id;
    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["picture"] = picture;
    return data;
  }
}
