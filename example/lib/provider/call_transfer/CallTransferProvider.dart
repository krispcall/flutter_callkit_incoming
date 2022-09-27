import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/CallTransferRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/transfer/TransferResponseData.dart";

class CallTransferProvider extends Provider {
  CallTransferProvider(
      {required CallTransferRepository callTransferRepository})
      : super(callTransferRepository, 0) {
    repository = callTransferRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CallTransferRepository? repository;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<TransferResponseData>> callTransfer(
      {String? direction,
      String? conversationId,
      String? callerId,
      String? destination,
      String? conversationSid}) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return repository!.callTransfer(direction!, callerId!, destination!,
        isConnectedToInternet, Status.PROGRESS_LOADING,
        conversationId: conversationId ?? "",
        conversationSid: conversationSid ?? "");
  }
}
