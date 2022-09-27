import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/forgotPassword/ForgotPassword.dart";

class ForgotPasswordResponseData extends Object<ForgotPasswordResponseData> {
  ForgotPasswordResponseData({
    this.status,
    this.forgotPassword,
    this.error,
  });

  int? status;
  ForgotPassword? forgotPassword;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  ForgotPasswordResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ForgotPasswordResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        forgotPassword: ForgotPassword().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ForgotPasswordResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = ForgotPassword().toMap(object.forgotPassword);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ForgotPasswordResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<ForgotPasswordResponseData> login =
        <ForgotPasswordResponseData>[];
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
      List<ForgotPasswordResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ForgotPasswordResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
