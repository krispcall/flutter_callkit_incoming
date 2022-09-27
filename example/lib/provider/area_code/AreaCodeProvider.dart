import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/AreaCodeRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";

class AreaCodeProvider extends Provider {
  AreaCodeProvider({AreaCodeRepository? areaCodeRepository})
      : super(areaCodeRepository!, 0) {
    repository = areaCodeRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  AreaCodeRepository? repository;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<AreaCode>> getAllAreaCodes() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<AreaCode> data = await repository!
        .getAllAreaCodes(isConnectedToInternet, Status.PROGRESS_LOADING);
    return data;
  }
}
