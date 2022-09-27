/*
 * *
 *  * Created by Kedar on 7/29/21 11:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 11:47 AM
 *  
 */

import "dart:async";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/TeamDao.dart";
import "package:mvp/db/TeamsMemberDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/SearchConversationRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/teamsMemberListRequestParamHolder/TeamsMemberListRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/teamsMemberListUpdateRequestParamHolder/TeamsMemberListUpdateRequestParamHolder.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/members/Members.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";
import "package:mvp/viewObject/model/teams/TeamsResponse.dart";
import "package:mvp/viewObject/model/teamsMemberList/TeamsMemberListResponse.dart";
import "package:mvp/viewObject/model/updateTeamsMemberList/UpdateTeamResponse.dart";
import "package:sembast/sembast.dart";

class TeamRepository extends Repository {
  TeamRepository({
    required this.apiService,
    required this.teamDao,
    required this.teamsMemberDao,
  });

  ApiService apiService;
  TeamDao teamDao;
  TeamsMemberDao teamsMemberDao;
  String primaryKey = "id";

  Future<Resources<List<Teams>>> doGetTeamsApiCall(
      StreamController<Resources<List<Teams>>> streamControllerTeams,
      int limit,
      bool isConnectedToInternet,
      Status status) async {
    final Finder finder =
        Finder(filter: Filter.equals("workspaceId", getDefaultWorkspace()));
    if (isConnectedToInternet) {
      final Resources<TeamsResponse> resource =
          await apiService.getTeamList(Map.from({}));
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null) {
          if (resource.data!.data!.teams != null) {
            await teamDao.deleteAll();
            await teamDao.insertAll(
                primaryKey,
                resource.data!.data!.teams!.map((e) {
                  e.workspaceId = getDefaultWorkspace();
                  return e;
                }).toList());
            sinkTeamList(streamControllerTeams,
                Resources(Status.SUCCESS, "", resource.data!.data!.teams));
            return Resources(Status.SUCCESS, "", resource.data!.data!.teams);
          } else {
            sinkTeamList(
                streamControllerTeams, await teamDao.getAll(finder: finder));
            return teamDao.getAll(finder: finder);
          }
        } else {
          sinkTeamList(
              streamControllerTeams, await teamDao.getAll(finder: finder));
          return teamDao.getAll(finder: finder);
        }
      } else {
        sinkTeamList(
            streamControllerTeams, await teamDao.getAll(finder: finder));
        return teamDao.getAll(finder: finder);
      }
    } else {
      sinkTeamList(streamControllerTeams, await teamDao.getAll(finder: finder));
      return teamDao.getAll(finder: finder);
    }
  }

  void sinkTeamList(
      StreamController<Resources<List<Teams>>> streamControllerTeams,
      Resources<List<Teams>> resources) {
    if (!streamControllerTeams.isClosed) {
      streamControllerTeams.sink.add(resources);
    }
  }

  Future<Resources<List<Teams>>> doSearchTeamsLocally(String text) async {
    final Finder finder = Finder(
        filter:
            Filter.matchesRegExp("title", RegExp(text, caseSensitive: false)));
    final Resources<List<Teams>> listTags =
        await teamDao.getAll(finder: finder);
    return listTags;
  }

  Future<Resources<List<MemberEdges>>> doGetAllTeamsMemberApiCall(
      String teamId, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final TeamsMemberListRequestParamHolder listRequestParamHolder =
          TeamsMemberListRequestParamHolder(
        teamId: teamId,
        param: SearchConversationRequestParamHolder(
          first: 1000,
        ),
      );
      final Resources<TeamsMemberListResponse> resource =
          await apiService.doGetAllTeamsMemberApiCall(listRequestParamHolder);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.memberListResponseData!.error == null) {
          for (final element in resource.data!.memberListResponseData!.memberData!.memberEdges!) {
            element.teamId = teamId;
            teamsMemberDao.updateOrInsert(
              element.members!.id,
              MemberEdges().toMap(element),
            );
          }
          return Resources(Status.SUCCESS, "", resource.data!.memberListResponseData!.memberData!.memberEdges);
        } else {
          return teamsMemberDao.getAll(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "teamId",
                RegExp(teamId, caseSensitive: false),
              ),
            ),
          );
        }
      } else {
        return teamsMemberDao.getAll(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "teamId",
              RegExp(teamId, caseSensitive: false),
            ),
          ),
        );
      }
    } else {
      return teamsMemberDao.getAll(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "teamId",
            RegExp(teamId, caseSensitive: false),
          ),
        ),
      );
    }
  }

  Future<dynamic> doSearchTeamsMemberFromDb(
      String query, bool isConnectedToInternet, int limit, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<List<MemberEdges>> result = await teamsMemberDao.getAll();

    Utils.cPrint(result.data!.length.toString());
    final List<MemberEdges> memberEdges = [];

    for (final element in result.data!) {
      if (element.members!.fullName!
          .toLowerCase()
          .contains(query.toLowerCase())) {
        memberEdges.add(element);
      }
    }

    return memberEdges;
  }

  Future<Resources<UpdateTeamResponse>> doUpdateTeamsMemberApiCall(
      String teamId,
      List<String> members,
      bool isConnectedToInternet,
      int limit,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final TeamsMemberListUpdateRequestParamHolder
          teamsMemberListUpdateRequestParamHolder =
          TeamsMemberListUpdateRequestParamHolder(
        teamId: teamId,
        data: TeamsMemberListMemberUpdateDataRequestParamHolder(
          memberId: members,
        ),
      );
      final Resources<UpdateTeamResponse> resource = await apiService.doUpdateTeamsMemberApiCall(teamsMemberListUpdateRequestParamHolder);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.SUCCESS, "", null);
        }
      } else {
        return Resources(Status.SUCCESS, "", null);
      }
    } else {
      return Resources(Status.SUCCESS, "", null);
    }
  }

  void loadInitialMembers(
      List<Members> members,
      StreamController<Resources<List<MemberEdges>>>
          streamControllerMemberEdges) {
    final List<MemberEdges> list = members.map((e) {
      return MemberEdges(cursor: e.id, members: e);
    }).toList();
    if (!streamControllerMemberEdges.isClosed) {
      streamControllerMemberEdges.sink.add(Resources(Status.SUCCESS, "", list));
    }
  }
}
