import "package:mvp/viewObject/common/Object.dart";

class WorkspaceTeam extends Object<WorkspaceTeam> {
  WorkspaceTeam({
    this.id,
    this.name,
    this.online,
    this.total,
    this.picture,
  });

  String? id;
  String? name;
  int? online;
  int? total;
  String? picture;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceTeam? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceTeam(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        online:
            dynamicData["online"] == null ? null : dynamicData["online"] as int,
        total:
            dynamicData["total"] == null ? null : dynamicData["total"] as int,
        picture: dynamicData["picture"] == null
            ? null
            : dynamicData["picture"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceTeam? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["name"] = object.name;
      data["online"] = object.online;
      data["total"] = object.total;
      data["picture"] = object.picture;

      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceTeam>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceTeam> userData = <WorkspaceTeam>[];
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
  List<Map<String, dynamic>>? toMapList(List<WorkspaceTeam>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceTeam data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
