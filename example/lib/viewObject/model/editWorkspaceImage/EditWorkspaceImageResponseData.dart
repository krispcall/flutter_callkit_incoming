import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";

class EditWorkspaceImageResponseData
    extends Object<EditWorkspaceImageResponseData> {
  EditWorkspaceImageResponseData({
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
  EditWorkspaceImageResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditWorkspaceImageResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: LoginWorkspace().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(EditWorkspaceImageResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = LoginWorkspace().toMap(object.data!);
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<EditWorkspaceImageResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<EditWorkspaceImageResponseData> login =
        <EditWorkspaceImageResponseData>[];
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
  List<Map<String, dynamic>>? toMapList(
      List<EditWorkspaceImageResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final EditWorkspaceImageResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
