import "dart:async";

import "package:graphql/client.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationSeenRequestParamHolder/ConversationSeenRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestContentHolder.dart";
import "package:mvp/viewObject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:mvp/viewObject/model/sendMessage/Messages.dart";

class MessageDetailsProvider extends Provider {
  MessageDetailsProvider({
    required this.messageDetailsRepository,
    int limit = 0,
  }) : super(messageDetailsRepository!, limit) {
    isDispose = false;

    streamControllerConversation = StreamController<
        Resources<List<MessageDetailsObjectWithType>>>.broadcast();

    subscriptionConversation = streamControllerConversation!.stream
        .listen((Resources<List<MessageDetailsObjectWithType>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _listConversationDetails = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerRecordingConversation =
        StreamController<Resources<List<RecentConversationEdges>>>.broadcast();

    subscriptionRecordingConversation = streamControllerRecordingConversation!
        .stream
        .listen((Resources<List<RecentConversationEdges>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _listRecordingConversationDetails = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerSearchConversation =
        StreamController<Resources<List<RecentConversationEdges>>>.broadcast();

    subscriptionSearchConversation = streamControllerSearchConversation!.stream
        .listen((Resources<List<RecentConversationEdges>> resource) {
      _listSearchConversation = resource;
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

  MessageDetailsRepository? messageDetailsRepository;

  StreamController<Resources<List<MessageDetailsObjectWithType>>>?
      streamControllerConversation;
  StreamSubscription<Resources<List<MessageDetailsObjectWithType>>>?
      subscriptionConversation;

  Resources<List<MessageDetailsObjectWithType>> _listConversationDetails =
      Resources<List<MessageDetailsObjectWithType>>(Status.NO_ACTION, "", null);

  Resources<List<MessageDetailsObjectWithType>>? get listConversationDetails =>
      _listConversationDetails;

  StreamController<Resources<List<RecentConversationEdges>>>?
      streamControllerRecordingConversation;
  StreamSubscription<Resources<List<RecentConversationEdges>>>?
      subscriptionRecordingConversation;

  Resources<List<RecentConversationEdges>> _listRecordingConversationDetails =
      Resources<List<RecentConversationEdges>>(Status.NO_ACTION, "", null);

  Resources<List<RecentConversationEdges>>?
      get listRecordingConversationDetails => _listRecordingConversationDetails;

  StreamController<Resources<List<RecentConversationEdges>>>?
      streamControllerSearchConversation;
  StreamSubscription<Resources<List<RecentConversationEdges>>>?
      subscriptionSearchConversation;

  Resources<List<RecentConversationEdges>> _listSearchConversation =
      Resources<List<RecentConversationEdges>>(Status.NO_ACTION, "", null);

  Resources<List<RecentConversationEdges>>? get listSearchConversation =>
      _listSearchConversation;

  StreamController<Resources<int>>? streamControllerLengthDiff;
  StreamSubscription<Resources<int>>? subscriptionLengthDiff;

  Resources<int>? _lengthDiff = Resources<int>(Status.NO_ACTION, "", null);

  Resources<int>? get lengthDiff => _lengthDiff;

  StreamController<Resources<PageInfo>>? streamControllerPageInfo;
  StreamSubscription<Resources<PageInfo>>? subscriptionPageInfo;

  Resources<PageInfo>? _pageInfo =
      Resources<PageInfo>(Status.NO_ACTION, "", null);

  Resources<PageInfo>? get pageInfo => _pageInfo;

  @override
  void dispose() {
    subscriptionConversation!.cancel();
    streamControllerConversation!.close();

    subscriptionRecordingConversation!.cancel();
    streamControllerRecordingConversation!.close();

    subscriptionSearchConversation!.cancel();
    streamControllerSearchConversation!.close();

    streamControllerLengthDiff!.close();
    subscriptionLengthDiff!.cancel();

    streamControllerPageInfo!.close();
    subscriptionPageInfo!.cancel();

    isDispose = true;
    super.dispose();
  }

  /*For search data page*/
  Future<Resources<List<MessageDetailsObjectWithType>>>
      doConversationDetailByContactApiCall(
          String? channelId, String? clientNumber) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<MessageDetailsObjectWithType>> response =
        await messageDetailsRepository!.doConversationDetailByContactApiCall(
      channelId,
      clientNumber,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );
    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerConversation!.sink.add(response);
    } else {
      streamControllerConversation!.sink.add(Resources(Status.ERROR, '', []));
    }
    return response;
  }

  /*get initial search conversation*/
  Future<Resources<List<RecentConversationEdges>>> doSearchConversationApiCall(
      SearchConversationRequestHolder searchConversationRequestHolder) async {
    streamControllerSearchConversation!.sink
        .add(Resources(Status.PROGRESS_LOADING, "", []));

    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<RecentConversationEdges>> response =
        await messageDetailsRepository!.doSearchConversationApiCall(
      isConnectedToInternet,
      searchConversationRequestHolder,
    );
    streamControllerSearchConversation!.sink.add(response);
    return response;
  }

  Future<dynamic> doMessageChatListUpperApiCall(
      String? channelId, String clientNumber) async {
    Utils.cPrint("On Refresh");
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MessageDetailsObjectWithType>> response =
        await messageDetailsRepository!.doMessageChatListUpperApiCall(
      channelId,
      clientNumber,
      pageInfo!.data!,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );

    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerConversation!.sink.add(response);
    }
    return response.data;
  }

  Future<List<MessageDetailsObjectWithType>> doMessageChatListLowerApiCall(
      String? channelId, String clientNumber, int currLength) async {
    Utils.cPrint("On Refresh");
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MessageDetailsObjectWithType>> response =
        await messageDetailsRepository!.doMessageChatListLowerApiCall(
      channelId,
      clientNumber,
      currLength,
      pageInfo!.data!,
      streamControllerLengthDiff!,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );

    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerConversation!.sink.add(response);
    }

    return response.data!;
  }

  /*get initial search conversation for the list  in detail*/
  Future<Resources<List<MessageDetailsObjectWithType>>>
      doSearchConversationWithCursorApiCall(
          String channelId, String clientNumber) async {
    super.isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<MessageDetailsObjectWithType>> response =
        await messageDetailsRepository!.doSearchConversationWithCursorApiCall(
      channelId,
      clientNumber,
      streamControllerPageInfo!,
      isConnectedToInternet,
    );
    if (response.data != null && response.data!.isNotEmpty) {
      streamControllerConversation!.sink.add(response);
    }

    return response;
  }

  Future<Resources<Messages>> doSendMessageApiCall(
      String channelId, String text, String id) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return messageDetailsRepository!.doSendMessageApiCall(
      SendMessageRequestHolder(
          conversationType: "Message",
          channel: channelId,
          contact: id,
          content: SendMessageRequestContentHolder(body: text)),
      isConnectedToInternet,
    );
  }

  Future<dynamic> updateSubscriptionConversationDetail(
    String channelId,
    String clientNumber,
    RecentConversationNodes recentConversationNodes,
    bool isSearching,
  ) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<MessageDetailsObjectWithType>> resources =
        await messageDetailsRepository!.doUpdateSubscriptionConversationDetail(
      channelId,
      clientNumber,
      pageInfo!.data!,
      recentConversationNodes,
      streamControllerPageInfo!,
      isSearching,
    );
    if (!streamControllerConversation!.isClosed) {
      streamControllerConversation!.sink.add(resources);
    }
  }

  Future<Stream<QueryResult>?> doSubscriptionConversationChatApiCall(
      String type, String? channelId) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      return messageDetailsRepository!.doSubscriptionConversationChatApiCall(
        type,
        channelId,
        isConnectedToInternet,
      );
    } else {
      return null;
    }
  }

  Future<Resources<bool>> doConversationSeenApiCall(
      String? channelId, String? contactId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final ConversationSeenRequestParamHolder
        conversationSeenRequestParamHolder = ConversationSeenRequestParamHolder(
      channel: channelId,
      contact: contactId,
    );
    final Resources<bool> resources =
        await messageDetailsRepository!.doConversationSeenApiCall(
      conversationSeenRequestParamHolder,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
    return resources;
  }

  Future<Resources<List<RecentConversationEdges>>>
      doGetNextSearchedConversationApiCall(
    String channelId,
    String contactNumber,
    String searchQuery,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<RecentConversationEdges>> response =
        await messageDetailsRepository!.doGetNextSearchedConversationApiCall(
      channelId,
      isConnectedToInternet,
      searchQuery,
      contactNumber,
    );
    _listSearchConversation.data!.addAll(response.data!);
    streamControllerSearchConversation!.sink.add(_listSearchConversation);
    return response;
  }

  Future<int> getSearchIndex(String channelId, RecentConversationEdges item,
      String clientNumber) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    return messageDetailsRepository!.getSearchIndex(
      channelId,
      item,
      clientNumber,
      isConnectedToInternet,
    );
  }
}
