import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestrictionData.dart";

class PlanRestriction extends Object<PlanRestriction> {
  final PlanRestrictionData? callTransfer;
  final PlanRestrictionData? callRecordingsAndStorage;
  String? id;
  PlanRestriction({this.callTransfer, this.callRecordingsAndStorage, this.id});

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  PlanRestriction? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PlanRestriction(
        callTransfer: dynamicData["call-transfer"] != null
            ? PlanRestrictionData().fromMap(dynamicData["call-transfer"])
            : null,
        callRecordingsAndStorage:
            dynamicData["call-recordings-and-storage"] != null
                ? PlanRestrictionData()
                    .fromMap(dynamicData["call-recordings-and-storage"])
                : null,
        id: dynamicData["id"] != null ? dynamicData["id"] as String : "",
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(PlanRestriction? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["call-transfer"] = PlanRestrictionData().toMap(object.callTransfer!);
      data["call-recordings-and-storage"] =
          PlanRestrictionData().toMap(object.callRecordingsAndStorage!);
      data["id"] = object.id;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PlanRestriction>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PlanRestriction> listMessages = <PlanRestriction>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as PlanRestriction)!);
        }
      }
    }
    return dynamicList;
  }
}
