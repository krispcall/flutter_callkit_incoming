import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/refreshToken/RefreshToken.dart";

class RefreshTokenResponseData extends Object<RefreshTokenResponseData> {
  RefreshTokenResponseData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  RefreshToken? data;
  ResponseError? error;

  @override
  String ?getPrimaryKey() {
    return "";
  }

  @override
  RefreshTokenResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RefreshTokenResponseData(
        status: dynamicData["status"] == null? null :dynamicData["status"] as int,
        data: RefreshToken().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RefreshTokenResponseData ?object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = RefreshToken().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RefreshTokenResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RefreshTokenResponseData> login = <RefreshTokenResponseData>[];

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
      List<RefreshTokenResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RefreshTokenResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
