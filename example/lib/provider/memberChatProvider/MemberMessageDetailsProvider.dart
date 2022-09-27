import "dart:async";

import "package:graphql/client.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/MemberMessageDetailsRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/memberChatRequestParamHolder/MemberChatRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessage.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";

class MemberMessageDetailsProvider extends Provider {
  MemberMessageDetailsProvider(
      {this.memberMessageDetailsRepository, int limit = 0})
      : super(memberMessageDetailsRepository!, limit) {
    streamControllerMemberEdges =
        StreamController<Resources<List<MemberEdges>>>.broadcast();
    subscriptionMemberEdges = streamControllerMemberEdges!.stream
        .listen((Resources<List<MemberEdges>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _memberEdges = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerMemberConversation = StreamController<
        Resources<List<MemberMessageDetailsObjectWithType>>>.broadcast();

    subscriptionMemberConversation = streamControllerMemberConversation!.stream
        .listen((Resources<List<MemberMessageDetailsObjectWithType>> resource) {
      _listMemberConversationDetails = resource;
      isLoading = false;
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerSearchMemberConversation = StreamController<
        Resources<List<RecentConversationMemberEdge>>>.broadcast();

    subscriptionSearchMemberConversation =
        streamControllerSearchMemberConversation!.stream
            .listen((Resources<List<RecentConversationMemberEdge>> resource) {
      _listSearchMemberConversation = resource;
      isLoading = false;
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerLengthDiff = StreamController<Resources<int>>.broadcast();

    subscriptionLengthDiff =
        streamControllerLengthDiff!.stream.listen((Resources<int> resource) {
      _lengthDiff = resource;
      isLoading = false;
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerPageInfo =
        StreamController<Resources<PageInfo>>.broadcast();

    subscriptionPageInfo =
        streamControllerPageInfo!.stream.listen((Resources<PageInfo> resource) {
      _pageInfo = resource;
      isLoading = false;
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  MemberMessageDetailsRepository? memberMessageDetailsRepository;

  StreamController<Resources<List<MemberMessageDetailsObjectWithType>>>?
      streamControllerMemberConversation;
  StreamSubscription<Resources<List<MemberMessageDetailsObjectWithType>>>?
      subscriptionMemberConversation;

  Resources<List<MemberMessageDetailsObjectWithType>>?
      _listMemberConversationDetails =
      Resources<List<MemberMessageDetailsObjectWithType>>(
          Status.NO_ACTION, "", null);

  Resources<List<MemberMessageDetailsObjectWithType>>?
      get listMemberConversationDetails => _listMemberConversationDetails;

  StreamController<Resources<List<MemberEdges>>>? streamControllerMemberEdges;
  StreamSubscription<Resources<List<MemberEdges>>>? subscriptionMemberEdges;

  Resources<List<MemberEdges>> _memberEdges =
      Resources<List<MemberEdges>>(Status.NO_ACTION, "", null);

  Resources<List<MemberEdges>>? get memberEdges => _memberEdges;

  StreamController<Resources<List<RecentConversationMemberEdge>>>?
      streamControllerSearchMemberConversation;
  StreamSubscription<Resources<List<RecentConversationMemberEdge>>>?
      subscriptionSearchMemberConversation;

  Resources<List<RecentConversationMemberEdge>> _listSearchMemberConversation =
      Resources<List<RecentConversationMemberEdge>>(Status.NO_ACTION, "", null);

  Resources<List<RecentConversationMemberEdge>>?
      get listSearchMemberConversation => _listSearchMemberConversation;

  StreamController<Resources<int>>? streamControllerLengthDiff;
  StreamSubscription<Resources<int>>? subscriptionLengthDiff;

  Resources<int>? _lengthDiff = Resources<int>(Status.NO_ACTION, "", null);

  Resources<int>? get lengthDiff => _lengthDiff;

  StreamController<Resources<PageInfo>> ?streamControllerPageInfo;
  StreamSubscription<Resources<PageInfo>>? subscriptionPageInfo;

  Resources<PageInfo> _pageInfo =
      Resources<PageInfo>(Status.NO_ACTION, "", null);

  Resources<PageInfo>? get pageInfo => _pageInfo;

  @override
  void dispose() {
    streamControllerMemberConversation!.close();
    subscriptionMemberConversation!.cancel();

    streamControllerMemberEdges!.close();
    subscriptionMemberEdges!.cancel();

    streamControllerSearchMemberConversation!.close();
    subscriptionSearchMemberConversation!.cancel();

    streamControllerLengthDiff!.close();
    subscriptionLengthDiff!.cancel();

    streamControllerPageInfo!.close();
    subscriptionPageInfo!.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doConversationDetailByMemberApiCall(String senderId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<MemberMessageDetailsObjectWithType>> response =
        await memberMessageDetailsRepository!
            .doConversationDetailByMemberApiCall(
      senderId,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );
    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerMemberConversation!.sink.add(response);
    }
    return response;
  }

  Future<List<MemberMessageDetailsObjectWithType>> doMemberChatListUpperApiCall(
      String senderId) async {
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MemberMessageDetailsObjectWithType>> response =
        await memberMessageDetailsRepository!.doMemberChatListUpperApiCall(
      senderId,
      pageInfo!.data!,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );

    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerMemberConversation!.sink.add(response);
    }
    return response.data!;
  }

  Future<List<MemberMessageDetailsObjectWithType>> doMemberChatListLowerApiCall(
      String memberId, int currLength) async {
    Utils.cPrint("On Loading");
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MemberMessageDetailsObjectWithType>> response =
        await memberMessageDetailsRepository!.doMemberChatListLowerApiCall(
      memberId,
      currLength,
      pageInfo!.data!,
      streamControllerLengthDiff!,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );

    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerMemberConversation!.sink.add(response);
    }

    return response.data!;
  }

  Future<dynamic> updateSubscriptionMemberChatConversationDetail(
    String memberId,
    String senderId,
    RecentConversationMemberNodes recentConversationMemberNodes,
    bool isSearching,
  ) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MemberMessageDetailsObjectWithType>> resources =
        await memberMessageDetailsRepository!.doUpdateSubscriptionMemberChat(
      memberId,
      senderId,
      pageInfo!.data!,
      recentConversationMemberNodes,
      streamControllerPageInfo!,
      isSearching,
    );
    if (!streamControllerMemberConversation!.isClosed) {
      streamControllerMemberConversation!.sink.add(resources);
    }
  }

  Future<Stream<QueryResult<dynamic>>?>
      doSubscriptionWorkspaceChatDetail() async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      return memberMessageDetailsRepository!.doSubscriptionWorkspaceChatDetail();
    } else {
      return null;
    }
  }

  Future<Resources<CreateChatMessage>> doSendChatMessageApiCall(
      String text, String id) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    Utils.cPrint(streamControllerMemberConversation!.isClosed.toString());
    return memberMessageDetailsRepository!.doSendChatMessageApiCall(
      {
        "data": {
          "message": text,
          "receiver": id,
        }
      },
      isConnectedToInternet,
    );
  }

  Future<Resources<List<RecentConversationMemberEdge>>>
      doSearchConversationApiCall(
          MemberChatRequestHolder memberChatRequestHolder) async {
    streamControllerSearchMemberConversation!.sink
        .add(Resources(Status.PROGRESS_LOADING, "", []));
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<RecentConversationMemberEdge>> response =
        await memberMessageDetailsRepository!.doSearchConversationApiCall(
      isConnectedToInternet,
      memberChatRequestHolder,
    );
    streamControllerSearchMemberConversation!.sink.add(response);
    return response;
  }

  Future<Resources<List<RecentConversationMemberEdge>>>
      doNextSearchConversationApiCall(
    String searchQueryController,
    String memberId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<RecentConversationMemberEdge>> response =
        await memberMessageDetailsRepository!.doNextSearchConversationApiCall(
      isConnectedToInternet,
      searchQueryController,
      memberId,
    );
    _listSearchMemberConversation.data!.addAll(response.data!);
    streamControllerSearchMemberConversation!.sink
        .add(_listSearchMemberConversation);
    return response;
  }

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doSearchConversationWithCursorApiCall(String senderId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<MemberMessageDetailsObjectWithType>> response =
        await memberMessageDetailsRepository!
            .doSearchConversationWithCursorApiCall(
      senderId,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );
    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerMemberConversation!.sink.add(response);
    }

    return response;
  }

  Future<int> getSearchIndex(
      RecentConversationMemberEdge item, String senderId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return memberMessageDetailsRepository!.getSearchIndex(
      item,
      senderId,
      isConnectedToInternet,
    );
  }
}
