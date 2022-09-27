import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";

class AddMacrosData extends Object<AddMacrosData> {
  AddMacrosData({
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
  AddMacrosData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddMacrosData(
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
  Map<String, dynamic>? toMap(AddMacrosData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Macro().toMap(object.data!);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddMacrosData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddMacrosData> login = <AddMacrosData>[];
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
  List<Map<String, dynamic>>? toMapList(List<AddMacrosData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddMacrosData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
