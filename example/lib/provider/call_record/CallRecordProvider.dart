import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/CallRecordRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/recording/CallRecordResponse.dart";

class CallRecordProvider extends Provider {
  CallRecordProvider({required CallRecordRepository callRecordRepository})
      : super(callRecordRepository, 0) {
    repository = callRecordRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CallRecordRepository? repository;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<CallRecordResponse>> callRecord(
      {String? action,
      String? direction,
      String? conversationId,
      String? conversationSid}) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return repository!.callRecord(
        action!, direction!, isConnectedToInternet, Status.PROGRESS_LOADING,
        conversationSid: conversationSid ?? "",
        conversationId: conversationId ?? "");
  }
}
