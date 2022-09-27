import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSetting.dart";

class UserNotificationSettingResponseData
    extends Object<UserNotificationSettingResponseData> {
  UserNotificationSettingResponseData({
    this.status,
    this.notificationSetting,
    this.error,
  });

  int? status;
  UserNotificationSetting? notificationSetting;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserNotificationSettingResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserNotificationSettingResponseData(
        status: dynamicData["status"] == null? null : dynamicData["status"] as int,
        notificationSetting:
            UserNotificationSetting().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserNotificationSettingResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] =
          UserNotificationSetting().toMap(object.notificationSetting);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserNotificationSettingResponseData>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UserNotificationSettingResponseData> login =
        <UserNotificationSettingResponseData>[];
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
      List<UserNotificationSettingResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserNotificationSettingResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
