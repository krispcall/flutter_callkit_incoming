import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSettingResponseData.dart";

class UserNotificationSettingResponse
    extends Object<UserNotificationSettingResponse> {
  UserNotificationSettingResponseData? userNotificationSettingResponseData;

  UserNotificationSettingResponse({this.userNotificationSettingResponseData});

  @override
  UserNotificationSettingResponse? fromMap(dynamic dynamic) {
    return UserNotificationSettingResponse(
        userNotificationSettingResponseData:
            dynamic["notificationSettings"] != null
                ? UserNotificationSettingResponseData()
                    .fromMap(dynamic["notificationSettings"])
                : null);
  }

  Map<String, dynamic>? toMap(UserNotificationSettingResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.userNotificationSettingResponseData != null) {
      data["notificationSettings"] = UserNotificationSettingResponseData()
          .toMap(object.userNotificationSettingResponseData!);
    }
    return data;
  }

  @override
  List<UserNotificationSettingResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UserNotificationSettingResponse> list =
        <UserNotificationSettingResponse>[];

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
      List<UserNotificationSettingResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as UserNotificationSettingResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
