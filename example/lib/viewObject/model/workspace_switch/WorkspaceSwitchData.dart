import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";

class WorkspaceSwitchData extends Object<WorkspaceSwitchData> {
  WorkspaceSwitchData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  UserProfileData? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceSwitchData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceSwitchData(
        status: dynamicData["status"] == null?null:dynamicData["status"] as int,
        data: UserProfileData().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceSwitchData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = UserProfileData().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<WorkspaceSwitchData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceSwitchData> login = <WorkspaceSwitchData>[];

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
  List<Map<String, dynamic>>? toMapList(List<WorkspaceSwitchData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceSwitchData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
