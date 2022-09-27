import "dart:async";

import "package:audioplayers/audioplayers.dart";
import "package:graphql/client.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/CallLogDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/common/SearchInputRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/contactPinUnpinRequestParamHolder/ContactPinUnpinRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/recentConversationRequestParamHolder/RecentConversationRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversation.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/call/RecentConversationResponse.dart";
import "package:mvp/viewObject/model/call/pinnedContact/PinnedConversationResponse.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:mvp/viewObject/model/pinContact/PinContactResponse.dart";
import "package:sembast/sembast.dart";

class CallLogRepository extends Repository {
  CallLogRepository({required this.apiService, required this.callLogDao});

  ApiService? apiService;
  CallLogDao? callLogDao;
  PageInfo? pageInfo;
  GraphQLClient? graphQLClient;

  Future<Resources<List<RecentConversationEdges>>>
      doGetCallLogsAndPinnedConversationLogsApiCall(
          String? channelId,
          StreamController<Resources<List<RecentConversationEdges>>>
              streamControllerCallLogs,
          String callLogType,
          int limit,
          bool isConnectedToInternet,
          Status status,
          {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      return Future.wait([
        apiService!.doPinnedCallLogsApiCall(
          RecentConversationRequestHolder(
            channel: channelId,
            param: SearchConversationRequestParamHolder(
              q: callLogType,
              first: 3,
            ),
          ),
        ),
        apiService!.doCallLogsApiCall(
          RecentConversationRequestHolder(
            channel: channelId,
            param: SearchConversationRequestParamHolder(
              q: callLogType,
              first: limit,
            ),
          ),
        ),
      ]).then(
        (v) {
          return mergedPinnedAndRecentConversation(
            streamControllerCallLogs,
            v[0] as Resources<PinnedConversationResponse>,
            v[1] as Resources<RecentConversationResponse>,
            callLogType,
            channelId,
          );
        },
        onError: (err) async {
          print(err.toString());
          final Resources<RecentConversation>? result =
              await callLogDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp("$callLogType$channelId", caseSensitive: false),
              ),
            ),
          );
          if (result == null || result.data == null) {
            sinkCallLogsStream(streamControllerCallLogs,
                Resources(Status.ERROR, "", <RecentConversationEdges>[]));
            return Resources(Status.ERROR, "", <RecentConversationEdges>[]);
          } else {
            sinkCallLogsStream(
                streamControllerCallLogs,
                Resources(
                    Status.SUCCESS, "", result.data!.recentConversationEdges));
            return Resources(
                Status.SUCCESS, "", result.data!.recentConversationEdges);
          }
        },
      );
    } else {
      final Resources<RecentConversation>? result = await callLogDao!.getOne(
          finder: Finder(
              filter: Filter.matchesRegExp("id",
                  RegExp(callLogType + channelId!, caseSensitive: false))));
      if (result?.data == null) {
        sinkCallLogsStream(streamControllerCallLogs,
            Resources(Status.ERROR, "", <RecentConversationEdges>[]));
        return Resources(Status.ERROR, "", <RecentConversationEdges>[]);
      } else {
        sinkCallLogsStream(
            streamControllerCallLogs,
            Resources(
                Status.SUCCESS, "", result?.data!.recentConversationEdges));
        return Resources(
            Status.SUCCESS, "", result?.data!.recentConversationEdges);
      }
    }
  }

  Future<dynamic> doSearchGetCallLogsAndPinnedConversationLogsApiCall(
      String? channelId,
      StreamController<Resources<List<RecentConversationEdges>>>
          streamControllerCallLogs,
      String callLogType,
      int limit,
      bool isConnectedToInternet,
      Status status,
      String controllerSearch,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      /// call pinned call logs and normal callogs and merge results
      RecentConversationRequestHolder search;
      if (controllerSearch.isNotEmpty) {
        search = RecentConversationRequestHolder(
          channel: channelId,
          param: SearchConversationRequestParamHolder(
            q: callLogType,
            first: limit,
            search: SearchInputRequestParamHolder(
              value: controllerSearch,
              columns: [],
            ),
          ),
        );
      } else {
        search = RecentConversationRequestHolder(
          channel: channelId,
          param: SearchConversationRequestParamHolder(
            q: callLogType,
            first: limit,
          ),
        );
      }
      final Resources<RecentConversationResponse> callLogsConversationList =
          await apiService!.doCallLogsApiCall(search);

      final List<RecentConversationEdges> listValueHolder = [];

      if (callLogsConversationList.data != null &&
          callLogsConversationList.data!.recentConversationData != null &&
          callLogsConversationList.data!.recentConversationData != null &&
          callLogsConversationList
                  .data!.recentConversationData!.recentConversation !=
              null &&
          callLogsConversationList.data!.recentConversationData!
                  .recentConversation!.recentConversationEdges !=
              null) {
        pageInfo = callLogsConversationList.data!.recentConversationData!
            .recentConversation!.recentConversationPageInfo;

        listValueHolder.addAll((callLogsConversationList
                .data!
                .recentConversationData!
                .recentConversation!
                .recentConversationEdges!
                .map((e) => e = RecentConversationEdges(
                    cursor: e.cursor,
                    channelId: channelId,
                    conversationType: callLogType,
                    recentConversationNodes: e.recentConversationNodes,
                    id: e.recentConversationNodes!.id,
                    check: false,
                    advancePlayDefault: false,
                    advancedPlayer: AudioPlayer()))
                .toList())
            .where((e) =>
                e.recentConversationNodes != null &&
                !e.recentConversationNodes!.contactPinned!)
            .toList());
      }
      sinkCallLogsStream(streamControllerCallLogs,
          Resources(Status.SUCCESS, "", listValueHolder));
    } else {
      final Resources<RecentConversation>? result = await callLogDao!.getOne(
          finder: Finder(
              filter: Filter.matchesRegExp("id",
                  RegExp("$callLogType$channelId", caseSensitive: false))));
      if (result?.data == null) {
        sinkCallLogsStream(streamControllerCallLogs,
            Resources(Status.ERROR, "", <RecentConversationEdges>[]));
      } else {
        sinkCallLogsStream(
            streamControllerCallLogs,
            Resources(
                Status.SUCCESS, "", result?.data!.recentConversationEdges));
      }
    }
  }

  Resources<List<RecentConversationEdges>> mergedPinnedAndRecentConversation(
      StreamController<Resources<List<RecentConversationEdges>>>
          streamControllerCallLogs,
      Resources<PinnedConversationResponse> pinnedConversationList,
      Resources<RecentConversationResponse> callLogsConversationList,
      String callLogType,
      String? channelId) {
    final List<RecentConversationEdges> listValueHolder = [];

    if (pinnedConversationList.data != null &&
        pinnedConversationList.data!.pinnedConversationData != null &&
        pinnedConversationList.data!.pinnedConversationData != null &&
        pinnedConversationList.data!.pinnedConversationData!.data != null &&
        pinnedConversationList.data!.pinnedConversationData!.data!.isNotEmpty) {
      for (final value
          in pinnedConversationList.data!.pinnedConversationData!.data!) {
        listValueHolder.add(
          RecentConversationEdges(
            cursor: "",
            channelId: channelId,
            conversationType: callLogType,
            recentConversationNodes: value,
            id: value.id,
            check: false,
            advancePlayDefault: false,
            advancedPlayer: AudioPlayer(),
          ),
        );
      }
    }

    /// this is for divider between pinned and unpinned
    if (listValueHolder.isNotEmpty) {
      listValueHolder.add(
        RecentConversationEdges(),
      );
    }

    if (callLogsConversationList.data != null &&
        callLogsConversationList.data!.recentConversationData != null &&
        callLogsConversationList.data!.recentConversationData != null &&
        callLogsConversationList
                .data!.recentConversationData!.recentConversation !=
            null &&
        callLogsConversationList.data!.recentConversationData!
                .recentConversation!.recentConversationEdges !=
            null) {
      pageInfo = callLogsConversationList.data!.recentConversationData!
          .recentConversation!.recentConversationPageInfo;

      listValueHolder.addAll((callLogsConversationList
              .data!
              .recentConversationData!
              .recentConversation!
              .recentConversationEdges!
              .map((e) => e = RecentConversationEdges(
                  cursor: e.cursor,
                  channelId: channelId,
                  conversationType: callLogType,
                  recentConversationNodes: e.recentConversationNodes,
                  id: e.recentConversationNodes!.id,
                  check: false,
                  advancePlayDefault: false,
                  advancedPlayer: AudioPlayer()))
              .toList())
          .where((e) =>
              e.recentConversationNodes != null &&
              !e.recentConversationNodes!.contactPinned!)
          .toList());
    }

    try {
      callLogDao!.deleteWithFinder(
        Finder(
          filter: Filter.matchesRegExp(
              "id", RegExp(callLogType + channelId!, caseSensitive: false)),
        ),
      );
      callLogDao!.insert(
        callLogType + channelId,
        RecentConversation(
          recentConversationPageInfo: pageInfo!,
          recentConversationEdges: listValueHolder,
          id: callLogType + channelId,
        ),
      );
    } catch (e) {
      Utils.cPrint(e.toString());
    }

    sinkCallLogsStream(streamControllerCallLogs,
        Resources(Status.SUCCESS, "", listValueHolder));
    return Resources(Status.SUCCESS, "", listValueHolder);
  }

  Future<Resources<List<RecentConversationEdges>>> doNextCallLogsApiCall(
      String channelId,
      String callLogType,
      int limit,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      if (pageInfo!.hasNextPage!) {
        final RecentConversationRequestHolder callLogParamHolder =
            RecentConversationRequestHolder(
          channel: channelId,
          param: SearchConversationRequestParamHolder(
            q: callLogType,
            first: limit,
            after: pageInfo!.endCursor,
          ),
        );

        final Resources<RecentConversationResponse> resource =
            await apiService!.doCallLogsApiCall(callLogParamHolder);
        if (resource.status == Status.SUCCESS) {
          if (resource.data!.recentConversationData!.error == null) {
            if (resource.data != null &&
                resource.data!.recentConversationData != null &&
                resource.data!.recentConversationData!.recentConversation !=
                    null) {
              if (resource.data!.recentConversationData!.recentConversation!
                      .recentConversationPageInfo !=
                  null) {
                pageInfo = resource.data!.recentConversationData!
                    .recentConversation!.recentConversationPageInfo;
                // pageInfo = PageInfo(
                //   startCursor: _resource
                //       .data
                //       .recentConversationData
                //       .recentConversation
                //       .recentConversationPageInfo
                //       .startCursor,
                //   hasPreviousPage: _resource
                //       .data
                //       .recentConversationData
                //       .recentConversation
                //       .recentConversationPageInfo
                //       .hasPreviousPage,
                //   endCursor: _resource.data.recentConversationData
                //       .recentConversation.recentConversationPageInfo.endCursor,
                //   hasNextPage: _resource
                //       .data
                //       .recentConversationData
                //       .recentConversation
                //       .recentConversationPageInfo
                //       .hasPreviousPage,
                // );
              }

              if (resource.data!.recentConversationData!.recentConversation!
                      .recentConversationEdges !=
                  null) {
                final List<RecentConversationEdges> list = resource
                    .data!
                    .recentConversationData!
                    .recentConversation!
                    .recentConversationEdges!
                    .map(
                      (e) => e = RecentConversationEdges(
                        cursor: e.cursor,
                        channelId: channelId,
                        conversationType: callLogType,
                        recentConversationNodes: e.recentConversationNodes,
                        id: e.recentConversationNodes!.id,
                        check: false,
                        advancePlayDefault: false,
                        advancedPlayer: AudioPlayer(),
                      ),
                    )
                    .toList();
                return Resources(Status.SUCCESS, "", list);
              } else {
                return Resources(Status.ERROR, "", null);
              }
            } else {
              return Resources(Status.ERROR, "", null);
            }
          } else {
            return Resources(Status.ERROR, "", null);
          }
        } else {
          return Resources(Status.ERROR, "", null);
        }
      } else {
        return Resources(Status.ERROR, "", null);
      }
    } else {
      return Resources(Status.ERROR, "", null);
    }
  }

  Future<dynamic> doContactPinUnpinApiCall(ContactPinUnpinRequestHolder params,
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<PinContactResponse> resource =
          await apiService!.doContactPinUnpinApiCall(params);
      Utils.cPrint("this is pinunpin ${resource.status}");
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.pinContactData!.error == null) {
          Utils.cPrint(
              "this is pinunpin inner ${Resources(Status.SUCCESS, "", resource.data!.pinContactData!.pinContact!.status)}");

          return Resources(Status.SUCCESS, "",
              resource.data!.pinContactData!.pinContact!.status);
        } else {
          return Resources(Status.ERROR,
              resource.data!.pinContactData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<Resources<List<RecentConversationEdges>>> getAllCallLogsFromDb(
      String channelId, String callLogType) async {
    final Resources<RecentConversation>? result = await callLogDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(callLogType + channelId, caseSensitive: false),
        ),
      ),
    );
    if (result == null) {
      return Resources(Status.SUCCESS, "", []);
    } else {
      return Resources(
          Status.SUCCESS, "", result.data!.recentConversationEdges);
    }
  }

  Future<dynamic> updateSubscriptionCallLogs(
      String type,
      RecentConversationNodes recentConversationNodes,
      StreamController<Resources<List<RecentConversationEdges>>>
          streamControllerCallLogs,
      bool isConnectedToInternet,
      Status status) async {
    if (recentConversationNodes.channelInfo != null &&
        recentConversationNodes.channelInfo!.channelId != null &&
        recentConversationNodes.channelInfo!.channelId!.isNotEmpty &&
        recentConversationNodes.channelInfo!.channelId ==
            getDefaultChannel().id) {
      /// get all dump of required channel id and type
      final Resources<RecentConversation>? dump = await callLogDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(type + getDefaultChannel().id!, caseSensitive: false),
          ),
        ),
      );

      ///remove our value from dump
      if (dump?.data!.recentConversationEdges!.indexWhere((element) =>
              element.recentConversationNodes != null &&
              element.recentConversationNodes!.clientNumber ==
                  recentConversationNodes.clientNumber) ==
          -1) {
      } else {
        dump?.data!.recentConversationEdges!.removeAt(
            dump.data!.recentConversationEdges!.indexWhere((element) =>
                element.recentConversationNodes != null &&
                element.recentConversationNodes!.clientNumber ==
                    recentConversationNodes.clientNumber));
      }

      /// changed index accordingly for pinned or unpinned
      Utils.cPrint(recentConversationNodes.contactPinned.toString());
      if (recentConversationNodes.contactPinned != null &&
          recentConversationNodes.contactPinned!) {
        dump?.data!.recentConversationEdges!.insert(
          0,
          RecentConversationEdges(
            cursor: "",
            channelId: getDefaultChannel().id,
            conversationType: type,
            recentConversationNodes: recentConversationNodes,
            id: recentConversationNodes.id,
            check: false,
            advancePlayDefault: false,
            advancedPlayer: AudioPlayer(),
          ),
        );
      } else {
        dump?.data!.recentConversationEdges!.insert(
          1 +
              dump.data!.recentConversationEdges!.indexWhere(
                  (element) => element.recentConversationNodes == null),
          RecentConversationEdges(
            cursor: "",
            channelId: getDefaultChannel().id,
            conversationType: type,
            recentConversationNodes: recentConversationNodes,
            id: recentConversationNodes.id,
            check: false,
            advancePlayDefault: false,
            advancedPlayer: AudioPlayer(),
          ),
        );
      }

      /// update dao with updated dump wont return data be careful
      await callLogDao!.updateWithFinder(
        RecentConversation(
          id: type + getDefaultChannel().id!,
          recentConversationPageInfo: pageInfo,
          recentConversationEdges: dump?.data!.recentConversationEdges,
        ),
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(type + getDefaultChannel().id!, caseSensitive: false),
          ),
        ),
      );

      /// get updated result from dao
      final Resources<RecentConversation>? result = await callLogDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(type + getDefaultChannel().id!, caseSensitive: false),
          ),
        ),
      );

      if (result == null) {
        sinkCallLogsStream(streamControllerCallLogs,
            Resources(Status.ERROR, "", <RecentConversationEdges>[]));
      } else {
        sinkCallLogsStream(
            streamControllerCallLogs,
            Resources(
                Status.SUCCESS, "", result.data!.recentConversationEdges));
      }
    }
  }

  Future<Stream<QueryResult>?> doSubscriptionCallLogsApiCall(
      String type, String? channelId, bool isConnectedToInternet) async {
    final SubscriptionUpdateConversationDetailRequestHolder
        subscriptionUpdateConversationDetailRequestHolder =
        SubscriptionUpdateConversationDetailRequestHolder(
      channelId: channelId,
    );

    if (isConnectedToInternet) {
      return apiService!.subscriptionCallLogsApiCall(
          subscriptionUpdateConversationDetailRequestHolder);
    } else {
      return null;
    }
  }

  void sinkCallLogsStream(
      StreamController<Resources<List<RecentConversationEdges>>>
          streamControllerCallLogs,
      Resources<List<RecentConversationEdges>> resources) {
    if (!streamControllerCallLogs.isClosed) {
      streamControllerCallLogs.sink.add(resources);
    }
  }
}
