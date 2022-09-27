import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/memberLogin/MemberLoginData.dart";

class MemberLogin extends Object<MemberLogin> {
  MemberLogin({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  MemberLoginData? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MemberLogin? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberLogin(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: MemberLoginData().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberLogin? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = MemberLoginData().toMap(object.data!);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberLogin>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MemberLogin> login = <MemberLogin>[];

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
  List<Map<String, dynamic>>? toMapList(List<MemberLogin>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MemberLogin data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
