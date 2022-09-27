import "package:mvp/viewObject/common/Object.dart";

class Dnd extends Object<Dnd> {
  Dnd({
    this.dndEnabled,
    this.dndEndtime,
    this.dndRemainingTime,
  });

  bool? dndEnabled;
  int? dndEndtime;
  int? dndRemainingTime;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  Dnd? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Dnd(
          dndEnabled: dynamicData["dndEnabled"] == null
              ? null
              : dynamicData["dndEnabled"] as bool,
          dndEndtime: dynamicData["dndEndtime"] == null
              ? null
              : dynamicData["dndEndtime"] as int,
          dndRemainingTime: dynamicData["dndRemainingTime"] == null
              ? null
              : dynamicData["dndRemainingTime"] as int);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Dnd? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["dndEnabled"] = object.dndEnabled;
      data["dndEndtime"] = object.dndEndtime;
      data["dndRemainingTime"] = object.dndRemainingTime;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Dnd>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Dnd> userData = <Dnd>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData)!);
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Dnd>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Dnd data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
