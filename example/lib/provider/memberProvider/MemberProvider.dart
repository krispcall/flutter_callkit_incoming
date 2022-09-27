import "dart:async";

import "package:graphql/client.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/members/MemberData.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";

class MemberProvider extends Provider {
  MemberProvider({this.memberRepository, int limit = 0})
      : super(memberRepository!, limit) {
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

  MemberRepository? memberRepository;

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

  StreamController<Resources<PageInfo>>? streamControllerPageInfo;
  StreamSubscription<Resources<PageInfo>>? subscriptionPageInfo;

  Resources<PageInfo>? _pageInfo =
      Resources<PageInfo>(Status.NO_ACTION, "", null);

  Resources<PageInfo>? get pageInfo => _pageInfo;

  @override
  void dispose() {
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

  Future<dynamic> doGetAllWorkspaceMembersApiCall(String memberId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _memberEdges = await memberRepository!.doGetAllWorkspaceMembersApiCall(
      memberId,
      streamControllerMemberEdges!,
      isConnectedToInternet,
      1000000000,
      Status.PROGRESS_LOADING,
    );
    return _memberEdges;
  }

  Future<dynamic> doEmptyMemberOnChannelChanged() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    streamControllerMemberEdges!.sink.add(Resources(Status.SUCCESS, "", null));

    return null;
  }

  Future<dynamic> getAllMembersFromDb(String memberId) async {
    final Resources<MemberData>? result =
        await memberRepository!.getAllMembersFromDb(memberId);
    _memberEdges.data!.clear();
    _memberEdges.data!.addAll(result!.data!.memberEdges!);
    streamControllerMemberEdges!.sink.add(_memberEdges);
    return _memberEdges.data;
  }

  Future<dynamic> doSearchMemberFromDb(String memberId, String query) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final List<MemberEdges> result = await memberRepository!
        .doSearchMemberFromDb(memberId, query, isConnectedToInternet, limit,
            Status.PROGRESS_LOADING) as List<MemberEdges>;
    if (result.isNotEmpty) {
      if (memberEdges!.data != null) {
        _memberEdges.data!.clear();
        _memberEdges.data!.addAll(result);
      } else {
        _memberEdges = Resources(Status.SUCCESS, "", result);
      }
      streamControllerMemberEdges!.sink.add(_memberEdges);
      return _memberEdges.data;
    } else {
      streamControllerMemberEdges!.sink
          .add(Resources(Status.SUCCESS, "", <MemberEdges>[]));
      return _memberEdges.data;
    }
  }

  Future<dynamic> updateSubscriptionMemberOnline(
      MemberStatus memberStatus, String workspace, String memberId) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return memberRepository!.updateSubscriptionMemberOnline(
      memberStatus,
      streamControllerMemberEdges!,
      memberId,
    );
  }

  Future<Stream<QueryResult>?> doSubscriptionOnlineMemberStatus(
      String workspaceId, String memberId) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      return memberRepository!.doSubscriptionOnlineMemberStatus(
        workspaceId,
        memberId,
        Status.PROGRESS_LOADING,
      );
    } else {
      return null;
    }
  }

  Future<dynamic> updateSubscriptionMemberChatDetail(String memberId,
      RecentConversationMemberNodes recentConversationMemberNodes) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return memberRepository!.doUpdateSubscriptionMemberChatDetail(
      memberId,
      recentConversationMemberNodes,
      streamControllerMemberEdges!,
    );
  }

  Future<Stream<QueryResult<dynamic>>?>
      doSubscriptionWorkspaceChatDetail() async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      return memberRepository!.doSubscriptionWorkspaceChatDetail();
    } else {
      return null;
    }
  }

  Future<dynamic> doEditMemberChatSeenApiCall(
      String memberId, String senderId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return memberRepository!.doEditMemberChatSeenApiCall(
      memberId,
      senderId,
      streamControllerMemberEdges!,
      {"senderId": senderId},
      isConnectedToInternet,
    );
  }
}
