import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class Tags extends Object<Tags> {
  Tags({
    this.id,
    this.title,
    this.colorCode,
    this.count,
    this.backgroundColorCode,
    this.check,
  });

  String? id;
  String? title;
  String? colorCode;
  int? count;
  String? backgroundColorCode;
  bool? check;

  @override
  bool operator ==(dynamic other) => other is Tags && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  Tags? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Tags(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        colorCode: dynamicData["colorCode"] == null
            ? null
            : dynamicData["colorCode"] as String,
        count:
            dynamicData["count"] == null ? null : dynamicData["count"] as int,
        backgroundColorCode: dynamicData["backgroundColorCode"] == null
            ? null
            : dynamicData["backgroundColorCode"] as String,
        check: false,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Tags? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["title"] = object.title;
      data["colorCode"] = object.colorCode;
      data["count"] = object.count;
      data["backgroundColorCode"] = object.backgroundColorCode;
      data["check"] = object.check;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Tags>? fromMapList(dynamic dynamicDataList) {
    final List<Tags> basketList = <Tags>[];

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
  List<Map<String, dynamic>>? toMapList(List<Tags>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Tags data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
