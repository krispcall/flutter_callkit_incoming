import "package:mvp/viewObject/common/Object.dart";

class PlanRestrictionData extends Object<PlanRestrictionData> {
  final dynamic? hasAccess;
  final String? featureGroup;
  final String? valueType;

  PlanRestrictionData({this.hasAccess, this.featureGroup, this.valueType});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  PlanRestrictionData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PlanRestrictionData(
        hasAccess: dynamicData["has_access"] == null
            ? null
            : dynamicData["has_access"] as bool,
        featureGroup: dynamicData["feature_group"] == null
            ? null
            : dynamicData["feature_group"] as String,
        valueType: dynamicData["value_type"] == null
            ? null
            : dynamicData["value_type"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(PlanRestrictionData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["has_access"] = object.hasAccess;
      data["feature_group"] = object.featureGroup;
      data["value_type"] = object.valueType;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PlanRestrictionData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PlanRestrictionData> listMessages = <PlanRestrictionData>[];

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
          dynamicList.add(toMap(data as PlanRestrictionData)!);
        }
      }
    }
    return dynamicList;
  }
}
