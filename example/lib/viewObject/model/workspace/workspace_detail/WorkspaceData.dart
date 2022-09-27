import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";

class WorkspaceData extends Object<WorkspaceData> {
  WorkspaceData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  LoginWorkspace? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceData(
        status: dynamicData["status"]==null?null:dynamicData["status"] as int,
        data: LoginWorkspace().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = LoginWorkspace().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceData> login = <WorkspaceData>[];

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
  List<Map<String, dynamic>>? toMapList(List<WorkspaceData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
