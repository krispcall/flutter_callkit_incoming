import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListData.dart";

class WorkspaceListResponse extends Object<WorkspaceListResponse> {
  WorkspaceListResponse({
    this.data,
  });

  WorkspaceListData? data;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceListResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceListResponse(
        data: WorkspaceListData().fromMap(dynamicData["workspaces"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceListResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["workspaces"] = WorkspaceListData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceListResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceListResponse> login = <WorkspaceListResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<WorkspaceListResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceListResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
