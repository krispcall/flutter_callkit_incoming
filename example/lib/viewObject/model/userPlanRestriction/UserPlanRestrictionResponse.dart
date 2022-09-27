import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPlanRestriction/UserPlanRestrictionResponseData.dart";

class UserPlanRestrictionResponse extends Object<UserPlanRestrictionResponse> {
  UserPlanRestrictionResponseData? userPlanRestrictionResponseData;

  UserPlanRestrictionResponse({this.userPlanRestrictionResponseData});

  @override
  UserPlanRestrictionResponse? fromMap(dynamic dynamic) {
    return UserPlanRestrictionResponse(
        userPlanRestrictionResponseData: dynamic["planRestrictionData"] != null
            ? UserPlanRestrictionResponseData()
                .fromMap(dynamic["planRestrictionData"])
            : null);
  }

  Map<String, dynamic>? toMap(UserPlanRestrictionResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.userPlanRestrictionResponseData != null) {
      data["planRestrictionData"] = UserPlanRestrictionResponseData()
          .toMap(object.userPlanRestrictionResponseData!);
    }
    return data;
  }

  @override
  List<UserPlanRestrictionResponse>? fromMapList(List<dynamic> ?dynamicDataList) {
    final List<UserPlanRestrictionResponse> list =
        <UserPlanRestrictionResponse>[];

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
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<UserPlanRestrictionResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as UserPlanRestrictionResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
