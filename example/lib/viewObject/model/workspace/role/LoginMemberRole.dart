import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/workspace/role/LoginRole.dart";

class LoginMemberRole extends Object<LoginMemberRole> {
  LoginMemberRole({
    this.loginRole,
  });

  LoginRole? loginRole;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LoginMemberRole? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginMemberRole(
        loginRole: LoginRole().fromMap(dynamicData["loginMemberRole"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginMemberRole? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["loginMemberRole"] = LoginRole().toMap(object.loginRole!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginMemberRole>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginMemberRole> login = <LoginMemberRole>[];
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
  List<Map<String, dynamic>>? toMapList(List<LoginMemberRole>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginMemberRole data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
