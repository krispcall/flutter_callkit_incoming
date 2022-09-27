import "package:mvp/viewObject/common/Object.dart";

class PlanDetail extends Object<PlanDetail> {
  PlanDetail({
    this.title,
    this.interval,
  });

  String? title;
  String? interval;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  PlanDetail? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PlanDetail(
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        interval: dynamicData["interval"] == null
            ? null
            : dynamicData["title"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(PlanDetail? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["title"] = object.title;
      data["interval"] = object.interval;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PlanDetail>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PlanDetail> userData = <PlanDetail>[];
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
  List<Map<String, dynamic>>? toMapList(List<PlanDetail>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final PlanDetail data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
