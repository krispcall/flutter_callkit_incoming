import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/macros/addMacros/AddMacrosData.dart";

class AddMacrosResponse extends Object<AddMacrosResponse> {
  AddMacrosData? addMacros;

  AddMacrosResponse({this.addMacros});

  @override
  AddMacrosResponse? fromMap(dynamic dynamic) {
    return AddMacrosResponse(
        addMacros: dynamic["addMacros"] != null
            ? AddMacrosData().fromMap(dynamic["addMacros"])
            : null);
  }

  Map<String, dynamic>? toMap(AddMacrosResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.addMacros != null) {
      data["addMacros"] = AddMacrosData().toMap(object.addMacros);
    }
    return data;
  }

  @override
  List<AddMacrosResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddMacrosResponse> list = <AddMacrosResponse>[];

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
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<AddMacrosResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as AddMacrosResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
