import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/macros/removeMacros/RemoveMacrosData.dart";

class RemoveMacros extends Object<RemoveMacros> {
  RemoveMacrosData? removeMacros;

  RemoveMacros({this.removeMacros});

  @override
  RemoveMacros? fromMap(dynamic dynamic) {
    return RemoveMacros(
        removeMacros: dynamic["removeMacros"] != null
            ? RemoveMacrosData().fromMap(dynamic["removeMacros"])
            : null);
  }

  Map<String, dynamic>? toMap(RemoveMacros? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.removeMacros != null) {
      data["removeMacros"] = RemoveMacrosData().toMap(object.removeMacros!);
    }
    return data;
  }

  @override
  List<RemoveMacros>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<RemoveMacros> list = <RemoveMacros>[];

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
  List<Map<String, dynamic>>? toMapList(List<RemoveMacros>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as RemoveMacros)!);
        }
      }
    }
    return dynamicList;
  }
}
