/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 7:52 AM
 *
 */

import "dart:async";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/TeamsRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:mvp/viewObject/model/members/Members.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";

class TeamProvider extends Provider {
  TeamProvider({required this.teamRepository, int limit = 20})
      : super(teamRepository!, limit) {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerTeams =
        StreamController<Resources<List<Teams>>>.broadcast();
    subscriptionTeams =
        streamControllerTeams!.stream.listen((Resources<List<Teams>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _teams = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

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
  }

  TeamRepository? teamRepository;
  ValueHolder? valueHolder;

  StreamController<Resources<List<Teams>>>? streamControllerTeams;
  StreamSubscription<Resources<List<Teams>>>? subscriptionTeams;

  Resources<List<Teams>> _teams =
      Resources<List<Teams>>(Status.NO_ACTION, "", null);

  Resources<List<Teams>>? get teams => _teams;

  StreamController<Resources<List<MemberEdges>>>? streamControllerMemberEdges;
  StreamSubscription<Resources<List<MemberEdges>>>? subscriptionMemberEdges;

  Resources<List<MemberEdges>> _memberEdges =
      Resources<List<MemberEdges>>(Status.NO_ACTION, "", null);

  Resources<List<MemberEdges>>? get memberEdges => _memberEdges;

  @override
  void dispose() {
    subscriptionTeams!.cancel();
    streamControllerTeams!.close();

    subscriptionMemberEdges!.cancel();
    streamControllerMemberEdges!.close();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetTeamsListApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<Teams>> resources =
        await teamRepository!.doGetTeamsApiCall(streamControllerTeams!, limit,
            isConnectedToInternet, Status.PROGRESS_LOADING);
    return resources;
  }

  Future<void> doDbTeamsSearch(String text) async {
    final Resources<List<Teams>> resources =
        await teamRepository!.doSearchTeamsLocally(text);
    streamControllerTeams!.sink.add(resources);
  }

  Future<dynamic> doGetAllTeamsMemberApiCall(String teamId) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _memberEdges = await teamRepository!.doGetAllTeamsMemberApiCall(
      teamId,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
    );
    streamControllerMemberEdges!.sink.add(_memberEdges);
    return _memberEdges;
  }

  Future<dynamic> doSearchTeamsMemberFromDb(String query) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    final List<MemberEdges> result =
        await teamRepository!.doSearchTeamsMemberFromDb(
                query, isConnectedToInternet, limit, Status.PROGRESS_LOADING)
            as List<MemberEdges>;
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

  Future<dynamic> doUpdateTeamsMemberApiCall(
      String teamId, List<String> members) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return teamRepository!.doUpdateTeamsMemberApiCall(
      teamId,
      members,
      isConnectedToInternet,
      limit,
      Status.PROGRESS_LOADING,
    );
  }

  void loadInitialMemberList(List<Members> members) {
    teamRepository!.loadInitialMembers(members, streamControllerMemberEdges!);
  }
}
