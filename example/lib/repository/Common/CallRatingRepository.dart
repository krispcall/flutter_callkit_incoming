import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/callRating/CallRatingResponse.dart";

class CallRatingRepository extends Repository {
  CallRatingRepository({required ApiService service}) {
    apiService = service;
  }

  ApiService? apiService;

  Future<Resources<CallRatingResponse>> callRating(
      int rating, bool isConnectedToInternet, Status status,
      {String? conversationId, String? conversationSid}) async {
    {
      final Resources<CallRatingResponse> resource =
          await apiService!.doCallRatingApiCall({
        "id": conversationId,
        "data": {"rating": rating}
      });

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR, Utils.getString("serverError"), null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }
}
