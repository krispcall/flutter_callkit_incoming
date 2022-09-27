import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class CancelCallResponseData extends Object<CancelCallResponseData> {
  CancelCallResponseData({
    this.status,
    // this.data,
    this.error,
  });

  int? status;

  // String data;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CancelCallResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CancelCallResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        // data:dynamicData["data"],
        error: ResponseError().fromMap(dynamicData["errors"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CancelCallResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      // data["data"] = object.data;
      data["errors"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CancelCallResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CancelCallResponseData> da = <CancelCallResponseData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          da.add(fromMap(dynamicData)!);
        }
      }
    }
    return da;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<CancelCallResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CancelCallResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
