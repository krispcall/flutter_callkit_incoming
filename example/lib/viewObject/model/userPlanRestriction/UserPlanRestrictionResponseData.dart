import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";

class UserPlanRestrictionResponseData
    extends Object<UserPlanRestrictionResponseData> {
  UserPlanRestrictionResponseData({
    this.status,
    this.planRestriction,
    this.error,
  });

  int? status;
  PlanRestriction? planRestriction;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserPlanRestrictionResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserPlanRestrictionResponseData(
        status: dynamicData["status"]==null?null:dynamicData["status"] as int,
        planRestriction: PlanRestriction().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserPlanRestrictionResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = PlanRestriction().toMap(object.planRestriction);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserPlanRestrictionResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UserPlanRestrictionResponseData> login =
        <UserPlanRestrictionResponseData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<UserPlanRestrictionResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserPlanRestrictionResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
