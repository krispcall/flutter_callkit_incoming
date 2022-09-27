import "package:mvp/viewObject/common/Object.dart";

class WorkspaceMember extends Object<WorkspaceMember> {
  WorkspaceMember({
    this.id,
    this.name,
    this.online,
    this.picture,
  });

  String? id;
  String? name;
  bool? online;
  String? picture;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceMember? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceMember(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        online: dynamicData["online"] == null
            ? null
            : dynamicData["online"] as bool,
        picture: dynamicData["picture"] == null
            ? null
            : dynamicData["picture"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceMember? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["name"] = object.name;
      data["online"] = object.online;
      data["picture"] = object.picture;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceMember>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceMember> userData = <WorkspaceMember>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData)!);
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<WorkspaceMember>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceMember data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
