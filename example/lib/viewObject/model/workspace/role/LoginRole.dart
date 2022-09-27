import "package:mvp/viewObject/common/Object.dart";

class LoginRole extends Object<LoginRole> {
  LoginRole({
    this.role,
  });

  String? role;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LoginRole? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginRole(
        role:
            dynamicData["role"] == null ? null : dynamicData["role"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginRole? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["role"] = object.role;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginRole>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginRole> userData = <LoginRole>[];
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
  List<Map<String, dynamic>>? toMapList(List<LoginRole>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginRole data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
