import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/transfer/TransferResponse.dart";
import "package:mvp/viewObject/model/transfer/TransferResponseData.dart";

class CallTransferRepository extends Repository {
  CallTransferRepository({required ApiService service}) {
    apiService = service;
  }

  ApiService? apiService;

  Future<Resources<TransferResponseData>> callTransfer(
      String direction,
      String callerId,
      String destination,
      bool isConnectedToInternet,
      Status status,
      {String? conversationId,
      String? conversationSid}) async {
    {
      final Resources<TransferResponse> resource =
          await apiService!.transferCall(direction == "Incoming"
              ? Map.from({
                  "data": {
                    "direction": direction,
                    "conversation_sid": conversationSid,
                    "callerId": callerId,
                    "destination": destination,
                    "externalNumber": false,
                    "by_sid": true,
                  }
                })
              : Map.from({
                  "data": {
                    "direction": direction,
                    "conversationId": conversationId,
                    "callerId": callerId,
                    "destination": destination,
                    "externalNumber": false,
                  }
                }));

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.transferResponseData!.error == null) {
          Utils.showToastMessage(
              resource.data!.transferResponseData!.transferStatus!.transfer!);
          return Resources(
              Status.SUCCESS, "", resource.data!.transferResponseData);
        } else {
          Utils.showToastMessage(
              resource.data!.transferResponseData!.error!.message!);
          return Resources(Status.ERROR,
              resource.data!.transferResponseData!.error!.message, null);
        }
      } else {
        Utils.showToastMessage(Utils.getString("Transfer Failed"));
        return Resources(
            Status.ERROR, Utils.getString("Transfer Failed"), null);
      }
    }
  }
}
