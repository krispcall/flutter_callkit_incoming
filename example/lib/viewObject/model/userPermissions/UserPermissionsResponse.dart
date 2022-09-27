import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissionsResponseData.dart";

class UserPermissionsResponse extends Object<UserPermissionsResponse> {
  UserPermissionsResponseData? userPermissionsResponseData;

  UserPermissionsResponse({this.userPermissionsResponseData});

  @override
  UserPermissionsResponse? fromMap(dynamic dynamic) {
    return UserPermissionsResponse(
        userPermissionsResponseData: dynamic["permissions"] != null
            ? UserPermissionsResponseData().fromMap(dynamic["permissions"])
            : null);
  }

  Map<String, dynamic>? toMap(UserPermissionsResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.userPermissionsResponseData != null) {
      data["permissions"] = UserPermissionsResponseData()
          .toMap(object.userPermissionsResponseData!);
    }
    return data;
  }

  @override
  List<UserPermissionsResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserPermissionsResponse> list = <UserPermissionsResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<UserPermissionsResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as UserPermissionsResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
