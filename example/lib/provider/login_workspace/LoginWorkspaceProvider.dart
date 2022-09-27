import "dart:async";
import "dart:convert";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/holder/request_holder/channelDnd/ChannelDndParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/agent/AgentInfo.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDnd.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDndResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/getWorkspaceCredit/WorkspaceCredit.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:mvp/viewObject/model/overview/OverviewData.dart";
import "package:mvp/viewObject/model/refreshToken/RefreshTokenResponse.dart";
import "package:mvp/viewObject/model/userDnd/Dnd.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissions.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListData.dart";

class LoginWorkspaceProvider extends Provider {
  LoginWorkspaceProvider({
    required this.loginWorkspaceRepository,
    this.valueHolder,
    int limit = 0,
  }) : super(loginWorkspaceRepository!, limit) {
    isDispose = false;

    loginWorkspaceListStream =
        StreamController<Resources<WorkspaceListData>>.broadcast();
    loginWorkspaceListSubscription = loginWorkspaceListStream!.stream
        .listen((Resources<WorkspaceListData> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _loginWorkspaceList = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    loginWorkspaceDetailStream =
        StreamController<Resources<Workspace>>.broadcast();
    loginWorkspaceDetailSubscription = loginWorkspaceDetailStream!.stream
        .listen((Resources<Workspace> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _loginWorkspaceDetail = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerChannelList =
        StreamController<Resources<ChannelData>>.broadcast();
    subscriptiionChannelList = streamControllerChannelList!.stream
        .listen((Resources<ChannelData> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _channelList = resource;
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });

    overviewDataStream = StreamController<Resources<OverViewData>>.broadcast();
    overviewDataSubscription =
        overviewDataStream!.stream.listen((Resources<OverViewData> resource) {
      _overviewData = resource;
      isLoading = false;
      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerUserPermissions =
        StreamController<Resources<UserPermissions>>.broadcast();
    subscriptionUserPermissions = streamControllerUserPermissions!.stream
        .listen((Resources<UserPermissions> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _userPermissions = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerNumberSettings =
        StreamController<Resources<NumberSettings>>.broadcast();
    subscriptionNumberSettings = streamControllerNumberSettings!.stream
        .listen((Resources<NumberSettings> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _numberSettings = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerChannelDndTimeList =
        StreamController<List<ChannelDnd>>.broadcast();
    subscriptionChannelDndTimeList = streamControllerChannelDndTimeList!.stream
        .listen((List<ChannelDnd> data) {
      {
        _channelDndTimeList = data;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });

    streamControllerChannelDnd = StreamController<Resources<Dnd>>.broadcast();
    subscriptionChannelDnd =
        streamControllerChannelDnd!.stream.listen((Resources<Dnd> resource) {
      _channelDnd = resource;
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  LoginWorkspaceRepository? loginWorkspaceRepository;
  ValueHolder? valueHolder;

  ///Workspace Detail
  StreamController<Resources<WorkspaceListData>>? loginWorkspaceListStream;
  StreamSubscription<Resources<WorkspaceListData>>?
      loginWorkspaceListSubscription;
  Resources<WorkspaceListData>? _loginWorkspaceList =
      Resources<WorkspaceListData>(Status.NO_ACTION, "", null);

  Resources<WorkspaceListData>? get loginWorkspaceList => _loginWorkspaceList;

  ///Workspace Detail
  StreamController<Resources<Workspace>>? loginWorkspaceDetailStream;
  StreamSubscription<Resources<Workspace>>? loginWorkspaceDetailSubscription;
  Resources<Workspace>? _loginWorkspaceDetail =
      Resources<Workspace>(Status.NO_ACTION, "", null);

  Resources<Workspace>? get loginWorkspaceDetail => _loginWorkspaceDetail;

  ///Channel List
  StreamController<Resources<ChannelData>>? streamControllerChannelList;
  StreamSubscription<Resources<ChannelData>>? subscriptiionChannelList;
  Resources<ChannelData>? _channelList =
      Resources<ChannelData>(Status.NO_ACTION, "", null);

  Resources<ChannelData>? get channelList => _channelList;

/*overview*/
  StreamController<Resources<OverViewData>>? overviewDataStream;
  StreamSubscription<Resources<OverViewData>>? overviewDataSubscription;
  Resources<OverViewData>? _overviewData =
      Resources<OverViewData>(Status.NO_ACTION, "", null);

  Resources<OverViewData>? get overviewData => _overviewData;

  StreamController<Resources<UserPermissions>>? streamControllerUserPermissions;
  StreamSubscription<Resources<UserPermissions>>? subscriptionUserPermissions;
  Resources<UserPermissions>? _userPermissions =
      Resources<UserPermissions>(Status.NO_ACTION, "", null);

  Resources<UserPermissions>? get userPermissions => _userPermissions;

  StreamController<Resources<NumberSettings>>? streamControllerNumberSettings;
  StreamSubscription<Resources<NumberSettings>>? subscriptionNumberSettings;
  Resources<NumberSettings>? _numberSettings =
      Resources<NumberSettings>(Status.NO_ACTION, "", null);

  Resources<NumberSettings>? get numberSettings => _numberSettings;

  LoginWorkspace? activeWorkSpace;

  StreamController<List<ChannelDnd>>? streamControllerChannelDndTimeList;
  StreamSubscription<List<ChannelDnd>>? subscriptionChannelDndTimeList;
  List<ChannelDnd>? _channelDndTimeList = [];

  List<ChannelDnd>? get channelDndTimeList => _channelDndTimeList;

  StreamController<Resources<Dnd>>? streamControllerChannelDnd;
  StreamSubscription<Resources<Dnd>>? subscriptionChannelDnd;
  Resources<Dnd>? _channelDnd = Resources<Dnd>(Status.NO_ACTION, "", null);

  Resources<Dnd>? get channelDnd => _channelDnd;

  @override
  void dispose() {
    loginWorkspaceListSubscription!.cancel();
    loginWorkspaceListStream!.close();

    loginWorkspaceDetailSubscription!.cancel();
    loginWorkspaceDetailStream!.close();

    overviewDataSubscription!.cancel();
    overviewDataStream!.close();

    streamControllerUserPermissions!.close();
    subscriptionUserPermissions!.cancel();

    streamControllerNumberSettings!.close();
    subscriptionNumberSettings!.cancel();

    streamControllerChannelDndTimeList!.close();
    subscriptionChannelDndTimeList!.cancel();

    streamControllerChannelDnd!.close();
    subscriptionChannelDnd!.cancel();

    streamControllerChannelList!.close();
    subscriptiionChannelList!.cancel();

    isDispose = true;
    super.dispose();
  }

  Future<dynamic> doGetWorkSpaceListApiCall(String? primaryKey) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    _loginWorkspaceList =
        await loginWorkspaceRepository!.doGetWorkSpaceListApiCall(
      loginWorkspaceListStream,
      primaryKey,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
    return _loginWorkspaceList;
  }

  Future<Resources<Workspace>?>? doWorkSpaceDetailApiCall(
      String accessToken) async {
    if (accessToken.isNotEmpty) {
      isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      _loginWorkspaceDetail =
          await loginWorkspaceRepository!.doWorkSpaceDetailApiCall(
        loginWorkspaceDetailStream!,
        accessToken,
        isConnectedToInternet,
        limit,
        offset,
        Status.PROGRESS_LOADING,
      );
      return _loginWorkspaceDetail;
    }
    return null;
  }

  Future<Resources<ChannelData>?> doChannelListApiCall(
      String accessToken) async {
    if (getApiToken().isNotEmpty) {
      isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      _channelList = await loginWorkspaceRepository!.doChannelListApiCall(
        streamControllerChannelList!,
        streamControllerNumberSettings!,
        accessToken,
        isConnectedToInternet,
        limit,
        offset,
        Status.PROGRESS_LOADING,
      );
      return _channelList;
    }

    return null;
  }

  Future<Resources<ChannelData>?> doChannelListForDashboardApiCall(
      String accessToken) async {
    if (getApiToken().isNotEmpty) {
      isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      _channelList =
          await loginWorkspaceRepository!.doChannelListForDashboardApiCall(
        streamControllerChannelList!,
        streamControllerNumberSettings!,
        accessToken,
        isConnectedToInternet,
        limit,
        offset,
        Status.PROGRESS_LOADING,
      );
      return _channelList;
    }

    return null;
  }

  Future<Resources<ChannelData>?> doChannelListOnlyApiCall(
      String accessToken) async {
    if (getApiToken().isNotEmpty) {
      isLoading = true;
      isConnectedToInternet = await Utils.checkInternetConnectivity();
      try {
        _channelList = await loginWorkspaceRepository?.doChannelListOnlyApiCall(
          streamControllerChannelList!,
          streamControllerNumberSettings!,
          accessToken,
          isConnectedToInternet,
          limit,
          offset,
          Status.PROGRESS_LOADING,
        );
      } catch (_) {}
      return _channelList;
    }

    return null;
  }

  Future<Resources<ChannelData>?> doSearchChannelFromDB(String query) async {
    isLoading = true;
    _channelList = await loginWorkspaceRepository?.doSearchChannelFromDB(
      query,
      limit,
      offset,
      Status.PROGRESS_LOADING,
    );
    if (!streamControllerChannelList!.isClosed) {
      streamControllerChannelList!.sink.add(_channelList!);
    }
    return _channelList;
  }

  Future<dynamic> getChannelInfo(String? channelId) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await loginWorkspaceRepository!.getChannelDetails(
      streamControllerChannelDnd!,
      streamControllerChannelDndTimeList!,
      channelId,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  Future<Resources<Member>?> doWorkSpaceLogin(
      Map<dynamic, dynamic> jsonMap) async {
    if (getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();

      return loginWorkspaceRepository!.doWorkSpaceLogin(
        jsonMap as Map<String, dynamic>,
        isConnectedToInternet,
        limit,
        offset,
        Status.PROGRESS_LOADING,
      );
    }
    return null;
  }

  Future<dynamic> doVoiceTokenApiCall(Map<String, dynamic> jsonMap) async {
    if (getApiToken().isNotEmpty) {
      isLoading = true;

      isConnectedToInternet = await Utils.checkInternetConnectivity();
      return loginWorkspaceRepository!.doVoiceTokenApiCall(
        jsonMap,
        isConnectedToInternet,
        limit,
        offset,
        Status.PROGRESS_LOADING,
      );
    }
  }

  Future<Resources<RefreshTokenResponse>> doRefreshTokenApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!
        .doRefreshTokenApiCall(isConnectedToInternet: isConnectedToInternet);
  }

  Future<dynamic> doDeviceRegisterApiCall(Map<dynamic, dynamic> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await loginWorkspaceRepository!.doDeviceRegisterApiCall(
        jsonMap, isConnectedToInternet, Status.PROGRESS_LOADING);
  }

  Future<Resources<OverViewData>> doPlanOverViewApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    overviewDataStream!.sink.add(Resources(Status.PROGRESS_LOADING, "", null));
    final Resources<OverViewData> resources =
        await loginWorkspaceRepository!.doPlanOverViewApiCall(
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );

    if (!overviewDataStream!.isClosed) {
      overviewDataStream!.sink.add(resources);
    }
    return resources;
  }

  Future<Resources<String>> doEditWorkspaceImageApiCall(
      Map<String, String> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doEditWorkspaceImageApiCall(
      jsonMap,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  Future<Resources<UserPermissions>> doGetUserPermissions() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doGetUserPermissions(
      streamControllerUserPermissions!,
      limit,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  bool getWorkSpaceStatus(LoginWorkspace data) {
    if (data.status != null && data.status == "Active") {
      return true;
    } else {
      return false;
    }
  }

  Future<Resources<NumberSettings>> doGetNumberSettings(
      SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder,
      {bool isFromServer = true}) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<NumberSettings> resourcesNumberSettings =
        await loginWorkspaceRepository!.doGetNumberSettings(
      streamControllerNumberSettings!,
      subscriptionUpdateConversationDetailRequestHolder,
      limit,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
      isLoadFromServer: isFromServer,
    );

    if (resourcesNumberSettings.status == Status.SUCCESS) {
      if (resourcesNumberSettings.data != null) {
        if (!streamControllerNumberSettings!.isClosed) {
          streamControllerNumberSettings!.sink.add(resourcesNumberSettings);
        }
      }
    }
    return resourcesNumberSettings;
  }

  bool checkCardDetailBeforeLoginToWorkspace(LoginWorkspace workspace) {
    return workspace.plan != null && workspace.plan!.cardInfo!;
  }

  bool getAndCompareIsAgentLoggedInMember(AgentInfo? agentInfo) {
    return psRepository.getMemberId() == agentInfo!.agentId!.trim();
  }

  Future<Resources<NumberSettings>> updateChannelDetails(
      Map<String, dynamic> map) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!
        .updateChannelDetails(isConnectedToInternet, map);
  }

  Future<Resources<ChannelDndResponse>> doSetChannelDndApiCall(
      ChannelDndHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doSetChannelDndApiCall(
        isConnectedToInternet, streamControllerChannelDnd!, holder);
  }

  String getDndTime(Resources<Dnd> data) {
    String dndStatus = "";
    if (data.data != null) {
      if (data.data!.dndEnabled != null && !data.data!.dndEnabled!) {
        dndStatus = Utils.getString("off");
      } else {
        if (data.data!.dndEndtime != null) {
          if (data.data!.dndEndtime == 0) {
            dndStatus = Config.channelDndTimeList[0]!.title!;
          } else {
            dndStatus =
                "${Utils.getString("untill")} ${Utils.fromUnixTimeStampToDate("MMM dd, hh:mm a", data.data!.dndEndtime!)}";
          }
        }
      }
    } else {
      dndStatus = Utils.getString("");
    }
    return dndStatus;
  }

  Future<Resources<ChannelDndResponse>> doOnRemoveDndApiCall(
      ChannelDndHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doOnRemoveDndApiCall(
      isConnectedToInternet,
      streamControllerChannelDnd!,
      holder,
    );
  }

  Future<bool> getChannelDndTimeList(bool status) async {
    loginWorkspaceRepository!
        .getChannelDndTimeList(streamControllerChannelDndTimeList!, status);
    return Future.value(true);
  }

  void setChannelDndList(int time, ChannelDnd channelDnd) {
    loginWorkspaceRepository!.setChannelDndList(
        time, channelDnd, streamControllerChannelDndTimeList!);
  }

  void resetDndTimeList() {
    loginWorkspaceRepository!.resetChannelDndTimeList(-1);
  }

  Future<Resources<String>> doEditWorkspaceNameApiCall(String title) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doEditWorkspaceNameApiCall(
      title,
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }

  String getDefaultCountryDialCode() {
    String dialCode = "+1";
    final CountryCode countryCode = CountryCode.fromJson(
        json.decode(loginWorkspaceRepository!.getDefaultCountryCode())
            as Map<String, dynamic>);
    try {
      dialCode = countryCode.dialCode!;
    } catch (e) {}
    return dialCode;
  }

  Future<Resources<WorkspaceCreditResponse>> doWorkspaceCreditApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return loginWorkspaceRepository!.doWorkspaceCreditApiCall(
      isConnectedToInternet,
      Status.PROGRESS_LOADING,
    );
  }
}
