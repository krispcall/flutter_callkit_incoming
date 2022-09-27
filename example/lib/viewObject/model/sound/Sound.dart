import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class Sound extends Object<Sound> {
  Sound({
    this.id,
    this.name,
    this.assetUrl,
    this.fileName,
    this.isChecked,
  });

  final String? id;
  final String? name;
  final String? assetUrl;
  final String? fileName;
  bool? isChecked;

  @override
  bool operator ==(dynamic other) => other is Sound && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Sound? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Sound(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        assetUrl: dynamicData["assetUrl"] == null
            ? null
            : dynamicData["assetUrl"] as String,
        fileName: dynamicData["fileName"] == null
            ? null
            : dynamicData["fileName"] as String,
        isChecked: dynamicData["isChecked"] == null
            ? null
            : dynamicData["isChecked"] as bool,
      );
    } else {
      return null;
    }
  }

  Sound? fromJson(dynamic dynamicData) {
    if (dynamicData != null) {
      return Sound(
        id: dynamicData["id"] as String,
        name: dynamicData["name"] as String,
        assetUrl: dynamicData["assetUrl"] as String,
        fileName: dynamicData["fileName"] as String,
        isChecked: dynamicData["isChecked"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Sound? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["name"] = object.name;
      data["assetUrl"] = object.assetUrl;
      data["fileName"] = object.fileName;
      data["isChecked"] = object.isChecked;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["assetUrl"] = assetUrl;
    data["fileName"] = fileName;
    data["isChecked"] = isChecked;
    return data;
  }

  @override
  List<Sound>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Sound> commentList = <Sound>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData)!);
        }
      }
    }
    return commentList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Sound>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Sound data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }
}
