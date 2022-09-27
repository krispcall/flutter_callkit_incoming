import "dart:async";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/updateUserNotificationSettingParameterHolder/UpdateUserNotificationSettingParameterHolder.dart";
import "package:mvp/viewObject/model/updateUserNotificationSetting/UpdateUserNotificationSettingResponse.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSetting.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSettingResponse.dart";

class NotificationRepository extends Repository {
  NotificationRepository({required ApiService service}) {
    apiService = service;
  }
  ApiService? apiService;

  Future<dynamic> doGetUserNotificationSetting(
      StreamController<Resources<UserNotificationSetting>>
          streamControllerUserNotificationSetting,
      int limit,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<UserNotificationSettingResponse> resource =
          await apiService!.doGetUserNotificationSettingApiCall();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.userNotificationSettingResponseData!.error == null) {
          streamControllerUserNotificationSetting.sink.add(Resources(
              Status.SUCCESS,
              "",
              resource.data!.userNotificationSettingResponseData!
                  .notificationSetting));
          return Resources(
              Status.SUCCESS,
              "",
              resource.data!.userNotificationSettingResponseData!
                  .notificationSetting);
        } else {
          return Resources(
              Status.ERROR,
              resource.data!.userNotificationSettingResponseData!.error!.message,
              null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doUpdateUserNotificationSetting(
      UpdateUserNotificationSettingParameterHolder param,
      StreamController<Resources<UserNotificationSetting>>
          streamControllerUserNotificationSetting,
      int limit,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<UpdateUserNotificationSettingResponse> resource =
          await apiService!.doUpdateUserNotificationSettingApiCall(param);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.userNotificationSettingResponseData!.error == null) {
          streamControllerUserNotificationSetting.sink.add(Resources(
              Status.SUCCESS,
              "",
              resource.data!.userNotificationSettingResponseData!
                  .notificationSetting));
          return Resources(
              Status.SUCCESS,
              "",
              resource.data!.userNotificationSettingResponseData!
                  .notificationSetting);
        } else {
          return Resources(
              Status.ERROR,
              resource.data!.userNotificationSettingResponseData!.error!.message,
              null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }
}
