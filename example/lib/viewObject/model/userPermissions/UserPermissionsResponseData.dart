import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissions.dart";

class UserPermissionsResponseData extends Object<UserPermissionsResponseData> {
  UserPermissionsResponseData({
    this.status,
    this.userPermissions,
    this.error,
  });

  int? status;
  UserPermissions? userPermissions;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserPermissionsResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserPermissionsResponseData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        userPermissions: UserPermissions().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserPermissionsResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = UserPermissions().toMap(object.userPermissions);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserPermissionsResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UserPermissionsResponseData> login =
        <UserPermissionsResponseData>[];
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
      List<UserPermissionsResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserPermissionsResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
