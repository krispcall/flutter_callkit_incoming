import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";

class RemoveMacrosData extends Object<RemoveMacrosData> {
  RemoveMacrosData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  Macro? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  RemoveMacrosData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RemoveMacrosData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: Macro().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(RemoveMacrosData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Macro().toMap(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RemoveMacrosData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RemoveMacrosData> login = <RemoveMacrosData>[];
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
  List<Map<String, dynamic>>? toMapList(List<RemoveMacrosData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final RemoveMacrosData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}