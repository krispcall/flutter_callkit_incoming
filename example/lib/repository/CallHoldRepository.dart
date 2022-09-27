import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/callHold/CallHoldResponse.dart";
import "package:mvp/viewObject/model/callHold/CallHoldResponseData.dart";

class CallHoldRepository extends Repository {
  CallHoldRepository({required ApiService service}) {
    apiService = service;
  }

  ApiService? apiService;

  Future<Resources<CallHoldResponseData>> callHold(
      String action,
      String direction,
      String channelId,
      bool isConnectedToInternet,
      Status status,
      {String? conversationId,
      bool? bySid,
      String? conversationSid}) async {
    {
      final Resources<CallHoldResponse> resource =
          await apiService!.callHold(direction == "INBOUND"
              ? Map.from({
                  "data": {
                    "action": action,
                    "direction": direction,
                    "conversation_sid": conversationSid,
                    "by_sid": bySid,
                    "channel_id": channelId,
                  }
                })
              : Map.from({
                  "data": {
                    "action": action,
                    "direction": direction,
                    "conversation_id": conversationId,
                    "channel_id": channelId,
                  }
                }));
      print("this is inbound data ${{
        "data": {
          "action": action,
          "direction": direction,
          "conversation_sid": conversationSid,
          "by_sid": bySid,
          "channel_id": channelId,
        }
      }}");

      print(
          "this is hold response ${CallHoldResponseData().toMap(resource.data!.callHoldResponseData)}");

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.callHoldResponseData!.error == null) {
          // Utils.showToastMessage(
          //     action == "UNHOLD" ? "Call unhold." : "Call hold.");
          return Resources(
              Status.SUCCESS, "", resource.data!.callHoldResponseData);
        } else {
          Utils.showToastMessage(
              action == "UNHOLD" ? "Unhold failed." : "Hold failed.");
          return Resources(Status.ERROR, "Fail", null);
        }
      } else {
        Utils.showToastMessage(
            action == "UNHOLD" ? "Unhold failed." : "Hold failed.");
        return Resources(Status.ERROR, Utils.getString("Fail"), null);
      }
    }
  }
}
