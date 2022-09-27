import "package:mvp/viewObject/common/Object.dart";

class ForgotPassword extends Object<ForgotPassword> {
  ForgotPassword({
    this.message,
    this.code,
  });

  String? message;
  String? code;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  ForgotPassword? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ForgotPassword(
        message: dynamicData["message"] == null
            ? null
            : dynamicData["message"] as String,
        code:
            dynamicData["code"] == null ? null : dynamicData["code"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ForgotPassword? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["message"] = object.message;
      data["code"] = object.code;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ForgotPassword>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ForgotPassword> login = <ForgotPassword>[];
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
  List<Map<String, dynamic>>? toMapList(List<ForgotPassword>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ForgotPassword data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
