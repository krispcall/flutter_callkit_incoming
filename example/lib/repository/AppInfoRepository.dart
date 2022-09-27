import "dart:async";
import "dart:io";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/viewObject/model/appInfo/AppInfo.dart";
import "package:mvp/viewObject/model/appInfo/AppVersion.dart";

class AppInfoRepository extends Repository {
  AppInfoRepository({required this.apiService}) : super();

  ApiService? apiService;

  Future<Resources<AppVersion>> doVersionApiCall(
      {bool isLoadFromServer = true}) async {
    final Resources<AppInfo> resource = await apiService!
        .doVersionApiCall(Platform.isAndroid ? "android" : "ios");
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.appRegisterInfo!.error != null) {
        return Resources(Status.SUCCESS,
            resource.data!.appRegisterInfo!.error!.message, null);
      } else {
        return Resources(
            Status.SUCCESS, "", resource.data!.appRegisterInfo!.appVersion);
      }
    } else {
      final AppVersion appInfo = AppVersion(
        versionForceUpdate: false,
        versionNeedClearData: false,
        versionNo: Config.appVersion,
      );
      return Resources(Status.SUCCESS, "", appInfo);
    }
  }
}
