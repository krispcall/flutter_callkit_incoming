import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceData.dart";

class Workspace extends Object<Workspace> {
  Workspace({
    this.workspace,
    this.id,
  });

  late WorkspaceData? workspace;
  late String? id;

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Workspace? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Workspace(
        workspace: WorkspaceData().fromMap(dynamicData["workspace"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Workspace? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["workspace"] = WorkspaceData().toMap(object.workspace!);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Workspace>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Workspace> userData = <Workspace>[];
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
  List<Map<String, dynamic>>? toMapList(List<Workspace>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Workspace data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
