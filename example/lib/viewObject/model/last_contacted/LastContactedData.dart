import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class LastContactedData<T> extends Object<LastContactedData<T>> {
  LastContactedData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Map<String, dynamic>? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LastContactedData<T>? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LastContactedData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: dynamicData["data"] == null
            ? null
            : dynamicData["data"] as Map<String, dynamic>,
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LastContactedData<T>? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = object.data;
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LastContactedData<T>>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LastContactedData> login = <LastContactedData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login as List<LastContactedData<T>>;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<LastContactedData<T>>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LastContactedData data in objectList) {
        mapList.add(toMap(data as LastContactedData<T>)!);
      }
    }
    return mapList;
  }
}
