import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";

class MacrosData extends Object<MacrosData> {
  MacrosData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  List<Macro>? data;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MacrosData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MacrosData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: Macro().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MacrosData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Macro().toMapList(object.data);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MacrosData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MacrosData> login = <MacrosData>[];
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
  List<Map<String, dynamic>>? toMapList(List<MacrosData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final MacrosData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
