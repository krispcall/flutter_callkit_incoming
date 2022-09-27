import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/CallHoldRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/callHold/CallHoldResponseData.dart";

class CallHoldProvider extends Provider {
  CallHoldProvider({required CallHoldRepository callHoldRepository})
      : super(callHoldRepository, 0) {
    repository = callHoldRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CallHoldRepository? repository;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<CallHoldResponseData>> callHold(
      {String? action,
      String? direction,
      String? channelId,
      String? conversationId,
      String? conversationSid}) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return repository!.callHold(action!, direction!, channelId!,
        isConnectedToInternet, Status.PROGRESS_LOADING,
        bySid: direction == "INBOUND" ? true : false,
        conversationId: conversationId ?? "",
        conversationSid: conversationSid ?? "");
  }
}
