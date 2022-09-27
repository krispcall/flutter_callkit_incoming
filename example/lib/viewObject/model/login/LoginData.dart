import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/login/LoginDataDetails.dart";

class LoginData extends Object<LoginData> {
  LoginData({
    this.token,
    this.details,
    this.intercomIdentity,
  });

  String? token;
  LoginDataDetails? details;
  String? intercomIdentity;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LoginData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginData(
        token: dynamicData["token"] == null
            ? null
            : dynamicData["token"] as String,
        details: LoginDataDetails().fromMap(dynamicData["details"]),
        intercomIdentity: dynamicData["intercomIdentity"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["token"] = object.token;
      data["details"] = LoginDataDetails().toMap(object.details!);
      data["intercomIdentity"] = object.intercomIdentity;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginData> data = <LoginData>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<LoginData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
