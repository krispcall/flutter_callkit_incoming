import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/AppInfoRepository.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/appInfo/AppInfo.dart";
import "package:mvp/viewObject/model/appInfo/AppVersion.dart";

class AppInfoProvider extends Provider {
  AppInfoProvider({this.repository, this.valueHolder, int limit = 0})
      : super(repository!, limit);

  AppInfoRepository? repository;
  ValueHolder? valueHolder;

  final Resources<AppInfo> appInfo =
      Resources<AppInfo>(Status.NO_ACTION, "", null);

  Resources<AppInfo> get categoryList => appInfo;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<AppVersion>> doVersionApiCall() async {
    isLoading = true;

    final Resources<AppVersion> psAppInfo =
        await repository!.doVersionApiCall();

    return psAppInfo;
  }
}
