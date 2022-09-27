import "dart:async";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/Common/NotificationRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/updateUserNotificationSettingParameterHolder/UpdateUserNotificationSettingParameterHolder.dart";
import "package:mvp/viewObject/model/userNotificationSetting/UserNotificationSetting.dart";

class NotificationProvider extends Provider {
  NotificationProvider(
      {required NotificationRepository repo,
      required this.valueHolder,
      int limit = 0})
      : super(repo, limit) {
    notificationRepository = repo;

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    streamControllerUserNotificationSetting =
        StreamController<Resources<UserNotificationSetting>>.broadcast();
    subscriptionUserNotificationSetting =
        streamControllerUserNotificationSetting!.stream
            .listen((Resources<UserNotificationSetting> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _userNotificationSetting = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  NotificationRepository? notificationRepository;
  ValueHolder? valueHolder;

  StreamController<Resources<UserNotificationSetting>>?
      streamControllerUserNotificationSetting;
  StreamSubscription<Resources<UserNotificationSetting>>?
      subscriptionUserNotificationSetting;

  Resources<UserNotificationSetting> _userNotificationSetting =
      Resources<UserNotificationSetting>(Status.NO_ACTION, "", null);

  Resources<UserNotificationSetting>? get userNotificationSetting =>
      _userNotificationSetting;

  @override
  void dispose() {
    streamControllerUserNotificationSetting!.close();
    subscriptionUserNotificationSetting!.cancel();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetUserNotificationSetting() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return notificationRepository!.doGetUserNotificationSetting(
      streamControllerUserNotificationSetting!,
      limit,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  Future<dynamic> doUpdateUserNotificationSetting(
      UpdateUserNotificationSettingParameterHolder param) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return notificationRepository!.doUpdateUserNotificationSetting(
      param,
      streamControllerUserNotificationSetting!,
      limit,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }
}
