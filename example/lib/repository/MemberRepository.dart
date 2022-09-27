import "dart:async";

import "package:graphql/client.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/MemberDao.dart";
import "package:mvp/db/MemberMessageDetailsDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/pageRequestParamHolder/PageRequestHolder.dart";
import "package:mvp/viewObject/model/call/RecentConverstationMemberNode.dart";
import "package:mvp/viewObject/model/members/ChatMessage.dart";
import "package:mvp/viewObject/model/members/MemberChatSeenResponse.dart";
import "package:mvp/viewObject/model/members/MemberData.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:mvp/viewObject/model/members/Members.dart";
import "package:mvp/viewObject/model/members/MembersResponse.dart";
import "package:mvp/viewObject/model/pagination/PageInfo.dart";
import "package:sembast/sembast.dart";

class MemberRepository extends Repository {
  MemberRepository({
    required this.apiService,
    required this.memberDao,
    required this.memberMessageDetailsDao,
  });

  ApiService? apiService;
  MemberDao? memberDao;
  MemberMessageDetailsDao? memberMessageDetailsDao;
  PageInfo? pageInfo;
  PageInfo? pageInfoMemberSearch;

  Future<Resources<List<MemberEdges>>> doGetAllWorkspaceMembersApiCall(
      String memberId,
      StreamController<Resources<List<MemberEdges>>>
          streamControllerMemberEdges,
      bool isConnectedToInternet,
      int limit,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final PageRequestHolder pageRequestHolder = PageRequestHolder(
        param: SearchConversationRequestParamHolder(
          first: limit,
        ),
      );
      final Resources<MembersResponse> resource =
          await apiService!.doGetAllWorkspaceMembersApiCall(pageRequestHolder);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.memberResponseData!.error == null) {
          pageInfo = resource.data!.memberResponseData!.memberData!.pageInfo;
          MemberEdges you;
          for (int i = 0;
              i <
                  resource.data!.memberResponseData!.memberData!.memberEdges!
                      .length;
              i++) {
            if (resource.data!.memberResponseData!.memberData!.memberEdges![i]
                    .members!.id ==
                memberId) {
              you = resource
                  .data!.memberResponseData!.memberData!.memberEdges![i];
              resource.data!.memberResponseData!.memberData!.memberEdges!
                  .removeAt(i);
              resource.data!.memberResponseData!.memberData!.memberEdges!
                  .sort((a, b) {
                final int data = DateTime.parse(
                        "${(b.members?.chatMessageNode?.createdOn ?? b.members!.createdOn)!.split("+")[0]}Z")
                    .toLocal()
                    .compareTo(
                      DateTime.parse(
                              "${(a.members?.chatMessageNode?.createdOn ?? a.members!.createdOn)!.split("+")[0]}Z")
                          .toLocal(),
                    );
                return data;
              });
              resource.data!.memberResponseData!.memberData!.memberEdges!
                  .insert(0, you);

              replaceMemberOnlineStatus(you.members!.online! || false);
              break;
            }
          }

          await memberDao!.deleteWithFinder(
            Finder(
              filter: Filter.matchesRegExp(
                  "id", RegExp(memberId, caseSensitive: false)),
            ),
          );
          await memberDao!.insert(
            memberId,
            MemberData(
                pageInfo: pageInfo!,
                memberEdges:
                    resource.data!.memberResponseData!.memberData!.memberEdges,
                id: memberId),
          );

          if (!streamControllerMemberEdges.isClosed) {
            streamControllerMemberEdges.sink.add(Resources(Status.SUCCESS, "",
                resource.data!.memberResponseData!.memberData!.memberEdges));
          }

          return Resources(Status.SUCCESS, "",
              resource.data!.memberResponseData!.memberData!.memberEdges);
        } else {
          final Resources<MemberData>? memberList = await memberDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                  "id", RegExp(memberId, caseSensitive: false)),
            ),
          );
          if (!streamControllerMemberEdges.isClosed) {
            streamControllerMemberEdges.sink.add(
                Resources(Status.SUCCESS, "", memberList!.data!.memberEdges));
          }
          return Resources(Status.SUCCESS, "", memberList!.data!.memberEdges);
        }
      } else {
        final Resources<MemberData>? memberList = await memberDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
                "id", RegExp(memberId, caseSensitive: false)),
          ),
        );
        if (!streamControllerMemberEdges.isClosed) {
          streamControllerMemberEdges.sink.add(
              Resources(Status.SUCCESS, "", memberList?.data!.memberEdges));
        }

        return Resources(Status.SUCCESS, "", memberList?.data!.memberEdges);
      }
    } else {
      final Resources<MemberData>? memberList = await memberDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
              "id", RegExp(memberId, caseSensitive: false)),
        ),
      );
      if (!streamControllerMemberEdges.isClosed) {
        streamControllerMemberEdges.sink
            .add(Resources(Status.SUCCESS, "", memberList?.data!.memberEdges));
      }

      return Resources(Status.SUCCESS, "", memberList?.data!.memberEdges);
    }
  }

  Future<Resources<MemberData>?> getAllMembersFromDb(String memberId) async {
    final Resources<MemberData>? memberData = await memberDao!.getOne(
      finder: Finder(
        filter:
            Filter.matchesRegExp("id", RegExp(memberId, caseSensitive: false)),
      ),
    );
    return memberData;
  }

  Future<dynamic> doSearchMemberFromDb(String memberId, String query,
      bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    final Filter filterMember =
        Filter.matchesRegExp("id", RegExp(memberId, caseSensitive: false));
    final Resources<MemberData>? result = await memberDao!.getOne(
      finder: Finder(
        filter: filterMember,
      ),
    );

    final List<MemberEdges> memberEdges = [];

    for (final element in result!.data!.memberEdges!) {
      if (element.members!.fullName!
          .toLowerCase()
          .contains(query.toLowerCase())) {
        memberEdges.add(element);
      }
    }

    return memberEdges;
  }

  Future<dynamic> updateSubscriptionMemberOnline(
    MemberStatus memberStatus,
    StreamController<Resources<List<MemberEdges>>> streamController,
    String memberId,
  ) async {
    final Resources<MemberData>? result = await memberDao!.getOne(
      finder: Finder(
        filter:
            Filter.matchesRegExp("id", RegExp(memberId, caseSensitive: false)),
      ),
    );

    MemberEdges? you;
    for (int i = 0; i < result!.data!.memberEdges!.length; i++) {
      if (result.data!.memberEdges![i].members!.id == memberStatus.id) {
        result.data!.memberEdges![i].members!.online = memberStatus.online;
        break;
      }
    }

    for (int i = 0; i < result.data!.memberEdges!.length; i++) {
      if (result.data!.memberEdges![i].members!.id == memberId) {
        you = result.data!.memberEdges![i];
        result.data!.memberEdges!.removeAt(i);
        break;
      }
    }

    result.data!.memberEdges?.sort((a, b) {
      final int data = DateTime.parse(
              "${(b.members!.chatMessageNode?.createdOn ?? b.members!.createdOn)!.split("+")[0]}Z")
          .toLocal()
          .compareTo(
            DateTime.parse(
                    "${(a.members!.chatMessageNode?.createdOn ?? a.members!.createdOn)!.split("+")[0]}Z")
                .toLocal(),
          );
      return data;
    });
    result.data!.memberEdges!.insert(0, you!);

    await memberDao!.updateWithFinder(
      result.data!,
      Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(memberId, caseSensitive: false),
        ),
      ),
    );
    final Resources<MemberData>? dump = await memberDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(memberId, caseSensitive: false),
        ),
      ),
    );

    if (!streamController.isClosed) {
      if (result == null) {
        final Resources<MemberData>? reDump = await memberDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
                "id", RegExp(memberId, caseSensitive: false)),
          ),
        );
        streamController.sink
            .add(Resources(Status.SUCCESS, "", reDump!.data!.memberEdges));
      } else {
        streamController.sink
            .add(Resources(Status.SUCCESS, "", dump!.data!.memberEdges));
      }
    }

    return result.data;
  }

  Future<Stream<QueryResult>> doSubscriptionOnlineMemberStatus(
    String workspaceId,
    String memberId,
    Status status,
  ) async {
    return apiService!.doSubscriptionOnlineMemberStatus(workspaceId);
  }

  /// update subscription for member listing page
  Future<dynamic> doUpdateSubscriptionMemberChatDetail(
    String memberId,
    RecentConversationMemberNodes recentConversationMemberNodes,
    StreamController<Resources<List<MemberEdges>>> streamController,
  ) async {
    final Resources<MemberData>? dump = await memberDao!.getOne(
      finder: Finder(
        filter:
            Filter.matchesRegExp("id", RegExp(memberId, caseSensitive: false)),
      ),
    );

    for (int i = 0; i < dump!.data!.memberEdges!.length; i++) {
      if (dump.data!.memberEdges![i].members!.id == memberId &&
          dump.data!.memberEdges![i].members!.id ==
              recentConversationMemberNodes.sender!.id &&
          dump.data!.memberEdges![i].members!.id ==
              recentConversationMemberNodes.receiver!.id) {
        dump.data!.memberEdges![i].members = Members(
          id: dump.data!.memberEdges![i].members!.id,
          firstName: dump.data!.memberEdges![i].members!.firstName,
          lastName: dump.data!.memberEdges![i].members!.lastName,
          role: dump.data!.memberEdges![i].members!.role,
          gender: dump.data!.memberEdges![i].members!.gender,
          email: dump.data!.memberEdges![i].members!.email,
          createdOn: dump.data!.memberEdges![i].members!.createdOn,
          profilePicture: dump.data!.memberEdges![i].members!.profilePicture,
          numbers: dump.data!.memberEdges![i].members!.numbers,
          online: dump.data!.memberEdges![i].members!.online,
          unSeenMsgCount:
              dump.data!.memberEdges![i].members!.unSeenMsgCount != null
                  ? dump.data!.memberEdges![i].members!.unSeenMsgCount! + 1
                  : 0,
          onCall: dump.data!.memberEdges![i].members!.onCall,
          onlineConnection:
              dump.data!.memberEdges![i].members!.onlineConnection,
          chatMessageNode: ChatMessageNodes(
            id: recentConversationMemberNodes.id,
            message: recentConversationMemberNodes.message,
            createdOn: recentConversationMemberNodes.createdOn,
            modifiedOn: recentConversationMemberNodes.modifiedOn,
            sender: recentConversationMemberNodes.sender,
            receiver: recentConversationMemberNodes.receiver,
            status: recentConversationMemberNodes.status,
            type: recentConversationMemberNodes.type,
          ),
        );
        dump.data!.memberEdges![i].members!.chatMessageNode!.createdOn =
            recentConversationMemberNodes.createdOn;
        break;
      } else if (dump.data!.memberEdges![i].members!.id ==
              recentConversationMemberNodes.sender!.id &&
          dump.data!.memberEdges![i].members!.id != memberId) {
        dump.data!.memberEdges![i].members = Members(
          id: dump.data!.memberEdges![i].members!.id,
          firstName: dump.data!.memberEdges![i].members!.firstName,
          lastName: dump.data!.memberEdges![i].members!.lastName,
          role: dump.data!.memberEdges![i].members!.role,
          gender: dump.data!.memberEdges![i].members!.gender,
          email: dump.data!.memberEdges![i].members!.email,
          createdOn: dump.data!.memberEdges![i].members!.createdOn,
          profilePicture: dump.data!.memberEdges![i].members!.profilePicture,
          numbers: dump.data!.memberEdges![i].members!.numbers,
          online: dump.data!.memberEdges![i].members!.online,
          unSeenMsgCount:
              dump.data!.memberEdges![i].members!.unSeenMsgCount != null
                  ? dump.data!.memberEdges![i].members!.unSeenMsgCount! + 1
                  : 0,
          onCall: dump.data!.memberEdges![i].members!.onCall,
          onlineConnection:
              dump.data!.memberEdges![i].members!.onlineConnection,
          chatMessageNode: ChatMessageNodes(
            id: recentConversationMemberNodes.id,
            message: recentConversationMemberNodes.message,
            createdOn: recentConversationMemberNodes.createdOn,
            modifiedOn: recentConversationMemberNodes.modifiedOn,
            sender: recentConversationMemberNodes.sender,
            receiver: recentConversationMemberNodes.receiver,
            status: recentConversationMemberNodes.status,
            type: recentConversationMemberNodes.type,
          ),
        );
        dump.data!.memberEdges![i].members!.chatMessageNode!.createdOn =
            recentConversationMemberNodes.createdOn;
        break;
      } else if (dump.data!.memberEdges![i].members!.id ==
              recentConversationMemberNodes.receiver!.id &&
          dump.data!.memberEdges![i].members!.id != memberId) {
        dump.data!.memberEdges![i].members = Members(
          id: dump.data!.memberEdges![i].members!.id,
          firstName: dump.data!.memberEdges![i].members!.firstName,
          lastName: dump.data!.memberEdges![i].members!.lastName,
          role: dump.data!.memberEdges![i].members!.role,
          gender: dump.data!.memberEdges![i].members!.gender,
          email: dump.data!.memberEdges![i].members!.email,
          createdOn: dump.data!.memberEdges![i].members!.createdOn,
          profilePicture: dump.data!.memberEdges![i].members!.profilePicture,
          numbers: dump.data!.memberEdges![i].members!.numbers,
          online: dump.data!.memberEdges![i].members!.online,
          unSeenMsgCount:
              dump.data!.memberEdges![i].members!.unSeenMsgCount != null
                  ? dump.data!.memberEdges![i].members!.unSeenMsgCount! + 1
                  : 0,
          onCall: dump.data!.memberEdges![i].members!.onCall,
          onlineConnection:
              dump.data!.memberEdges![i].members!.onlineConnection,
          chatMessageNode: ChatMessageNodes(
            id: recentConversationMemberNodes.id,
            message: recentConversationMemberNodes.message,
            createdOn: recentConversationMemberNodes.createdOn,
            modifiedOn: recentConversationMemberNodes.modifiedOn,
            sender: recentConversationMemberNodes.sender,
            receiver: recentConversationMemberNodes.receiver,
            status: recentConversationMemberNodes.status,
            type: recentConversationMemberNodes.type,
          ),
        );
        dump.data!.memberEdges![i].members!.chatMessageNode!.createdOn =
            recentConversationMemberNodes.createdOn;
        break;
      }
    }

    MemberEdges? you;
    for (int i = 0; i < dump.data!.memberEdges!.length; i++) {
      if (dump.data!.memberEdges![i].members!.id == memberId) {
        you = dump.data!.memberEdges![i];
        dump.data!.memberEdges!.removeAt(i);
        break;
      }
    }
    // print("this is data ${MemberData().toMap(dump.data?.memberEdges)}");

    dump.data?.memberEdges?.sort((a, b) {
      final int data = DateTime.parse(
              "${(b.members?.chatMessageNode?.createdOn ?? b.members?.createdOn)?.split("+")[0]}Z")
          .toLocal()
          .compareTo(
            DateTime.parse(
                    "${(a.members?.chatMessageNode?.createdOn ?? a.members?.createdOn)?.split("+")[0]}Z")
                .toLocal(),
          );
      return data;
    });

    dump.data!.memberEdges!.insert(0, you!);

    await memberDao!.updateWithFinder(
      dump.data!,
      Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(memberId, caseSensitive: false),
        ),
      ),
    );
    final Resources<MemberData>? result = await memberDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(memberId, caseSensitive: false),
        ),
      ),
    );

    if (!streamController.isClosed) {
      if (result == null) {
        final Resources<MemberData>? reDump = await memberDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
                "id", RegExp(memberId, caseSensitive: false)),
          ),
        );
        streamController.sink
            .add(Resources(Status.SUCCESS, "", reDump!.data!.memberEdges));
      } else {
        streamController.sink
            .add(Resources(Status.SUCCESS, "", result.data!.memberEdges));
      }
    }
  }

  /// do call subscription api for workspace member chat
  Future<Stream<QueryResult>> doSubscriptionWorkspaceChatDetail() async {
    return apiService!.doSubscriptionWorkspaceChat();
  }

  Future<dynamic> doEditMemberChatSeenApiCall(
    String memberId,
    String senderId,
    StreamController<Resources<List<MemberEdges>>> streamController,
    Map<String, dynamic> param,
    bool isConnectedToInternet,
  ) async {
    if (isConnectedToInternet) {
      final Resources<MemberChatSeenResponse> resource =
          await apiService!.doEditMemberChatSeenApiCall(param);

      if (resource.status == Status.SUCCESS) {
        MemberEdges filterMember = MemberEdges();
        if (resource.data!.memberChatSeenResponseData!.error == null) {
          final Resources<MemberData>? result = await memberDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                  "id", RegExp(memberId, caseSensitive: false)),
            ),
          );
          final List<MemberEdges> filterList =
              result!.data!.memberEdges!.where((data) {
            if (data.members!.id == memberId) {
              return true;
            } else {
              return false;
            }
          }).toList();

          if (filterList.isNotEmpty) {
            filterMember = filterList.first;
            filterMember.members!.unSeenMsgCount = 0;
            // filterMember.members.unSeenMsgCount ++;

            await memberDao!.update(
              MemberData(
                id: memberId,
                // memberEdges: filterMember,
                pageInfo: pageInfo!,
              ),
              finder: Finder(
                filter: Filter.matchesRegExp(
                  "node.id",
                  RegExp(memberId, caseSensitive: false),
                ),
              ),
            );
            final Resources<MemberData>? updatedResources =
                await memberDao!.getOne(
              finder: Finder(
                filter: Filter.matchesRegExp(
                  "id",
                  RegExp(memberId, caseSensitive: false),
                ),
              ),
            );
            if (!streamController.isClosed) {
              streamController.sink.add(Resources(
                  Status.SUCCESS, "", updatedResources!.data!.memberEdges));
            }
            return Resources(Status.SUCCESS, "", updatedResources!.data);
          } else {
            Resources(Status.ERROR, "", []);
          }
        } else {
          return Resources(Status.ERROR,
              resource.data!.memberChatSeenResponseData!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }
}
