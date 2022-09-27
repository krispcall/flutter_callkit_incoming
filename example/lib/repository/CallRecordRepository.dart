import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/recording/CallRecordResponse.dart";

class CallRecordRepository extends Repository {
  CallRecordRepository({required ApiService service}) {
    apiService = service;
  }

  ApiService? apiService;

  Future<Resources<CallRecordResponse>> callRecord(String action,
      String direction, bool isConnectedToInternet, Status isloading,
      {String? conversationId, String? conversationSid}) async {
    {
      final Resources<CallRecordResponse> resource =
          await apiService!.callRecord(Map.from(
              // {"action": action, "call_sid": callSid, "direction": direction}));
              direction == "INBOUND"
                  ? Map.from({
                      "action": action,
                      "conversation_sid": conversationSid,
                      "by_sid": true,
                    })
                  : Map.from({
                      "action": action,
                      "conversationId": conversationId,
                    })));
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.callRecord!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR, resource.data!.callRecord!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), resource.data);
      }
    }
  }
}
