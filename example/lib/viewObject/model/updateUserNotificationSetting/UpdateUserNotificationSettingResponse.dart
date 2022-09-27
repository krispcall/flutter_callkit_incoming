import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSettingResponseData.dart";

class UpdateUserNotificationSettingResponse
    extends Object<UpdateUserNotificationSettingResponse> {
  UserNotificationSettingResponseData? userNotificationSettingResponseData;

  UpdateUserNotificationSettingResponse(
      {this.userNotificationSettingResponseData});

  @override
  UpdateUserNotificationSettingResponse? fromMap(dynamic dynamic) {
    return UpdateUserNotificationSettingResponse(
        userNotificationSettingResponseData:
            dynamic["updateNotificationSettings"] != null
                ? UserNotificationSettingResponseData()
                    .fromMap(dynamic["updateNotificationSettings"])
                : null);
  }

  Map<String, dynamic>? toMap(UpdateUserNotificationSettingResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.userNotificationSettingResponseData != null) {
      data["updateNotificationSettings"] = UserNotificationSettingResponseData()
          .toMap(object.userNotificationSettingResponseData!);
    }
    return data;
  }

  @override
  List<UpdateUserNotificationSettingResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UpdateUserNotificationSettingResponse> list =
        <UpdateUserNotificationSettingResponse>[];

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
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<UpdateUserNotificationSettingResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList
              .add(toMap(data as UpdateUserNotificationSettingResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
