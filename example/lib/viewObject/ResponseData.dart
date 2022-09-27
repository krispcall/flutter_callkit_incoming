import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

//TODO TO BE DELETE DONT USE
class ResponseData<T> extends Object<ResponseData<T>> {
  ResponseData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  T? data;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ResponseData<T>? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ResponseData(
        status: dynamicData["status"] as int,
        data: dynamicData["data"] as T,
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ResponseData<T>? object) {
    // if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object!.status;
      data["data"] = object.data;
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    // } else {
    //   return null;
    // }
  }

  @override
  List<ResponseData<T>>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ResponseData> login = <ResponseData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login as List<ResponseData<T>>;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ResponseData<T>>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ResponseData data in objectList) {
        mapList.add(toMap(data as ResponseData<T>)!);
      }
    }
    return mapList;
  }
}
