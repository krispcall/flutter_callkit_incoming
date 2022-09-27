import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";

class WorkspaceListData extends Object<WorkspaceListData> {
  WorkspaceListData({
    this.status,
    this.data,
    this.error,
    this.id,
  });

  int? status;
  List<LoginWorkspace>? data;
  ResponseError? error;
  String? id;

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  WorkspaceListData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceListData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data:
            LoginWorkspace().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceListData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = LoginWorkspace().toMapList(object.data);
      data["error"] = ResponseError().toMap(object.error);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceListData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceListData> login = <WorkspaceListData>[];
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
  List<Map<String, dynamic>>? toMapList(List<WorkspaceListData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceListData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
