import "package:mvp/viewObject/common/Object.dart";

class ResponseError extends Object<ResponseError> {
  ResponseError({
    this.code,
    this.message,
    this.errorKey,
  });

  int? code;
  String? message;
  String? errorKey;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ResponseError? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ResponseError(
        code: dynamicData["code"] == null ? null : dynamicData["code"] as int,
        message: dynamicData["message"] == null
            ? null
            : dynamicData["message"] as String,
        errorKey: dynamicData["errorKey"] == null
            ? null
            : dynamicData["errorKey"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ResponseError? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["code"] = object.code;
      data["message"] = object.message;
      data["errorKey"] = object.errorKey;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ResponseError>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ResponseError> error = <ResponseError>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          error.add(fromMap(dynamicData)!);
        }
      }
    }
    return error;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ResponseError>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ResponseError data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
