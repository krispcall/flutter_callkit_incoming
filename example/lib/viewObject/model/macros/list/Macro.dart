import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class Macro extends Object<Macro> {
  Macro({this.id, this.message, this.title, this.type});

  String? id;
  String? message;
  String? title;
  String? type;

  @override
  bool operator ==(dynamic other) => other is Macro && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Macro? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Macro(
          id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
          message: dynamicData["message"] == null
              ? null
              : dynamicData["message"] as String,
          title: dynamicData["title"] == null
              ? null
              : dynamicData["title"] as String,
          type: dynamicData["type"] == null
              ? null
              : dynamicData["type"] as String);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Macro? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["message"] = object.message;
      data["title"] = object.title;
      data["type"] = object.type;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Macro>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Macro> basketList = <Macro>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Macro>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Macro data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
