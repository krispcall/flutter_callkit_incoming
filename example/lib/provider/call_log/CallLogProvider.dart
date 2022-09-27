/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 7:52 AM
 *
 */

import "dart:async";
import "dart:convert";

import "package:graphql/client.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";

class CallLogProvider extends Provider {
  CallLogProvider({
    required this.callLogRepository,
    int limit = 20,
  }) : super(callLogRepository!, limit) {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerCallLogs =
        StreamController<Resources<List<RecentConversationEdges>>>.broadcast();
    subscriptionCallLogs = streamControllerCallLogs!.stream
        .listen((Resources<List<RecentConversationEdges>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _callLogs = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CallLogRepository? callLogRepository;
  ValueHolder? valueHolder;
  String? callLogType;

  StreamController<Resources<List<RecentConversationEdges>>>?
      streamControllerCallLogs;
  StreamSubscription<Resources<List<RecentConversationEdges>>>?
      subscriptionCallLogs;

  Resources<List<RecentConversationEdges>>? _callLogs =
      Resources<List<RecentConversationEdges>>(
          Status.PROGRESS_LOADING, "", null);

  Resources<List<RecentConversationEdges>>? get callLogs => _callLogs;

  @override
  void dispose() {
    subscriptionCallLogs!.cancel();
    streamControllerCallLogs!.close();
    isDispose = true;
    super.dispose();
  }

  Future<Resources<List<RecentConversationEdges>>> doGetCallLogsAndPinnedConversationLogsApiCall(String callLogType) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    this.callLogType = callLogType;
    try {
      _callLogs = await callLogRepository!.doGetCallLogsAndPinnedConversationLogsApiCall(
            getDefaultChannel().id,
            streamControllerCallLogs!,
            callLogType,
            limit,
            isConnectedToInternet,
            Status.PROGRESS_LOADING,
          );
    } catch (_) {
      _callLogs =  Resources<List<RecentConversationEdges>>(Status.PROGRESS_LOADING, "", []);
    }
    return _callLogs!;
  }


  Future<Resources<List<RecentConversationEdges>>>
      doSearchGetCallLogsAndPinnedConversationLogsApiCall(
          String callLogType, String controllerSearch) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    this.callLogType = callLogType;
    try {
      _callLogs = await callLogRepository!
              .doSearchGetCallLogsAndPinnedConversationLogsApiCall(
                  getDefaultChannel().id,
                  streamControllerCallLogs!,
                  callLogType,
                  limit,
                  isConnectedToInternet,
                  Status.PROGRESS_LOADING,
                  controllerSearch) as Resources<List<RecentConversationEdges>>;
    } catch (_) {
    _callLogs =  Resources<List<RecentConversationEdges>>(Status.SUCCESS, "", []);
    }
    return _callLogs!;
  }

  Future<Resources<List<RecentConversationEdges>>> doNextCallLogsApiCall(
      String callLogType) async {
    _callLogs = Resources<List<RecentConversationEdges>>(
        Status.PROGRESS_LOADING, "", _callLogs!.data);
    streamControllerCallLogs!.add(_callLogs!);
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final Resources<List<RecentConversationEdges>> resources =
        await callLogRepository!.doNextCallLogsApiCall(getDefaultChannel().id!,
            callLogType, limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    if (resources.status == Status.SUCCESS) {
      if (resources.data != null && resources.data!.isNotEmpty) {
        _callLogs!.data!.addAll(
          resources.data!
              .where((element) =>
                  element.recentConversationNodes != null &&
                  !element.recentConversationNodes!.contactPinned!)
              .toList(),
        );

        streamControllerCallLogs!.add(Resources<List<RecentConversationEdges>>(
            Status.SUCCESS, "", _callLogs!.data));
        return _callLogs!;
      } else {
        streamControllerCallLogs!.add(Resources<List<RecentConversationEdges>>(
            Status.SUCCESS, "", _callLogs!.data));
        return _callLogs!;
      }
    } else {
      streamControllerCallLogs!.add(Resources<List<RecentConversationEdges>>(
          Status.SUCCESS, "", _callLogs!.data));
      return _callLogs!;
    }
  }

  Future<dynamic> doContactPinUnpinApiCall(
      ContactPinUnpinRequestHolder params) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return callLogRepository!.doContactPinUnpinApiCall(
        params, limit, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<dynamic> getAllCallLogsFromDb(
      String channelId, String callLogType) async {
    final Resources<List<RecentConversationEdges>> result =
        await callLogRepository!.getAllCallLogsFromDb(channelId, callLogType);
    _callLogs!.data!.clear();
    _callLogs!.data!.addAll(result.data!);
    streamControllerCallLogs!.sink.add(_callLogs!);
    return _callLogs!.data!;
  }

  ///Subscription data update for call logs and conversation detail
  Future<dynamic> doUpdateSubscriptionCallLogs(
      String type, RecentConversationNodes recentConversationNodes) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return callLogRepository!.updateSubscriptionCallLogs(
      type,
      recentConversationNodes,
      streamControllerCallLogs!,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  /// Global Subscription for call logs and conversation detail
  Future<Stream<QueryResult>?> doSubscriptionCallLogsApiCall(
      String type, String? channelId) async {
    isLoading = false;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Stream<QueryResult>? data =
        await callLogRepository!.doSubscriptionCallLogsApiCall(
      type,
      channelId,
      isConnectedToInternet,
    );

    return data;
  }

  void doEmptyCallLogsOnChannelChanged() {
    if (!streamControllerCallLogs!.isClosed) {
      streamControllerCallLogs!.sink.add(Resources(Status.SUCCESS, "", null));
    }
  }

  CountryCode getDefaultCountryCode() {
    final CountryCode countryCode = CountryCode.fromJson(
        json.decode(callLogRepository!.getDefaultCountryCode())
            as Map<String, dynamic>);
    return countryCode;
  }
}
