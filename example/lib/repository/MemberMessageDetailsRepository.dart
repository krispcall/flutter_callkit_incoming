import "dart:async";
import "dart:convert";

import "package:collection/collection.dart";
import "package:graphql/client.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/MemberDao.dart";
import "package:mvp/db/MemberMessageDetailsDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/common/SearchInputRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/memberChatRequestParamHolder/MemberChatRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConversationMember.dart";
import "package:mvp/viewObject/model/call/RecentConversationMemberEdges.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessage.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessageResponse.dart";
import "package:mvp/viewObject/model/member_conversation_detail/MemberConversationDetailResponse.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:sembast/sembast.dart";

class MemberMessageDetailsRepository extends Repository {
  MemberMessageDetailsRepository({
    required this.apiService,
    required this.memberDao,
    required this.memberMessageDetailsDao,
  });

  ApiService? apiService;
  MemberDao? memberDao;
  MemberMessageDetailsDao? memberMessageDetailsDao;
  PageInfo? pageInfoMemberSearch;

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doConversationDetailByMemberApiCall(
    String senderId,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet,
  ) async {
    Resources<RecentConversationMember>? initialDump =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );
    if (isConnectedToInternet) {
      MemberChatRequestHolder memberChatRequestHolder;

      if (initialDump?.data != null &&
          initialDump?.data!.recentConversationMemberEdge != null &&
          initialDump!.data!.recentConversationMemberEdge!.isNotEmpty) {
        /// Mobile cache is present so prepare request for last conversation
        memberChatRequestHolder = MemberChatRequestHolder(
          member: senderId,
          params: SearchConversationRequestParamHolder(
            last: 1000000000,
            before:
                initialDump.data!.recentConversationMemberEdge!.first.cursor,
          ),
        );
      } else {
        /// Insert Empty for first time load
        memberMessageDetailsDao!.insert(
          getMemberId() + senderId,
          RecentConversationMember(
            id: getMemberId() + senderId,
            recentConversationMemberEdge: [],
          ),
        );

        /// Mobile cache is not available so prepare for last conversation
        memberChatRequestHolder = MemberChatRequestHolder(
          member: senderId,
          params: SearchConversationRequestParamHolder(
            first: 1000000000,
          ),
        );
      }

      final Resources<MemberConversationDetailResponse> resource =
          await apiService!
              .doConversationDetailByMemberApiCall(memberChatRequestHolder);

      /// refill initial bucket
      initialDump = await memberMessageDetailsDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      if (resource.data!.conversationData!.error == null &&
          resource.data!.conversationData!.recentConversationMember != null &&
          resource.data!.conversationData!.recentConversationMember!
                  .recentConversationMemberEdge !=
              null &&
          resource.data!.conversationData!.recentConversationMember!
              .recentConversationMemberEdge!.isNotEmpty) {
        initialDump!.data!.recentConversationMemberEdge!.insertAll(
          0,
          resource.data!.conversationData!.recentConversationMember!
              .recentConversationMemberEdge!,
        );

        initialDump.data!.id = getMemberId() + senderId;

        initialDump.data!.recentConversationMemberEdge!.sort((a, b) {
          //sorting in descending order
          return DateTime.parse(b.recentConversationMemberNodes!.createdOn!)
              .compareTo(
            DateTime.parse(a.recentConversationMemberNodes!.createdOn!),
          );
        });

        await memberMessageDetailsDao!.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getMemberId() + memberChatRequestHolder.member,
                caseSensitive: false,
              ),
            ),
          ),
        );

        initialDump = await memberMessageDetailsDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getMemberId() + senderId,
                caseSensitive: false,
              ),
            ),
          ),
        );

        RecentConversationMember recentConversationMember;
        final List<RecentConversationMemberEdge> recentConversationMemberEdge =
            [];

        if (initialDump!.data!.recentConversationMemberEdge!.length >
            Config.DEFAULT_LOADING_LIMIT) {
          recentConversationMemberEdge.insertAll(
            0,
            initialDump.data!.recentConversationMemberEdge!.getRange(
              0,
              Config.DEFAULT_LOADING_LIMIT,
            ),
          );
        } else {
          recentConversationMemberEdge.insertAll(
            0,
            initialDump.data!.recentConversationMemberEdge!,
          );
        }

        recentConversationMember = RecentConversationMember(
          recentConversationMemberEdge: recentConversationMemberEdge,
          id: getMemberId() + senderId,
          recentConversationPageInfo: PageInfo(
            endCursor: recentConversationMemberEdge.last.cursor,
            hasNextPage: true,
            startCursor: recentConversationMemberEdge.first.cursor,
            hasPreviousPage: true,
          ),
        );

        initialDump.data!.recentConversationPageInfo =
            recentConversationMember.recentConversationPageInfo;

        await memberMessageDetailsDao!.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getMemberId() + senderId,
                caseSensitive: false,
              ),
            ),
          ),
        );

        final Resources<RecentConversationMember> dump =
            Resources(Status.SUCCESS, "", recentConversationMember);

        streamControllerPageInfo.sink.add(
          Resources(
            Status.SUCCESS,
            "",
            recentConversationMember.recentConversationPageInfo,
          ),
        );

        return doFinalReturn(dump);
      } else {
        initialDump = await memberMessageDetailsDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getMemberId() + senderId,
                caseSensitive: false,
              ),
            ),
          ),
        );

        RecentConversationMember recentConversationMember;
        final List<RecentConversationMemberEdge> recentConversationMemberEdge =
            [];

        if (initialDump!.data!.recentConversationMemberEdge!.length >
            Config.DEFAULT_LOADING_LIMIT) {
          recentConversationMemberEdge.insertAll(
            0,
            initialDump.data!.recentConversationMemberEdge!.getRange(
              0,
              Config.DEFAULT_LOADING_LIMIT,
            ),
          );
        } else {
          recentConversationMemberEdge.insertAll(
            0,
            initialDump.data!.recentConversationMemberEdge!,
          );
        }

        recentConversationMember = RecentConversationMember(
          recentConversationMemberEdge: recentConversationMemberEdge,
          id: getMemberId() + senderId,
          recentConversationPageInfo: PageInfo(
            endCursor: recentConversationMemberEdge.isNotEmpty
                ? recentConversationMemberEdge.last.cursor
                : null,
            hasNextPage: true,
            startCursor: recentConversationMemberEdge.isNotEmpty
                ? recentConversationMemberEdge.first.cursor
                : null,
            hasPreviousPage: true,
          ),
        );

        initialDump.data!.recentConversationPageInfo =
            recentConversationMember.recentConversationPageInfo;

        await memberMessageDetailsDao!.updateWithFinder(
          initialDump.data!,
          Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getMemberId() + senderId,
                caseSensitive: false,
              ),
            ),
          ),
        );

        final Resources<RecentConversationMember> dump =
            Resources(Status.SUCCESS, "", recentConversationMember);

        streamControllerPageInfo.sink.add(
          Resources(
            Status.SUCCESS,
            "",
            recentConversationMember.recentConversationPageInfo,
          ),
        );
        return doFinalReturn(dump);
      }
    } else {
      initialDump = await memberMessageDetailsDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      RecentConversationMember recentConversationMember;
      final List<RecentConversationMemberEdge> recentConversationMemberEdge =
          [];

      if (initialDump!.data!.recentConversationMemberEdge!.length >
          Config.DEFAULT_LOADING_LIMIT) {
        recentConversationMemberEdge.insertAll(
          0,
          initialDump.data!.recentConversationMemberEdge!.getRange(
            0,
            Config.DEFAULT_LOADING_LIMIT,
          ),
        );
      } else {
        recentConversationMemberEdge.insertAll(
          0,
          initialDump.data!.recentConversationMemberEdge!,
        );
      }

      recentConversationMember = RecentConversationMember(
        recentConversationMemberEdge: recentConversationMemberEdge,
        id: getMemberId() + senderId,
        recentConversationPageInfo: PageInfo(
          endCursor: recentConversationMemberEdge.last.cursor,
          hasNextPage: true,
          startCursor: recentConversationMemberEdge.first.cursor,
          hasPreviousPage: true,
        ),
      );

      initialDump.data!.recentConversationPageInfo =
          recentConversationMember.recentConversationPageInfo;

      await memberMessageDetailsDao!.updateWithFinder(
        initialDump.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      final Resources<RecentConversationMember> dump =
          Resources(Status.SUCCESS, "", recentConversationMember);

      streamControllerPageInfo.sink.add(
        Resources(
          Status.SUCCESS,
          "",
          recentConversationMember.recentConversationPageInfo,
        ),
      );
      return doFinalReturn(dump);
    }
  }

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doMemberChatListUpperApiCall(
    String senderId,
    PageInfo pageInfoDump,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversationMember>? initialDump =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );

    final int cursorEndIndex = initialDump!.data!.recentConversationMemberEdge!
        .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

    final int cursorStartIndex = initialDump.data!.recentConversationMemberEdge!
        .indexWhere((element) => element.cursor == pageInfoDump.startCursor);

    final int arrayLength =
        initialDump.data!.recentConversationMemberEdge!.length;

    RecentConversationMember recentConversationMember;
    final List<RecentConversationMemberEdge> recentConversationMemberEdge = [];

    recentConversationMemberEdge.addAll(
      initialDump.data!.recentConversationMemberEdge!.getRange(
        cursorStartIndex,
        cursorEndIndex + Config.DEFAULT_LOADING_LIMIT >= arrayLength
            ? arrayLength
            : cursorEndIndex + Config.DEFAULT_LOADING_LIMIT,
      ),
    );

    recentConversationMember = RecentConversationMember(
      recentConversationMemberEdge: recentConversationMemberEdge,
      id: getMemberId() + senderId,
      recentConversationPageInfo: PageInfo(
        endCursor: recentConversationMemberEdge.last.cursor,
        hasNextPage: cursorEndIndex + 1 == arrayLength ? false : true,
        startCursor: pageInfoDump.startCursor,
        hasPreviousPage: pageInfoDump.hasPreviousPage,
      ),
    );

    final Resources<RecentConversationMember> dump =
        Resources(Status.SUCCESS, "", recentConversationMember);

    streamControllerPageInfo.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversationMember.recentConversationPageInfo,
      ),
    );

    return doFinalReturn(dump);
  }

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doMemberChatListLowerApiCall(
    String senderId,
    int currLength,
    PageInfo pageInfoDump,
    StreamController<Resources<int>> streamControllerLengthDiff,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversationMember>? initialDump =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );

    final int cursorEndIndex = initialDump!.data!.recentConversationMemberEdge!
        .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

    final int cursorStartIndex = initialDump
        .data!.recentConversationMemberEdge!
        .indexWhere((element) => element.cursor == pageInfoDump.startCursor);

    RecentConversationMember recentConversationMember;
    final List<RecentConversationMemberEdge> recentConversationMemberEdge = [];

    recentConversationMemberEdge.insertAll(
      0,
      initialDump.data!.recentConversationMemberEdge!.getRange(
        cursorStartIndex - Config.DEFAULT_LOADING_LIMIT < 0
            ? 0
            : cursorStartIndex - Config.DEFAULT_LOADING_LIMIT,
        cursorEndIndex + 1,
      ),
    );

    recentConversationMember = RecentConversationMember(
      recentConversationMemberEdge: recentConversationMemberEdge,
      id: getMemberId() + senderId,
      recentConversationPageInfo: PageInfo(
        startCursor: recentConversationMemberEdge.first.cursor,
        hasPreviousPage: cursorStartIndex == 0 ? false : true,
        endCursor: pageInfoDump.endCursor,
        hasNextPage: pageInfoDump.hasNextPage,
      ),
    );

    final Resources<RecentConversationMember> dump =
        Resources(Status.SUCCESS, "", recentConversationMember);

    streamControllerPageInfo.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversationMember.recentConversationPageInfo,
      ),
    );

    streamControllerLengthDiff.sink.add(
      Resources(
        Status.SUCCESS,
        "",
        recentConversationMemberEdge.length - currLength,
      ),
    );

    return doFinalReturn(dump);
  }

  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doSearchConversationWithCursorApiCall(
    String senderId,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversationMember>? initialDump =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );

    initialDump!.data!.recentConversationPageInfo = PageInfo(
      endCursor: initialDump.data!.recentConversationMemberEdge!.last.cursor,
      hasNextPage: false,
      startCursor:
          initialDump.data!.recentConversationMemberEdge!.first.cursor,
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

  Future<Resources<List<RecentConversationMemberEdge>>>
      doSearchConversationApiCall(bool isConnectedToInternet,
          MemberChatRequestHolder memberChatRequestHolder) async {
    if (isConnectedToInternet) {
      final Resources<MemberConversationDetailResponse> resource =
          await apiService!
              .doConversationDetailByMemberApiCall(memberChatRequestHolder);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.conversationData!.error == null) {
          pageInfoMemberSearch = resource.data!.conversationData!
              .recentConversationMember!.recentConversationPageInfo;
          return Resources(
            Status.SUCCESS,
            "",
            resource.data!.conversationData!.recentConversationMember!
                .recentConversationMemberEdge,
          );
        } else {
          return Resources(Status.ERROR,
              resource.data!.conversationData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<List<RecentConversationMemberEdge>>>
      doNextSearchConversationApiCall(
    bool isConnectedToInternet,
    String searchQueryController,
    String memberId,
  ) async {
    if (isConnectedToInternet) {
      if (pageInfoMemberSearch!.hasNextPage!) {
        final MemberChatRequestHolder memberChatRequestHolder =
            MemberChatRequestHolder(
          member: memberId,
          params: SearchConversationRequestParamHolder(
            first: Config.DEFAULT_LOADING_LIMIT,
            after: pageInfoMemberSearch?.endCursor,
            search: SearchInputRequestParamHolder(
              columns: ["message"],
              value: searchQueryController,
            ),
          ),
        );

        final Resources<MemberConversationDetailResponse> resource =
            await apiService!
                .doConversationDetailByMemberApiCall(memberChatRequestHolder);

        if (resource.status == Status.SUCCESS) {
          if (resource.data!.conversationData!.error == null) {
            pageInfoMemberSearch = PageInfo(
              endCursor: resource
                      .data!
                      .conversationData!
                      .recentConversationMember!
                      .recentConversationPageInfo!
                      .endCursor ??
                  pageInfoMemberSearch!.endCursor,
              hasNextPage: resource
                  .data!
                  .conversationData!
                  .recentConversationMember!
                  .recentConversationPageInfo!
                  .hasNextPage,
              startCursor: pageInfoMemberSearch!.startCursor,
              hasPreviousPage: pageInfoMemberSearch!.hasPreviousPage,
            );

            return Resources(
              Status.SUCCESS,
              "",
              resource.data!.conversationData!.recentConversationMember!
                  .recentConversationMemberEdge,
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
      return Resources(Status.SUCCESS, "", null);
    }
  }

  /// update subscription for member Chat page
  Future<Resources<List<MemberMessageDetailsObjectWithType>>>
      doUpdateSubscriptionMemberChat(
    String memberId,
    String senderId,
    PageInfo pageInfoDump,
    RecentConversationMemberNodes recentConversationMemberNodes,
    StreamController<Resources<PageInfo>> streamControllerPageInfo,
    bool isSearching,
  ) async {
    Resources<RecentConversationMember>? initialBucket =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (initialBucket!.data != null) {
      ///remove our value from dump
      if (initialBucket.data == null ||
          initialBucket.data!.recentConversationMemberEdge!.indexWhere(
                  (element) =>
                      element.recentConversationMemberNodes!.id ==
                      recentConversationMemberNodes.id) ==
              -1) {
        initialBucket.data!.recentConversationMemberEdge!.insert(
          0,
          RecentConversationMemberEdge(
            id: "",
            channelId: "",
            conversationType: MessageBoxDecorationType.TOP,
            cursor: base64Encode(
                utf8.encode(recentConversationMemberNodes.createdOn!)),
            recentConversationMemberNodes: recentConversationMemberNodes,
          ),
        );
      } else {
        initialBucket.data!.recentConversationMemberEdge![initialBucket
                .data!.recentConversationMemberEdge!
                .indexWhere((element) =>
                    element.recentConversationMemberNodes!.id ==
                    recentConversationMemberNodes.id)] =
            RecentConversationMemberEdge(
          id: "",
          channelId: "",
          conversationType: MessageBoxDecorationType.TOP,
          cursor: base64Encode(
              utf8.encode(recentConversationMemberNodes.createdOn!)),
          recentConversationMemberNodes: recentConversationMemberNodes,
        );
      }
    } else {
      initialBucket.data = RecentConversationMember(
        id: getMemberId() + senderId,
        recentConversationMemberEdge: [],
      );

      await memberMessageDetailsDao!.insert(
        getMemberId() + senderId,
        initialBucket.data!,
      );

      initialBucket.data!.recentConversationMemberEdge!.insert(
        0,
        RecentConversationMemberEdge(
          id: "",
          channelId: "",
          conversationType: MessageBoxDecorationType.TOP,
          cursor: base64Encode(
              utf8.encode(recentConversationMemberNodes.createdOn!)),
          recentConversationMemberNodes: recentConversationMemberNodes,
        ),
      );
    }

    initialBucket.data!.id = getMemberId() + senderId;

    if (!isSearching) {
      initialBucket.data!.recentConversationPageInfo = PageInfo(
        startCursor:
            base64Encode(utf8.encode(recentConversationMemberNodes.createdOn!)),
        hasPreviousPage: true,
        endCursor: pageInfoDump.endCursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await memberMessageDetailsDao!.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket = await memberMessageDetailsDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      int cursorEndIndex = initialBucket!.data!.recentConversationMemberEdge!
          .indexWhere((element) => element.cursor == pageInfoDump.endCursor);

      if (cursorEndIndex == -1) {
        cursorEndIndex = 0;
      }

      final int arrayLength =
          initialBucket.data!.recentConversationMemberEdge!.length;

      RecentConversationMember recentConversation;
      final List<RecentConversationMemberEdge> recentConversationEdges = [];

      recentConversationEdges.addAll(
        initialBucket.data!.recentConversationMemberEdge!.getRange(
          0,
          cursorEndIndex + 1 >= arrayLength ? arrayLength : cursorEndIndex + 1,
        ),
      );

      recentConversation = RecentConversationMember(
        recentConversationMemberEdge: recentConversationEdges,
        id: getMemberId() + senderId,
        recentConversationPageInfo: PageInfo(
          endCursor: recentConversationEdges.last.cursor,
          hasNextPage: true,
          startCursor: recentConversationEdges.first.cursor,
          hasPreviousPage: true,
        ),
      );

      initialBucket.data!.recentConversationPageInfo =
          recentConversation.recentConversationPageInfo;

      await memberMessageDetailsDao!.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      final Resources<RecentConversationMember> dump =
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
            base64Encode(utf8.encode(recentConversationMemberNodes.createdOn!)),
        hasPreviousPage: true,
        endCursor: pageInfoDump.endCursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await memberMessageDetailsDao!.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket = await memberMessageDetailsDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
              caseSensitive: false,
            ),
          ),
        ),
      );

      initialBucket!.data!.recentConversationPageInfo = PageInfo(
        startCursor:
            initialBucket.data!.recentConversationMemberEdge!.first.cursor,
        hasPreviousPage: true,
        endCursor:
            initialBucket.data!.recentConversationMemberEdge!.last.cursor,
        hasNextPage: pageInfoDump.hasNextPage,
      );

      await memberMessageDetailsDao!.updateWithFinder(
        initialBucket.data!,
        Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getMemberId() + senderId,
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

  /// do call subscription api for workspace member chat
  Future<Stream<QueryResult>> doSubscriptionWorkspaceChatDetail() async {
    return apiService!.doSubscriptionWorkspaceChatDetail();
  }

  Future<Resources<CreateChatMessage>> doSendChatMessageApiCall(
    Map<String, dynamic> param,
    bool isConnectedToInternet,
  ) async {
    if (isConnectedToInternet) {
      final Resources<CreateChatMessageResponse> resource =
          await apiService!.doSendChatMessageApiCall(param);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.createChatMessageData!.error == null) {
          return Resources(Status.SUCCESS, "Success",
              resource.data!.createChatMessageData!.messages);
        } else {
          return Resources(Status.ERROR,
              resource.data!.createChatMessageData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<int> getSearchIndex(
    RecentConversationMemberEdge item,
    String senderId,
    bool isConnectedToInternet,
  ) async {
    final Resources<RecentConversationMember>? initialDump =
        await memberMessageDetailsDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getMemberId() + senderId,
            caseSensitive: false,
          ),
        ),
      ),
    );

    final Resources<List<MemberMessageDetailsObjectWithType>> dump =
        doFinalReturn(initialDump!);

    return dump.data!.reversed.toList().indexWhere(
          (element) =>
              element.edges != null &&
              element.edges!.cursor != null &&
              element.edges!.cursor == item.cursor,
        );
  }

  Resources<List<MemberMessageDetailsObjectWithType>> doFinalReturn(
      Resources<RecentConversationMember> toReturn) {
    if (toReturn.data != null &&
        toReturn.data!.recentConversationMemberEdge != null &&
        toReturn.data!.recentConversationMemberEdge!.isNotEmpty) {
      toReturn.data!.recentConversationMemberEdge!.sort((a, b) {
        //sorting in descending order
        return DateTime.parse(a.recentConversationMemberNodes!.createdOn!)
            .compareTo(
          DateTime.parse(b.recentConversationMemberNodes!.createdOn!),
        );
      });

      final List<MemberMessageDetailsObjectWithType> dump2 =
          <MemberMessageDetailsObjectWithType>[];

      final groupByDate = groupBy(
          toReturn.data!.toMap(toReturn.data!)!["edges"]
              as List<Map<String, dynamic>>,
          (Map obj) => obj["node"]["createdOn"].substring(0, 10));

      groupByDate.forEach((date, list) {
        //HEADER
        dump2.add(
          MemberMessageDetailsObjectWithType(
            type: "time",
            time: date.toString(),
          ),
        );

        //GROUP
        for (final listItem in list) {
          dump2.add(
            MemberMessageDetailsObjectWithType(
              type: "",
              edges: RecentConversationMemberEdge().fromMap(listItem),
            ),
          );
        }
      });

      return Resources(Status.SUCCESS, "", dump2);
    } else {
      return Resources(Status.SUCCESS, "", []);
    }
  }
}

class MemberMessageDetailsObjectWithType
    extends MapObject<MemberMessageDetailsObjectWithType> {
  String? type;
  RecentConversationMemberEdge? edges;
  String? time;

  MemberMessageDetailsObjectWithType({
    this.type,
    this.edges,
    this.time,
  });

  Map toJson() {
    final Map data = {};
    data["type"] = type;
    data["edges"] = edges;
    data["time"] = time;
    return data;
  }

  factory MemberMessageDetailsObjectWithType.fromJSON(
      Map<String, dynamic> json) {
    return MemberMessageDetailsObjectWithType(
      type: json["type"] as String,
      edges: json["edges"] as RecentConversationMemberEdge,
      time: json["time"] as String,
    );
  }

  @override
  MemberMessageDetailsObjectWithType? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MemberMessageDetailsObjectWithType(
        type: dynamicData["type"] as String,
        edges: RecentConversationMemberEdge().fromMap(dynamicData["edges"]),
        time: dynamicData["time"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MemberMessageDetailsObjectWithType? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["type"] = object.type;
      data["edges"] = object.edges != null
          ? RecentConversationMemberEdge().toMap(object.edges!)
          : null;

      data["time"] = object.time;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MemberMessageDetailsObjectWithType>? fromMapList(List? dynamicDataList) {
    final List<MemberMessageDetailsObjectWithType> basketList =
        <MemberMessageDetailsObjectWithType>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<MemberMessageDetailsObjectWithType>? mapList, key, value) {
    // TODO: implement getIdByKeyValue
    throw UnimplementedError();
  }

  @override
  List<String>? getIdList(List<MemberMessageDetailsObjectWithType>? mapList) {
    // TODO: implement getIdList
    throw UnimplementedError();
  }

  @override
  String getPrimaryKey() {
    // TODO: implement getPrimaryKey
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<MemberMessageDetailsObjectWithType>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
