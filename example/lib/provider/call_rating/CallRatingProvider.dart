import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/Common/CallRatingRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/callRating/CallRatingResponse.dart";

class CallRatingProvider extends Provider {
  CallRatingProvider({CallRatingRepository? callRatingRepository})
      : super(callRatingRepository!, 0) {
    repository = callRatingRepository;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
  }

  CallRatingRepository? repository;

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  Future<Resources<CallRatingResponse>> callRating({
    int? rating,
    String? conversationId,
    String? conversationSid,
  }) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<CallRatingResponse> dump = await repository!.callRating(
      rating!,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
      conversationId: conversationId ?? "",
      conversationSid: conversationSid ?? "",
    );

    return dump;
  }
}
