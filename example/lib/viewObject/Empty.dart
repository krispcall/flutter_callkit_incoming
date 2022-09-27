import "package:mvp/viewObject/common/MapObject.dart";
import "package:quiver/core.dart";

class Empty extends MapObject<Empty> {
  Empty({
    this.code,
    this.message,
  });

  String? code;
  String? message;

  @override
  bool operator ==(dynamic other) => other is Empty && code == other.code;

  @override
  int get hashCode {
    return hash2(code.hashCode, code.hashCode);
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  Empty? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Empty(
        code: dynamicData["code"].toString(),
        message: dynamicData["message"].toString(),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Empty? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["code"] = object.code;
      data["message"] = object.message;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Empty>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Empty> basketList = <Empty>[];

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
  List<Map<String, dynamic>>? toMapList(List<Empty>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Empty data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(List<Empty>? mapList, var key, var value) {
    // TODO: implement getIdByKeyValue
    throw UnimplementedError();
  }
}
