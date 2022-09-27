import "dart:async";
import "dart:convert";

import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/MessageDetailsDao.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/common/SearchInputRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/ConversationDetailRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationDetailRequestParamHolder/SearchConversationRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/conversationSeenRequestParamHolder/ConversationSeenRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/sendMessageRequestParamHolder/SendMessageRequestHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversation.dart";
import "package:mvp/viewObject/model/call/RecentConversationEdges.dart";
import "package:mvp/viewObject/model/call/RecentConversationNodes.dart";
import "package:mvp/viewObject/model/conversationSeen/ConversationSeenResponse.dart";
import "package:mvp/viewObject/model/conversation_detail/ConversationDetailResponse.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:mvp/viewObject/model/sendMessage/Messages.dart";
import "package:mvp/viewObject/model/sendMessage/SendMessageResponse.dart";
import "package:sembast/sembast.dart";

class MessageDetailsRepository extends Repository {
  MessageDetailsRepository({
    required this.apiService,
    required this.messageDetailsDao,
  });

  ApiService? apiService;
  MessageDetailsDao messageDetailsDao;
  PageInfo? pageInfoConversationSearch;

  Future<Resources<List<MessageDetailsObjectWithType>>>
      doConversationDetailByContactApiCall(
    String? channelId,
    String? clientNumber,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet, {
    bool isCallRecording = false,
  }) async {
    await messageDetailsDao.deleteWithFinder(
      Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            "$channelId${clientNumber!.replaceAll("+", "")}",
            caseSensitive: false,
          ),
        ),
      ),
    );

    Resources<RecentConversation>? initialDump = await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            "$channelId${clientNumber.replaceAll("+", "")}",
            caseSensitive: false,
          ),
        ),
      ),
    );
    if (isConnectedToInternet) {
      ConversationDetailRequestHolder recentConversationRequestHolder;

      if (initialDump!.data != null &&
          initialDump.data!.recentConversationEdges != null &&
          initialDump.data!.recentConversationEdges!.isNotEmpty) {
        /// Mobile cache is present so prepare request for last conversation
        recentConversationRequestHolder = ConversationDetailRequestHolder(
          contact: clientNumber,
          channel: channelId,
          param: ConversationDetailRequestParamHolder(
            last: 1000000000,
            before: initialDump.data!.recentConversationEdges!.first.cursor,
          ),
        );
      } else {
        /// Insert Empty for first time load
        messageDetailsDao.insert(
          "$channelId${clientNumber.replaceAll("+", "")}",
          RecentConversation(
            id: "$channelId${clientNumber.replaceAll("+", "")}",
            recentConversationEdges: [],
          ),
        );

        /// Mobile cache is not available so prepare for last conversation
        recentConversationRequestHolder = ConversationDetailRequestHolder(
          contact: clientNumber,
          channel: channelId,
          param: ConversationDetailRequestParamHolder(
            first: 1000000000,
          ),
        );
      }

      /// refill initial bucket
      initialDump = await messageDetailsDao.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              "$channelId${clientNumber.replaceAll("+", "")}",
              caseSensitive: false,
            ),
          ),
        ),
      );

      final Resources<ConversationDetailResponse> resource =
          await apiService!.doConversationDetailByContactApiCall(
        recentConversationRequestHolder,
      );

      if (resource.data != null &&
          resource.data?.conversationData != null &&
          resource.data?.conversationData?.error == null &&
          resource.data?.conversationData?.recentConversation != null &&
          resource.data?.conversationData?.recentConversation!
                  .recentConversationEdges !=
              null &&
          resource.data!.conversationData!.recentConversation!
              .recentConversationEdges!.isNotEmpty) {
        if (initialDump!.data != null) {
          initialDump.data!.recentConversationEdges!.insertAll(
            0,
            resource.data!.conversationData!.recentConversation!
                .recentConversationEdges!,
          );
        } else {
          initialDump.data = RecentConversation(
            recentConversationPageInfo: PageInfo(
              hasPreviousPage: true,
              hasNextPage: true,
              endCursor: "",
              startCursor: "",
            ),
            id: "$channelId${clientNumber.replaceAll("+", "")}",
            recentConversationEdges: resource.data!.conversationData!
                .recentConversation!.recentConversationEdges,
          );
        }

        initialDump.data!.id = "$channelId${clientNumber.replaceAll("+", "")}";

        initialDump.data!.recentConversationEdges!.sort((a, b) {
          //sorting in descending order
          return DateTime.parse(b.recentConversationNodes!.createdAt!)
              .compareTo(
            DateTime.parse(a.recentConversationNodes!.createdAt!),
          );
        });

        await messageDetailsDao.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        initialDump = await messageDetailsDao.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        initialDump = await messageDetailsDao.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        RecentConversation recentConversation;
        final List<RecentConversationEdges> recentConversationEdges = [];

        if (initialDump!.data!.recentConversationEdges!.length >
            Config.DEFAULT_LOADING_LIMIT) {
          recentConversationEdges.insertAll(
            0,
            initialDump.data!.recentConversationEdges!.getRange(
              0,
              Config.DEFAULT_LOADING_LIMIT,
            ),
          );
        } else {
          recentConversationEdges.insertAll(
            0,
            initialDump.data!.recentConversationEdges!,
          );
        }

        recentConversation = RecentConversation(
          recentConversationEdges: recentConversationEdges,
          id: "$channelId${clientNumber.replaceAll("+", "")}",
          recentConversationPageInfo: PageInfo(
            endCursor: recentConversationEdges.last != null
                ? recentConversationEdges.last.cursor
                : null,
            hasNextPage: true,
            startCursor: recentConversationEdges.first.cursor,
            hasPreviousPage: true,
          ),
        );

        initialDump.data!.recentConversationPageInfo =
            recentConversation.recentConversationPageInfo;

        await doUpdateConversationStatus(channelId, initialDump, clientNumber);
        await messageDetailsDao.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        final Resources<RecentConversation> dump =
            Resources(Status.SUCCESS, "", recentConversation);

        streamControllerPageInfo.sink.add(
          Resources(
            Status.SUCCESS,
            "",
            recentConversation.recentConversationPageInfo,
          ),
        );

        return doFinalReturn(dump);
      } else {
        initialDump = await messageDetailsDao.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        initialDump = await messageDetailsDao.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        RecentConversation recentConversation;
        final List<RecentConversationEdges> recentConversationEdges = [];

        if (initialDump!.data!=null && initialDump.data!.recentConversationEdges!.length >
            Config.DEFAULT_LOADING_LIMIT) {
          recentConversationEdges.insertAll(
            0,
            initialDump.data!.recentConversationEdges!.getRange(
              0,
              Config.DEFAULT_LOADING_LIMIT,
            ),
          );
        } else {
          recentConversationEdges.insertAll(
            0,
            initialDump.data!.recentConversationEdges!,
          );
        }

        recentConversation = RecentConversation(
          recentConversationEdges: recentConversationEdges,
          id: "$channelId${clientNumber.replaceAll("+", "")}",
          recentConversationPageInfo: PageInfo(
            endCursor: recentConversationEdges.isNotEmpty
                ? recentConversationEdges.last.cursor
                : null,
            hasNextPage: true,
            startCursor: recentConversationEdges.isNotEmpty
                ? recentConversationEdges.first.cursor
                : null,
            hasPreviousPage: true,
          ),
        );

        initialDump.data!.recentConversationPageInfo =
            recentConversation.recentConversationPageInfo;

        await doUpdateConversationStatus(channelId, initialDump, clientNumber);

        await messageDetailsDao.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                "$channelId${clientNumber.replaceAll("+", "")}",
                caseSensitive: false,
              ),
            ),
          ),
        );

        final Resources<RecentConversation> dump =
            Resources(Status.SUCCESS, "", recentConversation);

        streamControllerPageInfo.sink.add(
          Resources(
            Status.SUCCESS,
            "",
            recentConversation.recentConversationPageInfo,
          ),
        );

        return doFinalReturn(dump);
      }
    } else {
      initialDump = await messageDetailsDao.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              "$channelId${clientNumber.replaceAll("+", "")}",
              caseSensitive: false,
            ),
          ),
        ),
      );

      RecentConversation recentConversation;
      final List<RecentConversationEdges> recentConversationEdges = [];

      if (initialDump!.data!.recentConversationEdges!.length >
          Config.DEFAULT_LOADING_LIMIT) {
        recentConversationEdges.insertAll(
          0,
          initialDump.data!.recentConversationEdges!.getRange(
            0,
            Config.DEFAULT_LOADING_LIMIT,
          ),
        );
      } else {
        recentConversationEdges.insertAll(
          0,
          initialDump.data!.recentConversationEdges!,
        );
      }

      recentConversation = RecentConversation(
        recentConversationEdges: recentConversationEdges,
        id: "$channelId${clientNumber.replaceAll("+", "")}",
        recentConversationPageInfo: PageInfo(
          endCursor: recentConversationEdges.last.cursor,
          hasNextPage: true,
          startCursor: recentConversationEdges.first.cursor,
          hasPreviousPage: true,
        ),
      );

      initialDump.data!.recentConversationPageInfo =
          recentConversation.recentConversationPageInfo;

      await messageDetailsDao.updateWithFinder(
        initialDump.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              "$channelId${clientNumber.replaceAll("+", "")}",
              caseSensitive: false,
            ),
          ),
        ),
      );

      final Resources<RecentConversation> dump =
          Resources(Status.SUCCESS, "", recentConversation);

      streamControllerPageInfo.sink.add(
        Resources(
          Status.SUCCESS,
          "",
          recentConversation.recentConversationPageInfo,
        ),
      );

      return doFinalReturn(dump);
    }
  }

  Future<Resources<List<MessageDetailsObjectWithType>>>
      doMessageChatListUpperApiCall(
    String? channelId,
    String clientNumber,
    PageInfo pageInfoDump,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet, {
    bool isCallRecording = false,
  }) async {
    final Resources<RecentConversation>? initialDump =
        await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            "$channelId${clientNumber.replaceAll("+", "")}",
            caseSensitive: false,
          ),
        ),
      ),
    );

    final int cursorEndIndex = initialDump!.data!.recentConversationEdges!
        .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

    final int cursorStartIndex = initialDump.data!.recentConversationEdges!
        .indexWhere((element) => element.cursor == pageInfoDump.startCursor);

    final int arrayLength = initialDump.data!.recentConversationEdges!.length;

    RecentConversation? recentConversation;
    final List<RecentConversationEdges> recentConversationEdges = [];

    try {
      recentConversationEdges.addAll(
        initialDump.data!.recentConversationEdges!.getRange(
          cursorStartIndex,
          cursorEndIndex + Config.DEFAULT_LOADING_LIMIT >= arrayLength
              ? arrayLength
              : cursorEndIndex + Config.DEFAULT_LOADING_LIMIT,
        ),
      );
      recentConversation = RecentConversation(
        recentConversationEdges: recentConversationEdges,
        id: "$channelId${clientNumber.replaceAll("+", "")}",
        recentConversationPageInfo: PageInfo(
          endCursor: recentConversationEdges.last.cursor,
          hasNextPage: cursorEndIndex + 1 == arrayLength ? false : true,
          startCursor: pageInfoDump.startCursor,
          hasPreviousPage: pageInfoDump.hasPreviousPage,
        ),
      );
    } catch (e) {
      Utils.cPrint(e.toString());
    }

    final Resources<RecentConversation> dump =
        Resources(Status.SUCCESS, "", recentConversation);

    streamControllerPageInfo.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversation?.recentConversationPageInfo,
      ),
    );

    return doFinalReturn(dump);
  }

  Future<Resources<List<MessageDetailsObjectWithType>>>
      doMessageChatListLowerApiCall(
    String? channelId,
    String clientNumber,
    int currLength,
    PageInfo pageInfoDump,
    StreamController<Resources<int>> streamControllerLengthDiff,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet, {
    bool isCallRecording = false,
  }) async {
    final Resources<RecentConversation>? initialDump =
        await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            "$channelId${clientNumber.replaceAll("+", "")}",
            caseSensitive: false,
          ),
        ),
      ),
    );

    final int cursorEndIndex = initialDump!.data!.recentConversationEdges!
        .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

    final int cursorStartIndex = initialDump.data!.recentConversationEdges!
        .indexWhere((element) => element.cursor == pageInfoDump.startCursor);

    RecentConversation? recentConversation;
    final List<RecentConversationEdges> recentConversationEdges = [];

    recentConversationEdges.insertAll(
      0,
      initialDump.data!.recentConversationEdges!.getRange(
        cursorStartIndex - Config.DEFAULT_LOADING_LIMIT < 0
            ? 0
            : cursorStartIndex - Config.DEFAULT_LOADING_LIMIT,
        cursorEndIndex + 1,
      ),
    );

    try {
      recentConversation = RecentConversation(
        recentConversationEdges: recentConversationEdges,
        id: "$channelId${clientNumber.replaceAll("+", "")}",
        recentConversationPageInfo: PageInfo(
          startCursor: recentConversationEdges.first != null
              ? recentConversationEdges.first.cursor
              : null,
          hasPreviousPage: cursorStartIndex == 0 ? false : true,
          endCursor: pageInfoDump.endCursor,
          hasNextPage: pageInfoDump.hasNextPage,
        ),
      );
    } catch (e) {
      Utils.cPrint(e.toString());
    }

    final Resources<RecentConversation> dump =
        Resources(Status.SUCCESS, "", recentConversation);

    streamControllerPageInfo.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversation?.recentConversationPageInfo,
      ),
    );

    streamControllerLengthDiff.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversationEdges.length - currLength,
      ),
    );

    return doFinalReturn(dump);
  }

  Future<Resources<Messages>> doSendMessageApiCall(
    SendMessageRequestHolder param,
    bool isConnectedToInternet,
  ) async {
    if (isConnectedToInternet) {
      final Resources<SendMessageResponse> resource =
          await apiService!.doSendMessageApiCall(param);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.sendMessage!.error == null) {
          return Resources(
              Status.SUCCESS, "", resource.data!.sendMessage!.messages);
        } else {
          return Resources(
              Status.ERROR, resource.data!.sendMessage!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  /*Fetched initials searched conversation*/
  Future<Resources<List<RecentConversationEdges>>> doSearchConversationApiCall(
      bool isConnectedToInternet,
      SearchConversationRequestHolder searchConversationRequestHolder) async {
    if (isConnectedToInternet) {
      final Resources<ConversationDetailResponse> resource = await apiService!
          .searchConversationApiCall(searchConversationRequestHolder);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.conversationData!.error == null) {
          pageInfoConversationSearch = resource.data!.conversationData!
              .recentConversation!.recentConversationPageInfo;
          return Resources(
            Status.SUCCESS,
            "",
            resource.data!.conversationData!.recentConversation!
                .recentConversationEdges,
          );
        } else {
          return Resources(Status.ERROR,
              resource.data!.conversationData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  /*Get paginated searchn converstion*/
  Future<Resources<List<RecentConversationEdges>>>
      doGetNextSearchedConversationApiCall(
    String channelId,
    bool isConnectedToInternet,
    String keyword,
    String clientId,
  ) async {
    if (isConnectedToInternet) {
      final SearchConversationRequestHolder searchConversationRequestHolder =
          SearchConversationRequestHolder(
        channel: channelId,
        contact: clientId,
        param: SearchConversationRequestParamHolder(
          first: Config.DEFAULT_LOADING_LIMIT,
          search: SearchInputRequestParamHolder(
            columns: ["sms"],
            value: keyword,
          ),
          after: pageInfoConversationSearch?.endCursor,
        ),
      );

      if (pageInfoConversationSearch != null &&
          pageInfoConversationSearch!.hasNextPage!) {
        final Resources<ConversationDetailResponse> resource = await apiService!
            .searchConversationApiCall(searchConversationRequestHolder);
        if (resource.status == Status.SUCCESS) {
          if (resource.data!.conversationData!.error == null) {
            pageInfoConversationSearch = PageInfo(
              endCursor: resource.data!.conversationData!.recentConversation!
                      .recentConversationPageInfo!.endCursor ??
                  pageInfoConversationSearch!.endCursor,
              hasNextPage: resource.data!.conversationData!.recentConversation!
                  .recentConversationPageInfo!.hasNextPage,
              startCursor: pageInfoConversationSearch!.startCursor,
              hasPreviousPage: pageInfoConversationSearch!.hasPreviousPage,
            );

            return Resources(
              Status.SUCCESS,
              "",
              resource.data!.conversationData!.recentConversation!
                  .recentConversationEdges,
            );
          } else {
            return Resources(Status.ERROR,
                resource.data!.conversationData!.error!.message, null);
          }
        } else {
          return Resources(Status.ERROR, Utils.getString("serverError"), null);
        }
      } else {
        return Resources(Status.SUCCESS, "", []);
      }
    } else {
      return Resources(Status.SUCCESS, "noInternet", null);
    }
  }

  Future<Resources<List<MessageDetailsObjectWithType>>>
      doSearchConversationWithCursorApiCall(
    String channelId,
    String clientNumber,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversation>? initialDump =
        await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            channelId + clientNumber.replaceAll("+", ""),
            caseSensitive: false,
          ),
        ),
      ),
    );

    initialDump!.data!.recentConversationPageInfo = PageInfo(
      endCursor: initialDump.data!.recentConversationEdges!.last.cursor,
      hasNextPage: false,
      startCursor: initialDump.data!.recentConversationEdges!.first.cursor,
      hasPreviousPage: false,
    );

    streamControllerPageInfo.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        initialDump.data!.recentConversationPageInfo,
      ),
    );

    return doFinalReturn(initialDump);
  }

  /// update subscription for conversation detail page
  Future<Resources<List<MessageDetailsObjectWithType>>>
      doUpdateSubscriptionConversationDetail(
    String channelId,
    String clientNumber,
    PageInfo pageInfoDump,
    RecentConversationNodes recentConversationNodes,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isSearching,
  ) async {
    Resources<RecentConversation>? initialBucket =
        await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            channelId + clientNumber.replaceAll("+", ""),
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (initialBucket!.data != null) {
      ///remove our value from dump
      if (initialBucket.data == null ||
          initialBucket.data!.recentConversationEdges!.indexWhere((element) =>
                  element.recentConversationNodes!.id ==
                  recentConversationNodes.id) ==
              -1) {
        initialBucket.data!.recentConversationEdges!.insert(
          0,
          RecentConversationEdges(
            id: "",
            channelId: "",
            conversationType: MessageBoxDecorationType.TOP,
            cursor:
                base64Encode(utf8.encode(recentConversationNodes.createdAt!)),
            recentConversationNodes: recentConversationNodes,
          ),
        );
      } else {
        initialBucket.data!.recentConversationEdges![
            initialBucket.data!.recentConversationEdges!.indexWhere((element) =>
                element.recentConversationNodes!.id ==
                recentConversationNodes.id)] = RecentConversationEdges(
          id: "",
          channelId: "",
          conversationType: MessageBoxDecorationType.TOP,
          cursor: base64Encode(utf8.encode(recentConversationNodes.createdAt!)),
          recentConversationNodes: recentConversationNodes,
        );
      }
    } else {
      initialBucket.data = RecentConversation(
        id: channelId + clientNumber.replaceAll("+", ""),
        recentConversationEdges: [],
      );

      await messageDetailsDao.insert(
        channelId + clientNumber.replaceAll("+", ""),
        initialBucket.data!,
      );

      initialBucket.data!.recentConversationEdges!.insert(
        0,
        RecentConversationEdges(
          id: "",
          channelId: "",
          conversationType: MessageBoxDecorationType.TOP,
          cursor: base64Encode(utf8.encode(recentConversationNodes.createdAt!)),
          recentConversationNodes: recentConversationNodes,
        ),
      );
    }

    initialBucket.data!.id = channelId + clientNumber.replaceAll("+", "");

    if (!isSearching) {
      initialBucket.data!.recentConversationPageInfo = PageInfo(
        startCursor:
            base64Encode(utf8.encode(recentConversationNodes.createdAt!)),
        hasPreviousPage: true,
        endCursor: pageInfoDump.endCursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await messageDetailsDao.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket = await messageDetailsDao.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      int cursorEndIndex = initialBucket!.data!.recentConversationEdges!
          .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

      if (cursorEndIndex == -1) {
        cursorEndIndex = 0;
      }

      final int arrayLength =
          initialBucket.data!.recentConversationEdges!.length;

      RecentConversation recentConversation;
      final List<RecentConversationEdges> recentConversationEdges = [];

      recentConversationEdges.addAll(
        initialBucket.data!.recentConversationEdges!.getRange(
          0,
          cursorEndIndex + 1 >= arrayLength ? arrayLength : cursorEndIndex + 1,
        ),
      );

      recentConversation = RecentConversation(
        recentConversationEdges: recentConversationEdges,
        id: channelId + clientNumber.replaceAll("+", ""),
        recentConversationPageInfo: PageInfo(
          endCursor: recentConversationEdges.last.cursor,
          hasNextPage: true,
          startCursor: recentConversationEdges.first.cursor,
          hasPreviousPage: true,
        ),
      );

      initialBucket.data!.recentConversationPageInfo =
          recentConversation.recentConversationPageInfo;

      await messageDetailsDao.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      final Resources<RecentConversation> dump =
          Resources(Status.SUCCESS, "", recentConversation);

      streamControllerPageInfo.sink.add(
        Resources(
          Status.SUCCESS,
          "",
          recentConversation.recentConversationPageInfo,
        ),
      );

      return doFinalReturn(dump);
    } else {
      initialBucket.data!.recentConversationPageInfo = PageInfo(
        startCursor:
            base64Encode(utf8.encode(recentConversationNodes.createdAt!)),
        hasPreviousPage: true,
        endCursor: pageInfoDump.endCursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await messageDetailsDao.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket = await messageDetailsDao.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket?.data!.recentConversationPageInfo = PageInfo(
        startCursor: initialBucket.data!.recentConversationEdges!.first.cursor,
        hasPreviousPage: true,
        endCursor: initialBucket.data!.recentConversationEdges!.last.cursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await messageDetailsDao.updateWithFinder(
        initialBucket!.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              channelId + clientNumber.replaceAll("+", ""),
              caseSensitive: false,
            ),
          ),
        ),
      );

      streamControllerPageInfo.sink.add(
        Resources(
          Status.SUCCESS,
          "",
          initialBucket.data!.recentConversationPageInfo,
        ),
      );
      return doFinalReturn(initialBucket);
    }
  }

  Future<Stream<QueryResult>?> doSubscriptionConversationChatApiCall(
      String type, String? channelId, bool isConnectedToInternet) async {
    final SubscriptionUpdateConversationDetailRequestHolder
        subscriptionUpdateConversationDetailRequestHolder =
        SubscriptionUpdateConversationDetailRequestHolder(
      channelId: channelId,
    );

    if (isConnectedToInternet) {
      return apiService!.subscriptionConversationChatApiCall(
          subscriptionUpdateConversationDetailRequestHolder);
    } else {
      return null;
    }
  }

  Future<Resources<bool>> doConversationSeenApiCall(
      ConversationSeenRequestParamHolder param,
      bool isConnectedToInternet,
      Status status) async {
    if (isConnectedToInternet) {
      final Resources<ConversationSeenResponse> resource =
          await apiService!.doConversationSeenApiCall(param);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.conversationSeenResponseData!.error == null) {
          DashboardView.subscriptionConversationSeen.fire(
            SubscriptionConversationSeenEvent(
              isSeen: true,
            ),
          );
          return Resources(
              Status.SUCCESS,
              "",
              resource.data!.conversationSeenResponseData!.conversationSeen!
                  .success);
        } else {
          return Resources(
              Status.ERROR,
              resource.data!.conversationSeenResponseData!.error!.message,
              null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<int> getSearchIndex(
    String channelId,
    RecentConversationEdges item,
    String clientNumber,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversation>? initialDump =
        await messageDetailsDao.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            channelId + clientNumber.replaceAll("+", ""),
            caseSensitive: false,
          ),
        ),
      ),
    );

    final Resources<List<MessageDetailsObjectWithType>> dump =
        doFinalReturn(initialDump!);

    return dump.data!.reversed.toList().indexWhere(
          (element) =>
              element.edges != null &&
              element.edges!.recentConversationNodes!.id != null &&
              element.edges!.recentConversationNodes!.id ==
                  item.recentConversationNodes!.id,
        );
  }

  Resources<List<MessageDetailsObjectWithType>> doFinalReturn(
      Resources<RecentConversation> toReturn) {
    if (toReturn.data != null &&
        toReturn.data!.recentConversationEdges != null &&
        toReturn.data!.recentConversationEdges!.isNotEmpty) {
      toReturn.data!.recentConversationEdges!.sort((a, b) {
        //sorting in descending order
        return DateTime.parse(a.recentConversationNodes!.createdAt!).compareTo(
          DateTime.parse(b.recentConversationNodes!.createdAt!),
        );
      });

      final List<MessageDetailsObjectWithType> dump2 =
          <MessageDetailsObjectWithType>[];

      final groupByDate = groupBy(
          toReturn.data!.toMap(toReturn.data)!["edges"]
              as List<Map<String, dynamic>>,
          (Map obj) => obj["node"]["createdAt"].substring(0, 10));
      groupByDate.forEach((date, list) {
        //HEADER
        dump2.add(
          MessageDetailsObjectWithType(
            type: "time",
            time: date.toString(),
          ),
        );

        //GROUP
        for (final listItem in list) {
          dump2.add(
            MessageDetailsObjectWithType(
              type: "",
              edges: RecentConversationEdges().fromMap(listItem),
            ),
          );
        }
      });

      return Resources(Status.SUCCESS, "", dump2);
    } else {
      return Resources(Status.SUCCESS, "", []);
    }
  }

  Future<bool> doUpdateConversationStatus(String? channelId,
      Resources<RecentConversation> initialDump, String clientNumber) async {
    final List<RecentConversationEdges> toUpdateList = initialDump
        .data!.recentConversationEdges!
        .where((value) =>
            value.recentConversationNodes!.conversationType!.toLowerCase() ==
                "call" &&
            (value.recentConversationNodes!.conversationStatus!
                        .toLowerCase() ==
                    "ringing" ||
                value.recentConversationNodes!.conversationStatus!
                        .toLowerCase() ==
                    "inprogress" ||
                value.recentConversationNodes!.conversationStatus!
                        .toLowerCase() ==
                    "pending" ||
                value.recentConversationNodes!.conversationStatus!
                        .toLowerCase() ==
                    "onhold" ||
                value.recentConversationNodes!.conversationStatus!
                        .toLowerCase() ==
                    "transfering"))
        .toList();

    Utils.cPrint(toUpdateList.length.toString());

    if (toUpdateList.isNotEmpty) {
      for (final RecentConversationEdges item in toUpdateList) {
        Utils.cPrint(item.toMap(item).toString());
        final ConversationDetailRequestHolder recentConversationRequestHolder =
            ConversationDetailRequestHolder(
          contact: clientNumber,
          channel: channelId!,
          param: ConversationDetailRequestParamHolder(
            first: 1,
            afterWith: item.cursor,
          ),
        );
        final Resources<ConversationDetailResponse> resource = await apiService!
            .doConversationDetailByContactApiCall(
                recentConversationRequestHolder);

        try {
          initialDump.data!.recentConversationEdges![
              initialDump.data!.recentConversationEdges!.indexWhere((element) =>
                  element.recentConversationNodes!.id ==
                  item.recentConversationNodes!.id)] = RecentConversationEdges(
            id: "",
            channelId: "",
            conversationType: MessageBoxDecorationType.TOP,
            cursor: resource.data!.conversationData!.recentConversation!
                .recentConversationEdges![0].cursor,
            recentConversationNodes: resource
                .data!
                .conversationData!
                .recentConversation!
                .recentConversationEdges![0]
                .recentConversationNodes,
          );

          await messageDetailsDao.updateWithFinder(
            initialDump.data!,
            Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(
                  "$channelId${clientNumber.replaceAll("+", "")}",
                  caseSensitive: false,
                ),
              ),
            ),
          );
        } catch (e) {
          Utils.cPrint(e.toString());
        }
      }
    }

    return true;
  }
}

class MessageDetailsObjectWithType {
  String? type;
  RecentConversationEdges? edges;
  String? time;
  String? messageBoxDecorationType;

  MessageDetailsObjectWithType({
    this.type,
    this.edges,
    this.time,
    this.messageBoxDecorationType,
  });
}
