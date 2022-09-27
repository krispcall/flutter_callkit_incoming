import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/macros/list/MacrosData.dart";

class MacrosResponse extends Object<MacrosResponse> {
  MacrosData? macros;

  MacrosResponse({this.macros});

  @override
  MacrosResponse? fromMap(dynamic dynamic) {
    return MacrosResponse(
        macros: dynamic["macros"] != null
            ? MacrosData().fromMap(dynamic["macros"])
            : null);
  }

  Map<String, dynamic>? toMap(MacrosResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.macros != null) {
      data["macros"] = MacrosData().toMap(object.macros);
    }
    return data;
  }

  @override
  List<MacrosResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<MacrosResponse> list = <MacrosResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<MacrosResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as MacrosResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
