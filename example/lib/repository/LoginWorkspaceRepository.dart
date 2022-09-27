import "dart:async";
import "dart:convert";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/db/ChannelListDao.dart";
import "package:mvp/db/CountryDao.dart";
import "package:mvp/db/NumberSettingsDao.dart";
import "package:mvp/db/WorkSpaceDetailDao.dart";
import "package:mvp/db/WorkspaceListDao.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/holder/request_holder/channelDnd/ChannelDndParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/editWorkspaceRequestParamHolder/EditWorkspaceRequestParamHolder.dart";
import "package:mvp/viewObject/holder/request_holder/subscriptionConversationDetailRequestHolder/SubscriptionUpdateConversationDetailRequestHolder.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:mvp/viewObject/model/channel/ChannelInfoResponse.dart";
import "package:mvp/viewObject/model/channel/ChannelResponse.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDnd.dart";
import "package:mvp/viewObject/model/channelDnd/ChannelDndResponse.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/deviceInfo/DeviceInfoResponse.dart";
import "package:mvp/viewObject/model/editWorkspace/EditWorkspaceNameResponse.dart";
import "package:mvp/viewObject/model/editWorkspaceImage/EditWorkspaceImageResponse.dart";
import "package:mvp/viewObject/model/getWorkspaceCredit/WorkspaceCredit.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/memberLogin/Member.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettingsResponse.dart";
import "package:mvp/viewObject/model/numberSettings/UpdateNumberSettingResponse.dart";
import "package:mvp/viewObject/model/overview/OverViewResponse.dart";
import "package:mvp/viewObject/model/overview/OverviewData.dart";
import "package:mvp/viewObject/model/refreshToken/RefreshTokenResponse.dart";
import "package:mvp/viewObject/model/userDnd/Dnd.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/UserPermissionsResponse.dart";
import "package:mvp/viewObject/model/voiceToken/VoiceTokenResponse.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/WorkspaceChannel.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListData.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListResponse.dart";
import "package:sembast/sembast.dart";

class LoginWorkspaceRepository extends Repository {
  LoginWorkspaceRepository({
    required this.apiService,
    required this.workSpaceDao,
    required this.countryDao,
    required this.workspaceDetailDao,
    required this.numberSettingsDao,
    required this.channelListDao,
  });

  ApiService? apiService;
  WorkspaceListDao? workSpaceDao;
  CountryDao? countryDao;
  WorkspaceDetailDao? workspaceDetailDao;
  NumberSettingsDao? numberSettingsDao;
  ChannelListDao? channelListDao;

  Future<Resources<WorkspaceListData>> doGetWorkSpaceListApiCall(
    StreamController<Resources<WorkspaceListData>>? loginWorkspaceListStream,
    String? primaryKey,
    bool? isConnected,
    Status? status,
  ) async {
    final Resources<WorkspaceListData>? beforeLoadingDump =
        await workSpaceDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            primaryKey!,
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (!loginWorkspaceListStream!.isClosed) {
      loginWorkspaceListStream.sink.add(beforeLoadingDump!);
    }
    if (isConnected!) {
      final Resources<WorkspaceListResponse> resources =
          await apiService!.doGetWorkSpaceListApiCall();
      if (resources.status == Status.SUCCESS) {
        if (resources.data != null &&
            resources.data!.data != null &&
            resources.data!.data!.data != null) {
          await workSpaceDao!.deleteWithFinder(
            Finder(
              filter: Filter.matches(
                "id",
                primaryKey,
              ),
            ),
          );
          resources.data!.data!.id = primaryKey;
          await workSpaceDao!.insert(primaryKey, resources.data!.data!);
          replaceWorkspaceList(resources.data!.data!.data);
          if (!loginWorkspaceListStream.isClosed) {
            loginWorkspaceListStream.sink
                .add(Resources(Status.SUCCESS, "", resources.data!.data));
          }
          return Resources(Status.SUCCESS, "", resources.data!.data);
        } else {
          final Resources<WorkspaceListData>? dump = await workSpaceDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(
                  primaryKey,
                  caseSensitive: false,
                ),
              ),
            ),
          );
          return Resources(Status.SUCCESS, "", dump!.data);
        }
      } else {
        final Resources<WorkspaceListData>? dump = await workSpaceDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                primaryKey,
                caseSensitive: false,
              ),
            ),
          ),
        );
        return Resources(Status.SUCCESS, "", dump!.data);
      }
    } else {
      final Resources<WorkspaceListData>? dump = await workSpaceDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              primaryKey,
              caseSensitive: false,
            ),
          ),
        ),
      );
      return Resources(Status.SUCCESS, "", dump!.data);
    }
  }

  Future<Resources<Workspace>?> doWorkSpaceDetailApiCall(
    StreamController<Resources<Workspace>> loginWorkspaceDetailStream,
    String accessToken,
    bool isConnectedToInternet,
    int limit,
    int offset,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    final Resources<Workspace>? beforeLoadingDump =
        await workspaceDetailDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getDefaultWorkspace(),
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (!loginWorkspaceDetailStream.isClosed) {
      loginWorkspaceDetailStream.sink.add(beforeLoadingDump!);
    }
    if (isConnectedToInternet) {
      final Resources<Workspace> resource =
          await apiService!.doWorkSpaceDetailApiCall(accessToken);

      if (resource.status == Status.SUCCESS &&
          resource.data!.workspace!.error == null) {
        ///Delete all workspace detail
        await workspaceDetailDao!.deleteAll();

        ///Insert the recent workspace detail
        resource.data!.id = getDefaultWorkspace();
        await workspaceDetailDao!.insert(getDefaultWorkspace(), resource.data!);

        ///Update default workspace detail
        replaceDefaultWorkspace(resource.data!.workspace!.data!.id!);

        ///Replace Workspace Detail
        replaceWorkspaceDetail(
            json.encode(resource.data!.workspace!.data!.toJson()));

        ///Fetch and Replace MemberId
        final List<LoginWorkspace> listLoginWorkspace = getWorkspaceList()!;

        if (listLoginWorkspace.isNotEmpty) {
          for (int i = 0; i < listLoginWorkspace.length; i++) {
            if (listLoginWorkspace[i].id ==
                resource.data!.workspace!.data!.id) {
              replaceMemberId(listLoginWorkspace[i].memberId!);
              break;
            }
          }
        }
        if (!loginWorkspaceDetailStream.isClosed) {
          loginWorkspaceDetailStream.sink.add(resource);
        }
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        final Resources<Workspace>? dump = await workspaceDetailDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                getDefaultWorkspace(),
                caseSensitive: false,
              ),
            ),
          ),
        );

        ///Update default workspace detail
        replaceDefaultWorkspace(dump!.data!.workspace!.data!.id!);

        ///Replace Workspace Detail
        replaceWorkspaceDetail(
            json.encode(dump.data!.workspace!.data!.toJson()));

        ///Fetch and Replace MemberId
        final List<LoginWorkspace>? listLoginWorkspace = getWorkspaceList();

        if (listLoginWorkspace != null && listLoginWorkspace.isNotEmpty) {
          for (int i = 0; i < listLoginWorkspace.length; i++) {
            if (listLoginWorkspace[i].id == dump.data!.workspace!.data!.id) {
              replaceMemberId(listLoginWorkspace[i].memberId!);
              break;
            }
          }
        }
        return Resources(Status.SUCCESS, "", dump.data);
      }
    } else {
      final Resources<Workspace>? dump = await workspaceDetailDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getDefaultWorkspace(),
              caseSensitive: false,
            ),
          ),
        ),
      );

      ///Update default workspace detail
      replaceDefaultWorkspace(dump!.data!.workspace!.data!.id!);

      ///Replace Workspace Detail
      replaceWorkspaceDetail(json.encode(dump.data!.workspace!.data!.toJson()));

      ///Fetch and Replace MemberId
      final List<LoginWorkspace>? listLoginWorkspace = getWorkspaceList();

      if (listLoginWorkspace != null && listLoginWorkspace.isNotEmpty) {
        for (int i = 0; i < listLoginWorkspace.length; i++) {
          if (listLoginWorkspace[i].id == dump.data!.workspace!.data!.id) {
            replaceMemberId(listLoginWorkspace[i].memberId!);
            break;
          }
        }
      }
      return Resources(Status.SUCCESS, "", dump.data);
    }
  }

  Future<Resources<ChannelData>> doChannelListApiCall(
    StreamController<Resources<ChannelData>> streamControllerChannelList,
    StreamController<Resources<NumberSettings>> streamControllerNumberSettings,
    String accessToken,
    bool isConnectedToInternet,
    int limit,
    int offset,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    final Resources<ChannelData>? beforeLoadingDump =
        await channelListDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getDefaultWorkspace(),
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (!streamControllerChannelList.isClosed) {
      streamControllerChannelList.sink.add(beforeLoadingDump!);
    }
    if (isConnectedToInternet) {
      final Resources<ChannelResponse> resource =
          await apiService!.doChannelListApiCall(accessToken);

      if (resource.status == Status.SUCCESS &&
          resource.data!.channels!.error == null) {
        ///Delete all channel detail
        await channelListDao!.deleteAll();

        ///Insert the recent channel detail
        resource.data!.channels!.id = getDefaultWorkspace();
        await channelListDao!
            .insert(getDefaultWorkspace(), resource.data!.channels!);

        ///Replace Default channel
        if (resource.data!.channels!.data != null &&
            resource.data!.channels!.data!.isNotEmpty) {
          ///Replace Default channel
          replaceDefaultChannel(
              json.encode(resource.data!.channels!.data![0].toJson()));

          ///Replace Default Dialcode
          final CountryCode dump = await Utils.getCountryCode(
              resource.data!.channels!.data![0].number!);
          // Utils.cPrint(dump.dialCode);
          // Utils.cPrint(dump.code);
          replaceCountryCode(dump);

          ///Replace Channel List
          final List<WorkspaceChannel> listChannel = [];
          for (final element in resource.data!.channels!.data!) {
            listChannel.add(element);

            ///Refresh Number Setting for all channel
            final SubscriptionUpdateConversationDetailRequestHolder
                subscriptionUpdateConversationDetailRequestHolder =
                SubscriptionUpdateConversationDetailRequestHolder(
              channelId: element.id!,
            );
            doGetNumberSettings(
              streamControllerNumberSettings,
              subscriptionUpdateConversationDetailRequestHolder,
              limit,
              isConnectedToInternet,
              Status.PROGRESS_LOADING,
            );
          }

          replaceChannelList(listChannel);
          if (!streamControllerChannelList.isClosed) {
            streamControllerChannelList.sink
                .add(Resources(Status.SUCCESS, "", resource.data!.channels));
          }
          return Resources(Status.SUCCESS, "", resource.data!.channels);
        } else {
          replaceDefaultChannel(null);
          replaceCountryCode(CountryCode(dialCode: "+1", code: "US"));
          replaceChannelList(null);
          return Resources(Status.SUCCESS, "", ChannelData(data: []));
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<ChannelData>> doChannelListForDashboardApiCall(
    StreamController<Resources<ChannelData>> streamControllerChannelList,
    StreamController<Resources<NumberSettings>> streamControllerNumberSettings,
    String accessToken,
    bool isConnectedToInternet,
    int limit,
    int offset,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    final Resources<ChannelData>? beforeLoadingDump =
        await channelListDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getDefaultWorkspace(),
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (!streamControllerChannelList.isClosed) {
      streamControllerChannelList.sink.add(beforeLoadingDump!);
    }
    if (isConnectedToInternet) {
      final Resources<ChannelResponse> resource =
          await apiService!.doChannelListApiCall(accessToken);

      if (resource.status == Status.SUCCESS &&
          resource.data!.channels!.error == null) {
        ///Delete all channel detail
        await channelListDao!.deleteAll();

        ///Insert the recent channel detail
        resource.data!.channels!.id = getDefaultWorkspace();
        await channelListDao!
            .insert(getDefaultWorkspace(), resource.data!.channels!);

        ///Replace Default channel
        if (resource.data!.channels!.data != null &&
            resource.data!.channels!.data!.isNotEmpty) {
          ///Replace Default channel
          if (getDefaultChannel().id != null &&
              getDefaultChannel().id!.isNotEmpty) {
            if (resource.data!.channels!.data!.indexWhere(
                    (element) => element.id == getDefaultChannel().id) !=
                -1) {
              replaceDefaultChannel(json.encode(resource
                  .data!
                  .channels!
                  .data![resource.data!.channels!.data!.indexWhere(
                      (element) => element.id == getDefaultChannel().id)]
                  .toJson()));
              /*replace channel list*/
              replaceChannelList(resource.data!.channels!.data);
              /*Replace Default Dial code*/
              final CountryCode dump = await Utils.getCountryCode(resource
                  .data!
                  .channels!
                  .data![resource.data!.channels!.data!.indexWhere((element) =>
                      element != null && element.id == getDefaultChannel().id!)]
                  .number!);
              replaceCountryCode(dump);
            } else {
              replaceDefaultChannel(
                  json.encode(resource.data!.channels!.data![0].toJson()));

              ///Replace Default Dialcode
              final CountryCode dump = await Utils.getCountryCode(
                  resource.data!.channels!.data![0].number!);

              replaceCountryCode(dump);
            }
          } else {
            replaceDefaultChannel(
                json.encode(resource.data!.channels!.data![0].toJson()));

            ///Replace Default Dialcode
            final CountryCode dump = await Utils.getCountryCode(
                resource.data!.channels!.data![0].number!);

            replaceCountryCode(dump);
          }

          ///Replace Channel List
          final List<WorkspaceChannel> listChannel = [];
          for (final element in resource.data!.channels!.data!) {
            listChannel.add(element);

            ///Refresh Number Setting for all channel
            final SubscriptionUpdateConversationDetailRequestHolder
                subscriptionUpdateConversationDetailRequestHolder =
                SubscriptionUpdateConversationDetailRequestHolder(
              channelId: element.id,
            );
            doGetNumberSettings(
              streamControllerNumberSettings,
              subscriptionUpdateConversationDetailRequestHolder,
              limit,
              isConnectedToInternet,
              Status.PROGRESS_LOADING,
            );
          }
          replaceChannelList(listChannel);
          if (!streamControllerChannelList.isClosed) {
            streamControllerChannelList.sink
                .add(Resources(Status.SUCCESS, "", resource.data!.channels));
          }
          return Resources(Status.SUCCESS, "", resource.data!.channels);
        } else {
          if (beforeLoadingDump!.data!.data != null &&
              beforeLoadingDump.data!.data!.isNotEmpty) {
            ///Replace Default channel
            if (getDefaultChannel() != null &&
                getDefaultChannel().id != null &&
                getDefaultChannel().id!.isNotEmpty) {
              if (beforeLoadingDump.data!.data!.indexWhere((element) =>
                      element != null &&
                      element.id == getDefaultChannel().id) !=
                  -1) {
                replaceDefaultChannel(json.encode(beforeLoadingDump
                    .data!
                    .data![beforeLoadingDump.data!.data!.indexWhere((element) =>
                        element != null &&
                        element.id == getDefaultChannel().id)]
                    .toJson()));
                /*replace channel list*/
                replaceChannelList(beforeLoadingDump.data!.data);
                /*Replace Default Dial code*/
                final CountryCode dump = await Utils.getCountryCode(
                    beforeLoadingDump
                        .data!
                        .data![beforeLoadingDump.data!.data!.indexWhere(
                            (element) =>
                                element != null &&
                                element.id == getDefaultChannel().id)]
                        .number!);
                replaceCountryCode(dump);
              } else {
                replaceDefaultChannel(
                    json.encode(beforeLoadingDump.data!.data![0].toJson()));

                ///Replace Default Dialcode
                final CountryCode dump = await Utils.getCountryCode(
                    beforeLoadingDump.data!.data![0].number!);

                replaceCountryCode(dump);
              }
            } else {
              replaceDefaultChannel(
                  json.encode(beforeLoadingDump.data!.data![0].toJson()));

              ///Replace Default Dialcode
              final CountryCode dump = await Utils.getCountryCode(
                  beforeLoadingDump.data!.data![0].number!);

              replaceCountryCode(dump);
            }

            ///Replace Channel List
            final List<WorkspaceChannel> listChannel = [];
            for (final element in beforeLoadingDump.data!.data!) {
              listChannel.add(element);

              ///Refresh Number Setting for all channel
              final SubscriptionUpdateConversationDetailRequestHolder
                  subscriptionUpdateConversationDetailRequestHolder =
                  SubscriptionUpdateConversationDetailRequestHolder(
                channelId: element.id,
              );
              doGetNumberSettings(
                streamControllerNumberSettings,
                subscriptionUpdateConversationDetailRequestHolder,
                limit,
                isConnectedToInternet,
                Status.PROGRESS_LOADING,
              );
            }
            replaceChannelList(listChannel);
            if (!streamControllerChannelList.isClosed) {
              streamControllerChannelList.sink
                  .add(Resources(Status.SUCCESS, "", beforeLoadingDump.data));
            }
            return Resources(Status.SUCCESS, "", beforeLoadingDump.data);
          } else {
            replaceDefaultChannel(null);
            replaceCountryCode(CountryCode(dialCode: "+1", code: "US"));
            replaceChannelList(null);
            return Resources(Status.SUCCESS, "", ChannelData(data: []));
          }
        }
      } else {
        if (beforeLoadingDump!.data!.data != null &&
            beforeLoadingDump.data!.data!.isNotEmpty) {
          ///Replace Default channel
          if (getDefaultChannel() != null &&
              getDefaultChannel().id != null &&
              getDefaultChannel().id!.isNotEmpty) {
            if (beforeLoadingDump.data!.data!.indexWhere((element) =>
                    element != null && element.id == getDefaultChannel().id) !=
                -1) {
              replaceDefaultChannel(json.encode(beforeLoadingDump
                  .data!
                  .data![beforeLoadingDump.data!.data!.indexWhere((element) =>
                      element != null && element.id == getDefaultChannel().id)]
                  .toJson()));
              /*replace channel list*/
              replaceChannelList(beforeLoadingDump.data!.data);
              /*Replace Default Dial code*/
              final CountryCode dump = await Utils.getCountryCode(
                  beforeLoadingDump
                      .data!
                      .data![beforeLoadingDump.data!.data!.indexWhere(
                          (element) =>
                              element != null &&
                              element.id == getDefaultChannel().id)]
                      .number!);
              replaceCountryCode(dump);
            } else {
              replaceDefaultChannel(
                  json.encode(resource.data!.channels!.data![0].toJson()));

              ///Replace Default Dialcode
              final CountryCode dump = await Utils.getCountryCode(
                  resource.data!.channels!.data![0].number!);

              replaceCountryCode(dump);
            }
          } else {
            replaceDefaultChannel(
                json.encode(resource.data!.channels!.data![0].toJson()));

            ///Replace Default Dialcode
            final CountryCode dump = await Utils.getCountryCode(
                resource.data!.channels!.data![0].number!);

            replaceCountryCode(dump);
          }

          ///Replace Channel List
          final List<WorkspaceChannel> listChannel = [];
          for (final element in resource.data!.channels!.data!) {
            listChannel.add(element);

            ///Refresh Number Setting for all channel
            final SubscriptionUpdateConversationDetailRequestHolder
                subscriptionUpdateConversationDetailRequestHolder =
                SubscriptionUpdateConversationDetailRequestHolder(
              channelId: element.id!,
            );
            doGetNumberSettings(
              streamControllerNumberSettings,
              subscriptionUpdateConversationDetailRequestHolder,
              limit,
              isConnectedToInternet,
              Status.PROGRESS_LOADING,
            );
          }
          replaceChannelList(listChannel);
          if (!streamControllerChannelList.isClosed) {
            streamControllerChannelList.sink
                .add(Resources(Status.SUCCESS, "", resource.data!.channels));
          }
          return Resources(Status.SUCCESS, "", resource.data!.channels);
        } else {
          replaceDefaultChannel(null);
          replaceCountryCode(CountryCode(dialCode: "+1", code: "US"));
          replaceChannelList(null);
          return Resources(Status.SUCCESS, "", ChannelData(data: []));
        }
      }
    } else {
      if (beforeLoadingDump!.data!.data != null &&
          beforeLoadingDump.data!.data!.isNotEmpty) {
        ///Replace Default channel
        if (getDefaultChannel() != null &&
            getDefaultChannel().id != null &&
            getDefaultChannel().id!.isNotEmpty) {
          if (beforeLoadingDump.data!.data!.indexWhere((element) =>
                  element != null && element.id == getDefaultChannel().id) !=
              -1) {
            replaceDefaultChannel(json.encode(beforeLoadingDump
                .data!
                .data![beforeLoadingDump.data!.data!.indexWhere((element) =>
                    element != null && element.id == getDefaultChannel().id)]
                .toJson()));
            /*replace channel list*/
            replaceChannelList(beforeLoadingDump.data!.data);
            /*Replace Default Dial code*/
            final CountryCode dump = await Utils.getCountryCode(
                beforeLoadingDump
                    .data!
                    .data![beforeLoadingDump.data!.data!.indexWhere((element) =>
                        element != null &&
                        element.id == getDefaultChannel().id)]
                    .number!);
            replaceCountryCode(dump);
          } else {
            replaceDefaultChannel(
                json.encode(beforeLoadingDump.data!.data![0].toJson()));

            ///Replace Default Dialcode
            final CountryCode dump = await Utils.getCountryCode(
                beforeLoadingDump.data!.data![0].number!);

            replaceCountryCode(dump);
          }
        } else {
          replaceDefaultChannel(
              json.encode(beforeLoadingDump.data!.data![0].toJson()));

          ///Replace Default Dialcode
          final CountryCode dump = await Utils.getCountryCode(
              beforeLoadingDump.data!.data![0].number!);

          replaceCountryCode(dump);
        }

        ///Replace Channel List
        final List<WorkspaceChannel> listChannel = [];
        for (final element in beforeLoadingDump.data!.data!) {
          listChannel.add(element);

          ///Refresh Number Setting for all channel
          final SubscriptionUpdateConversationDetailRequestHolder
              subscriptionUpdateConversationDetailRequestHolder =
              SubscriptionUpdateConversationDetailRequestHolder(
            channelId: element.id,
          );
          doGetNumberSettings(
            streamControllerNumberSettings,
            subscriptionUpdateConversationDetailRequestHolder,
            limit,
            isConnectedToInternet,
            Status.PROGRESS_LOADING,
          );
        }
        replaceChannelList(listChannel);
        if (!streamControllerChannelList.isClosed) {
          streamControllerChannelList.sink
              .add(Resources(Status.SUCCESS, "", beforeLoadingDump.data));
        }
        return Resources(Status.SUCCESS, "", beforeLoadingDump.data);
      } else {
        replaceDefaultChannel(null);
        replaceCountryCode(CountryCode(dialCode: "+1", code: "US"));
        replaceChannelList(null);
        return Resources(Status.SUCCESS, "", ChannelData(data: []));
      }
    }
  }

  Future<Resources<ChannelData>?>? doSearchChannelFromDB(
    String query,
    int limit,
    int offset,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    if (query.isNotEmpty) {
      final Resources<ChannelData>? dump = await channelListDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getDefaultWorkspace(),
              caseSensitive: false,
            ),
          ),
        ),
      );
      print(dump!.data!.toMap(dump.data));
      if (query.contains("+")) {
        final Resources<ChannelData> toReturn = Resources(
          Status.SUCCESS,
          "",
          ChannelData(status: 200, data: []),
        );
        for (final element in dump.data!.data!) {
          if (element.number!.toLowerCase().contains(query.toLowerCase())) {
            toReturn.data!.data!.add(element);
          }
        }
        return toReturn;
      } else {
        final Resources<ChannelData> toReturn = Resources(
          Status.SUCCESS,
          "",
          ChannelData(status: 200, data: []),
        );
        for (final element in dump.data!.data!) {
          if (element.name!.toLowerCase().contains(query.toLowerCase()) ||
              element.number!.toLowerCase().contains(query.toLowerCase())) {
            toReturn.data!.data!.add(element);
          }
        }
        return toReturn;
      }
    } else {
      return channelListDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(
              getDefaultWorkspace(),
              caseSensitive: false,
            ),
          ),
        ),
      );
    }
  }

  Future<Resources<ChannelData>> doChannelListOnlyApiCall(
    StreamController<Resources<ChannelData>> streamControllerChannelList,
    StreamController<Resources<NumberSettings>> streamControllerNumberSettings,
    String accessToken,
    bool isConnectedToInternet,
    int limit,
    int offset,
    Status status, {
    bool isLoadFromServer = true,
  }) async {
    final Resources<ChannelData>? beforeLoadingDump =
        await channelListDao!.getOne(
      finder: Finder(
        filter: Filter.matchesRegExp(
          "id",
          RegExp(
            getDefaultWorkspace(),
            caseSensitive: false,
          ),
        ),
      ),
    );

    if (!streamControllerChannelList.isClosed) {
      streamControllerChannelList.sink.add(beforeLoadingDump!);
    }

    if (isConnectedToInternet) {
      final Resources<ChannelResponse> resource =
          await apiService!.doChannelListApiCall(accessToken);

      if (resource.status == Status.SUCCESS &&
          resource.data!.channels!.error == null) {
        ///Delete all channel detail
        await channelListDao!.deleteAll();

        ///Insert the recent channel detail
        resource.data!.channels!.id = getDefaultWorkspace();
        await channelListDao!
            .insert(getDefaultWorkspace(), resource.data!.channels!);

        ///Replace Default channel
        if (resource.data!.channels!.data != null &&
            resource.data!.channels!.data!.isNotEmpty) {
          ///Replace Channel List
          final List<WorkspaceChannel> listChannel = [];
          for (final element in resource.data!.channels!.data!) {
            listChannel.add(element);
          }
          replaceChannelList(listChannel);
          if (!streamControllerChannelList.isClosed) {
            streamControllerChannelList.sink
                .add(Resources(Status.SUCCESS, "", resource.data!.channels));
          }
          return Future.value(
              Resources(Status.SUCCESS, "", resource.data!.channels));
        } else {
          replaceChannelList(null);
          return Future.value(
              Resources(Status.ERROR, Utils.getString("serverError"), null));
        }
      } else {
        replaceChannelList(null);
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Future.value(Resources(
          Status.SUCCESS,
          '',
          (await channelListDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(
                  getDefaultWorkspace(),
                  caseSensitive: false,
                ),
              ),
            ),
          ))
              ?.data));
    }
  }

  Future<dynamic> getChannelDetails(
      StreamController<Resources<Dnd>> streamControllerChannelDnd,
      StreamController<List<ChannelDnd>> streamControllerChannelDndTimeList,
      String? channelId,
      bool isConnectedToInternet,
      Status status) async {
    if (isConnectedToInternet) {
      final Resources<ChannelInfoResponse> resource =
          await apiService!.doGetChannelInfo(channelId);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.channelInfo != null &&
            resource.data!.channelInfo!.data != null) {
          final WorkspaceChannel w1 =
              WorkspaceChannel().fromMap(resource.data!.channelInfo!.data)!;
          replaceDefaultChannel(json.encode(w1));
          Dnd dnd;
          ChannelDnd channelDnd;
          if (w1.dndEnabled != null && w1.dndEnabled!) {
            dnd = Dnd(
                dndEndtime: w1.dndEndTime ?? 0,
                dndEnabled: w1.dndEnabled,
                dndRemainingTime: w1.dndRemainingTime);
            channelDnd = ChannelDnd(
                time: w1.dndDuration,
                title: w1.dndEndTime != null
                    ? Config.channelDndTimeList[w1.dndDuration]!.title
                    : Config.channelDndTimeList[0]!.title,
                status: true);
          } else {
            dnd = Dnd(
                dndEndtime: -1,
                dndEnabled: false,
                dndRemainingTime: w1.dndRemainingTime);
            channelDnd = ChannelDnd(
                time: -1,
                title: Config.channelDndTimeList[-1]!.title,
                status: true);
          }
          _updateDefaultChannel(dnd);
          /*update channel dnd status in stream*/
          _replaceUpdatedChannelDnd(
              streamControllerChannelDnd, Resources(Status.SUCCESS, "", dnd));
          /*update the channel dnd list to peferences and
               * update the stream */
          setChannelDndList(
              channelDnd.time!, channelDnd, streamControllerChannelDndTimeList);
        } else {
          _replaceUpdatedChannelDnd(
              streamControllerChannelDnd,
              Resources(
                  Status.SUCCESS, "", Dnd(dndEndtime: -1, dndEnabled: false)));
          _updateDefaultChannel(Dnd(dndEndtime: -1, dndEnabled: false));
          try {
            setChannelDndList(
                -1,
                ChannelDnd(
                    time: -1,
                    title: Config.channelDndTimeList[-1]!.title,
                    status: true),
                streamControllerChannelDndTimeList);
          } catch (e) {}
        }
      } else {
        getDefaultChannelDetails(streamControllerChannelDnd);
      }
    } else {
      getDefaultChannelDetails(streamControllerChannelDnd);
    }
  }

  Future<Resources<Member>> doWorkSpaceLogin(Map<String, dynamic> jsonMap,
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<Member> resource =
        await apiService!.doWorkSpaceLoginApiCall(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.data!.error == null) {
        replaceCallAccessToken(resource.data!.data!.data!.accessToken!);
        replaceRefreshToken(resource.data!.data!.data!.refreshToken!);
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(
            Status.ERROR, resource.data!.data!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<dynamic> doVoiceTokenApiCall(Map<String, dynamic> jsonMap,
      bool isConnectedToInternet, int limit, int offset, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<VoiceTokenResponse> resource =
        await apiService!.doVoiceTokenApiCall(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.voiceTokenData!.error == null) {
        if (resource.data!.voiceTokenData!.voiceToken!.voiceToken != null) {
          replaceVoiceToken(
              resource.data!.voiceTokenData!.voiceToken!.voiceToken!);
          return Resources(Status.SUCCESS, "",
              resource.data!.voiceTokenData!.voiceToken!.voiceToken);
        } else {
          replaceVoiceToken("");
          return Resources(Status.SUCCESS,
              resource.data!.voiceTokenData!.error!.message, null);
        }
      } else {
        return Resources(
            Status.ERROR, resource.data!.voiceTokenData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<RefreshTokenResponse>> doRefreshTokenApiCall(
      {bool isConnectedToInternet = true, bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<RefreshTokenResponse> resource =
          await apiService!.doRefreshTokenApiCall();
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.refreshTokenResponseData!.error == null) {
          if (resource.data!.refreshTokenResponseData!.data!.accessToken !=
              null) {
            replaceCallAccessToken(
                resource.data!.refreshTokenResponseData!.data!.accessToken!);

            return Resources(Status.SUCCESS, "", resource.data);
          } else {
            return Resources(
              Status.ERROR,
              resource.data!.refreshTokenResponseData!.error!.message,
              resource.data,
            );
          }
        } else {
          return Resources(
            Status.ERROR,
            resource.data!.refreshTokenResponseData!.error!.message,
            resource.data,
          );
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<DeviceInfoResponse>> doDeviceRegisterApiCall(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<DeviceInfoResponse> resource =
        await apiService!.doDeviceRegisterApiCall(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.deviceInfoData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(
            Status.ERROR, resource.data!.deviceInfoData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<OverViewData>> doPlanOverViewApiCall(
    bool isConnectedToInternet,
    Status status,
  ) async {
    if (isConnectedToInternet) {
      final Resources<OverviewResponse> resource =
          await apiService!.doPlanOverViewApiCall();
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null) {
          if (resource.data != null &&
              resource.data!.data != null &&
              resource.data!.data!.overviewData != null) {
            replacePlanOverview(resource.data!.data!.overviewData!);

            return Resources(
                Status.SUCCESS, "", resource.data!.data!.overviewData);
          } else {
            return Resources(
              Status.SUCCESS,
              "",
              getPlanOverview(),
            );
          }
        } else {
          return Resources(
            Status.SUCCESS,
            "",
            getPlanOverview(),
          );
        }
      } else {
        return Resources(
          Status.SUCCESS,
          "",
          getPlanOverview(),
        );
      }
    } else {
      return Resources(
        Status.SUCCESS,
        "",
        getPlanOverview(),
      );
    }
  }

  Future<Resources<String>> doEditWorkspaceImageApiCall(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      Status status) async {
    if (isConnectedToInternet) {
      final Resources<EditWorkspaceImageResponse> resources =
          await apiService!.doEditWorkspaceImageApiCall(jsonMap);
      if (resources.status == Status.SUCCESS) {
        if (resources.data!.editWorkspaceImageResponseData!.error == null) {
          final LoginWorkspace dump = getWorkspaceDetail()!;
          dump.photo =
              resources.data!.editWorkspaceImageResponseData!.data!.photo;
          replaceWorkspaceDetail(json.encode(dump));
          final List<LoginWorkspace> dump2 = getWorkspaceList()!;
          dump2[dump2.indexWhere((element) => element.id == dump.id)].photo =
              resources.data!.editWorkspaceImageResponseData!.data!.photo;
          replaceWorkspaceList(dump2);
          return Resources(Status.SUCCESS, "",
              resources.data!.editWorkspaceImageResponseData!.data!.photo);
        } else {
          return Resources(
              Status.SUCCESS,
              resources.data!.editWorkspaceImageResponseData!.error!.message,
              null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<UserPermissions>> doGetUserPermissions(
      StreamController<Resources<UserPermissions>>
          streamControllerUserPermissions,
      int limit,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<UserPermissionsResponse> resource =
          await apiService!.doGetUserPermissionsApiCall();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.userPermissionsResponseData!.error == null) {
          //Main Screen Workspace
          replaceAllowWorkspaceViewSwitchWorkspace(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenWorkspaceUserPermissions!
              .viewSwitchWorkspace);
          replaceAllowWorkspaceCreateWorkspace(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenWorkspaceUserPermissions!
              .createNewWorkspace!);
          replaceAllowWorkspaceEditWorkspace(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenWorkspaceUserPermissions!
              .editProfile);

          //Main Screen Navigation
          replaceAllowNavigationSearch(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .searchBox);
          replaceAllowNavigationShowDialer(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .showDialer);
          replaceAllowNavigationShowDashboard(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .dashboardView);
          replaceAllowNavigationShowContact(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .contactView);
          replaceAllowNavigationShowSetting(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .settingsView);
          replaceAllowNavigationAddNewNumber(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .numbersAddNew);
          replaceAllowNavigationViewNumberDetails(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .numbersViewDetails);
          replaceAllowNavigationNumberDnd(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .numbersDND);
          replaceAllowNavigationNumberSetting(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .numbersSettings);
          replaceAllowNavigationAddNewMember(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .membersAddNew);
          replaceAllowNavigationAddNewTeam(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .teamsAddNew);
          replaceAllowNavigationViewTagDetails(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .mainScreenUserPermissions!
              .mainScreenNavigationUserPermissions!
              .tagsViewDetails);
          //replaceAllowNavigationAddNewTags
          //Contacts Header
          replaceAllowContactSearchContact(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .contactsScreenUserPermissions!
              .contactScreenHeaderUserPermissions!
              .searchContact);
          replaceAllowContactAddNewContact(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .contactsScreenUserPermissions!
              .contactScreenHeaderUserPermissions!
              .addNewContact);
          replaceAllowContactCSVImport(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .contactsScreenUserPermissions!
              .contactScreenHeaderUserPermissions!
              .csvImport);

          ///Contacts Body
          replaceAllowShowTableView(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .contactsScreenUserPermissions!
              .contactScreenBodyUserPermissions!
              .tableView);

          ///
          ///Settings Profile
          replaceAllowProfileEditFullName(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenProfileUserPermissions!
              .editFullName);
          replaceAllowProfileEditEmail(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenProfileUserPermissions!
              .editEmail);
          replaceAllowProfileChangePassword(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenProfileUserPermissions!
              .changePassword);
          replaceAllowProfileChangeProfilePicture(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenProfileUserPermissions!
              .changeProfilePicture);

          ///
          ///Settings Numbers
          replaceAllowMyNumberPortConfig(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .portNumberConfig);
          replaceAllowMyNumberAddNewNumber(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .addNewNumber);
          replaceAllowMyNumberViewNumberList(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .viewNumberList);
          replaceAllowMyNumberEditDetails(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .editNumberDetails);
          replaceAllowMyNumberAutoRecord(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .autoRecordCalls);
          replaceAllowMyNumberInternationalCall(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .editToggleIntnCalls);
          replaceAllowMyNumberShareAccess(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .shareAccess);
          replaceAllowMyNumberAutoVoiceMailTranscription(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .autoVoicemailTranscription);
          replaceAllowMyNumberDelete(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNumbersUserPermissions!
              .deleteNumber);

          ///
          ///Settings Members
          replaceAllowMemberAddNewMember(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .addNewMember);
          replaceAllowMemberMemberList(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .membersListView);
          replaceAllowMemberViewAssignedNumber(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .membersViewAssignedNumber);
          replaceAllowMemberDeleteMember(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .deleteMember);
          replaceAllowMemberInvite(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .invitedMembersView);
          replaceAllowMemberReInvite(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenMembersUserPermissions!
              .invitedMembersResendInvite);

          ///
          ///Settings Teams
          replaceAllowTeamCreateTeam(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenTeamsUserPermissions!
              .createNewTeam);
          replaceAllowTeamTeamList(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenTeamsUserPermissions!
              .teamListView);
          replaceAllowTeamEdit(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenTeamsUserPermissions!
              .teamEdit);
          replaceAllowTeamDelete(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenTeamsUserPermissions!
              .teamDelete);

          ///
          ///Settings Contacts
          replaceAllowContactAddNewIntegration(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenContactsUserPermissions!
              .addNewIntegration);
          replaceAllowContactIntegrationGoogle(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenContactsUserPermissions!
              .integrationGoogle);
          replaceAllowContactIntegrationPipeDrive(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenContactsUserPermissions!
              .integrationPipeDrive);
          replaceAllowContactImportCsv(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenContactsUserPermissions!
              .csvImport);
          replaceAllowContactDeleteContacts(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenContactsUserPermissions!
              .deleteAllContacts);

          ///
          ///Settings Contacts
          replaceAllowWorkspaceUpdateProfilePicture(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenWorkplaceUserPermissions!
              .updateProfilePicture);
          replaceAllowWorkspaceChangeName(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenWorkplaceUserPermissions!
              .changeWorkplaceName);
          replaceAllowWorkspaceEnableNotification(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenWorkplaceUserPermissions!
              .enableNotification);
          replaceAllowWorkspaceDelete(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenWorkplaceUserPermissions!
              .deleteWorkplace);

          ///
          ///Settings Integration
          replaceAllowIntegrationEnabled(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenIntegrationUserPermissions!
              .viewEnabled);
          replaceAllowIntegrationOtherIntegration(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenIntegrationUserPermissions!
              .viewOtherIntegration);

          ///
          ///Settings Billing and plans
          replaceAllowBillingOverviewChangePlan(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewChangePlan);
          replaceAllowBillingOverviewPurchaseCredit(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewPurchaseCredit);
          replaceAllowBillingOverviewManageCardAdd(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewManageCardAdd);
          replaceAllowBillingOverviewManageCardDelete(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewManageCardDelete);
          replaceAllowBillingOverviewHideKrispcallBranding(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewHideKrispcallBranding);
          replaceAllowBillingOverviewNotificationAutoRecharge(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewNotificationAutoRecharge);
          replaceAllowBillingOverviewCancelSubscription(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .overviewCancelSubscription);
          replaceAllowBillingSaveBillingInfo(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .billingInfoSave);
          replaceAllowBillingReceiptsViewList(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .billingReceiptsViewList);
          replaceAllowBillingReceiptsViewInvoice(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .billingReceiptsViewInvoice);
          replaceAllowBillingReceiptsDownloadInvoice(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenBillingUserPermissions!
              .billingReceiptsDownloadInvoice);

          ///
          ///Settings Devices
          replaceAllowDeviceSelectInputDevice(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .selectInputDevice);

          replaceAllowDeviceSelectOutputDevice(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .selectOutputDevices);
          replaceAllowDeviceAdjustInputVolume(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .adjustInputVolume);
          replaceAllowDeviceAdjustOutputVolume(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .adjustOutputVolume);
          replaceAllowDeviceMicTest(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .microphoneTest);
          replaceAllowDeviceCancelEcho(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .cancelEcho);
          replaceAllowDeviceReduceNoise(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenDevicesUserPermissions!
              .reduceNoise);

          ///
          ///Settings Notifications
          replaceAllowNotificationEnableDesktopNotification(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNotificationsUserPermissions!
              .enableDesktopNotification);
          replaceAllowNotificationEnableNewCallMessage(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNotificationsUserPermissions!
              .enableNewCallsMessage);
          replaceAllowNotificationEnableNewLeads(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNotificationsUserPermissions!
              .enableNewLeads);
          replaceAllowNotificationEnableFlashTaskBar(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenNotificationsUserPermissions!
              .enableFlashTaskBar);

          ///
          ///Settings Language
          replaceAllowLanguageSwitch(resource
              .data!
              .userPermissionsResponseData!
              .userPermissions!
              .settingsScreenUserPermissions!
              .settingsScreenLanguageUserPermissions!
              .languageSwitch);

          ///
          /// Prefs Settings close
          streamControllerUserPermissions.sink.add(Resources(Status.SUCCESS, "",
              resource.data!.userPermissionsResponseData!.userPermissions));
          return Resources(Status.SUCCESS, "",
              resource.data!.userPermissionsResponseData!.userPermissions);
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

  Future<Resources<NumberSettings>> doGetNumberSettings(
      StreamController<Resources<NumberSettings>>
          streamControllerNumberSettings,
      SubscriptionUpdateConversationDetailRequestHolder
          subscriptionUpdateConversationDetailRequestHolder,
      int limit,
      bool isConnectedToInternet,
      Status status,
      {bool isLoadFromServer = true}) async {
    if (isLoadFromServer) {
      if (isConnectedToInternet) {
        final Resources<NumberSettingsResponse> resource = await apiService!
            .doGetNumberSettingsApiCall(
                subscriptionUpdateConversationDetailRequestHolder);

        if (resource.status == Status.SUCCESS) {
          if (resource.data!.numberSettingsResponseData!.error == null) {
            await numberSettingsDao!.deleteWithFinder(
              Finder(
                filter: Filter.matches(
                    "id",
                    subscriptionUpdateConversationDetailRequestHolder
                        .channelId!),
              ),
            );
            await numberSettingsDao!.insert(
                subscriptionUpdateConversationDetailRequestHolder.channelId!,
                resource.data!.numberSettingsResponseData!.numberSettings!);
            final Resources<NumberSettings> resources = Resources(
                Status.SUCCESS,
                "",
                resource.data!.numberSettingsResponseData!.numberSettings);
            sinkNumberSettingStream(streamControllerNumberSettings, resources);
            return resources;
          } else {
            return Resources(
                Status.ERROR,
                resource.data!.numberSettingsResponseData!.error!.message,
                null);
          }
        } else {
          return Resources(Status.ERROR, Utils.getString("serverError"), null);
        }
      } else {
        final Resources<NumberSettings>? resource =
            await numberSettingsDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(
                  subscriptionUpdateConversationDetailRequestHolder.channelId!,
                  caseSensitive: false),
            ),
          ),
        );
        sinkNumberSettingStream(streamControllerNumberSettings, resource!);
        return resource;
      }
    } else {
      final Resources<NumberSettings>? resource =
          await numberSettingsDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(subscriptionUpdateConversationDetailRequestHolder.channelId!,
                caseSensitive: false),
          ),
        ),
      );
      sinkNumberSettingStream(streamControllerNumberSettings, resource!);
      return resource;
    }
  }

  Future<void> replaceCountryCode(CountryCode countryCode) async {
    final Resources<CountryCode>? selectedCountyCode = await countryDao!.getOne(
        finder: Finder(
            filter: Filter.equals("alphaTwoCode", countryCode.code ?? "US")));
    if (selectedCountyCode?.data != null) {
      replaceDefaultCountryCode(jsonEncode(selectedCountyCode?.data));
    }
  }

  Future<Resources<NumberSettings>> updateChannelDetails(
      bool isConnectedToInternet, Map<String, dynamic> map) async {
    if (isConnectedToInternet) {
      final Resources<UpdateNumberSettingResponse> resource =
          await apiService!.updateChannelDetails(map);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null) {
          final WorkspaceChannel defaultChannel = getDefaultChannel();
          defaultChannel.name = resource.data!.data!.numberSettings!.name;
          replaceDefaultChannel(json.encode(defaultChannel));

          final List<WorkspaceChannel> channelList = getChannelList()!;
          channelList[channelList
                  .indexWhere((element) => element.id == defaultChannel.id)]
              .name = resource.data!.data!.numberSettings!.name;
          replaceChannelList(channelList);

          return Resources(
              Status.SUCCESS, "", resource.data!.data!.numberSettings);
        } else {
          return Resources(
              Status.ERROR, resource.data!.data!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  void sinkNumberSettingStream(
      StreamController<Resources<NumberSettings>>
          streamControllerNumberSettings,
      Resources<NumberSettings> resources) {
    if (!streamControllerNumberSettings.isClosed) {
      streamControllerNumberSettings.sink.add(resources);
    }
  }

  Future<Resources<ChannelDndResponse>> doSetChannelDndApiCall(
      bool isConnectedToInternet,
      StreamController<Resources<Dnd>> streamControllerChannelDnd,
      ChannelDndHolder holder) async {
    if (isConnectedToInternet) {
      final Resources<ChannelDndResponse> resource =
          await apiService!.onSetChannelDnd(holder.toMap());
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.channelDndResponse!.error == null) {
          DashboardView.subscriptionConversationSeen.fire(
            SubscriptionConversationSeenEvent(
              isSeen: true,
            ),
          );
          final WorkspaceChannel defaultChannel = getDefaultChannel();
          /*replace default channel details*/
          defaultChannel.dndEnabled =
              resource.data!.channelDndResponse!.data!.dndEnabled;
          defaultChannel.dndEndTime =
              resource.data!.channelDndResponse!.data!.dndEndtime ?? 0;
          defaultChannel.dndRemainingTime =
              resource.data!.channelDndResponse!.data!.dndRemainingTime;
          replaceDefaultChannel(json.encode(defaultChannel));

          /*update and replace channel list*/
          final List<WorkspaceChannel> channelList = getChannelList()!;
          channelList[channelList.indexWhere(
              (element) => element.id == defaultChannel.id)] = defaultChannel;
          replaceChannelList(channelList);

          _replaceUpdatedChannelDnd(
              streamControllerChannelDnd,
              Resources(
                  Status.SUCCESS,
                  "",
                  Dnd(
                      dndEnabled:
                          resource.data!.channelDndResponse!.data!.dndEnabled,
                      dndEndtime:
                          resource.data!.channelDndResponse!.data!.dndEndtime ??
                              0,
                      dndRemainingTime: resource
                          .data!.channelDndResponse!.data!.dndRemainingTime)));

          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.channelDndResponse!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  void _replaceUpdatedChannelDnd(
      StreamController<Resources<Dnd>> streamControllerChannelDnd,
      Resources<Dnd> resources) {
    if (!streamControllerChannelDnd.isClosed) {
      streamControllerChannelDnd.sink.add(resources);
    }
  }

  Future<void> getDefaultChannelDetails(
      StreamController<Resources<Dnd>> streamControllerChannelDnd) async {
    final WorkspaceChannel workspaceChannel = getDefaultChannel();

    if (workspaceChannel.dndEnabled != null && workspaceChannel.dndEnabled!) {
      _replaceUpdatedChannelDnd(
          streamControllerChannelDnd,
          Resources(
              Status.SUCCESS,
              "",
              Dnd(
                  dndEndtime: workspaceChannel.dndEndTime ?? -1,
                  dndEnabled: workspaceChannel.dndEnabled,
                  dndRemainingTime: workspaceChannel.dndRemainingTime)));
    } else {
      _replaceUpdatedChannelDnd(
          streamControllerChannelDnd,
          Resources(
              Status.SUCCESS,
              "",
              Dnd(
                dndEndtime: -1,
                dndEnabled: false,
              )));
    }
  }

  Future<Resources<ChannelDndResponse>> doOnRemoveDndApiCall(
      bool isConnectedToInternet,
      StreamController<Resources<Dnd>> streamControllerChannelDnd,
      ChannelDndHolder holder) async {
    if (isConnectedToInternet) {
      final Resources<ChannelDndResponse> resource =
          await apiService!.onRemoveDnd(holder.toMap());
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.removeDndResponse!.error == null) {
          DashboardView.subscriptionConversationSeen.fire(
            SubscriptionConversationSeenEvent(
              isSeen: true,
            ),
          );
          final WorkspaceChannel defaultChannel = getDefaultChannel();
          /*replace default channel details*/
          defaultChannel.dndEnabled = false;
          defaultChannel.dndEndTime =
              resource.data!.removeDndResponse!.data!.dndEndtime;
          defaultChannel.dndRemainingTime =
              resource.data!.removeDndResponse!.data!.dndRemainingTime;
          replaceDefaultChannel(json.encode(defaultChannel));

          /*update and replace channel list*/
          final List<WorkspaceChannel> channelList = getChannelList()!;
          channelList[channelList.indexWhere(
              (element) => element.id == defaultChannel.id)] = defaultChannel;
          replaceChannelList(channelList);

          _replaceUpdatedChannelDnd(
              streamControllerChannelDnd,
              Resources(
                  Status.SUCCESS,
                  "",
                  Dnd(
                      dndEnabled: false,
                      dndEndtime:
                          resource.data!.removeDndResponse!.data!.dndEndtime,
                      dndRemainingTime: resource
                          .data!.removeDndResponse!.data!.dndRemainingTime)));
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.removeDndResponse!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<void> getChannelDndTimeList(
      StreamController<List<ChannelDnd>> streamControllerChannelDndTimeList,
      bool status) async {
    try {
      if (status) {
        streamControllerChannelDndTimeList.sink.add(
          ChannelDnd().fromMapList(
            jsonDecode(PsSharedPreferences.instance!.getChannelDndTimeList())
                as List<dynamic>,
          )!,
        );
      } else {
        final Map<int, ChannelDnd> dndMap = Config.channelDndTimeList;
        dndMap[-1]!.status = true;
        streamControllerChannelDndTimeList.sink.add(dndMap.values.toList());
      }
    } catch (e) {}
  }

  void setChannelDndList(int i, ChannelDnd data,
      StreamController<List<ChannelDnd>> streamControllerChannelDndTimeList) {
    final List<ChannelDnd> list = [];
    Config.channelDndTimeList.forEach((key, value) {
      if (i == key) {
        list.add(ChannelDnd(
            time: data.time, title: value.title, status: data.status));
      } else {
        list.add(
            ChannelDnd(time: value.time, title: value.title, status: false));
      }
    });

    PsSharedPreferences.instance!
        .setChannelDndTimeList(jsonEncode(ChannelDnd().toMapList(list)));
    if (!streamControllerChannelDndTimeList.isClosed) {
      streamControllerChannelDndTimeList.sink.add(ChannelDnd().fromMapList(
          jsonDecode(PsSharedPreferences.instance!.getChannelDndTimeList())
              as List<dynamic>)!);
    }
  }

  void resetChannelDndTimeList(int dndKey) {
    final Map<int, ChannelDnd> dndMap = Config.channelDndTimeList;
    dndMap[dndKey]!.status = true;
    PsSharedPreferences.instance!.setChannelDndTimeList(
        jsonEncode(ChannelDnd().toMapList(dndMap.values.toList())));
  }

  void _updateDefaultChannel(Dnd data) {
    final WorkspaceChannel workspaceChannel = getDefaultChannel();
    workspaceChannel.dndEnabled = data.dndEnabled;
    workspaceChannel.dndEndTime = data.dndEndtime;
    workspaceChannel.dndRemainingTime = data.dndRemainingTime;
    replaceDefaultChannel(json.encode(workspaceChannel));
  }

  Future<Resources<String>> doEditWorkspaceNameApiCall(
      String title, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<EditWorkspaceNameResponse> resource = await apiService!
        .doEditWorkspaceNameApiCall(
            EditWorkspaceRequestParamHolder(title: title));
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.editWorkspaceResponseData!.error == null) {
        final LoginWorkspace dump = getWorkspaceDetail()!;
        dump.title = resource.data!.editWorkspaceResponseData!.data!.title;
        replaceWorkspaceDetail(json.encode(dump));
        final List<LoginWorkspace> dump2 = getWorkspaceList()!;
        dump2[dump2.indexWhere((element) => element.id == dump.id)].title =
            resource.data!.editWorkspaceResponseData!.data!.title;
        replaceWorkspaceList(dump2);
        return Resources(Status.SUCCESS, "",
            resource.data!.editWorkspaceResponseData!.data!.title);
      } else {
        return Resources(Status.ERROR,
            resource.data!.editWorkspaceResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  void sinkOverViewStream(
      StreamController<Resources<OverViewData>> overviewDataStream,
      Resources<OverViewData> resources) {
    if (!overviewDataStream.isClosed) {
      overviewDataStream.sink.add(resources);
    }
  }

  Future<Resources<WorkspaceCreditResponse>> doWorkspaceCreditApiCall(
    bool isConnectedToInternet,
    Status isLoading,
  ) async {
    {
      final Resources<WorkspaceCreditResponse> resource =
          await apiService!.getWorkspaceCredit();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.getWorkspaceCredit!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(Status.ERROR,
              resource.data!.getWorkspaceCredit!.error!.message, null);
        }
      } else {
        return Resources(
            Status.ERROR, Utils.getString("serverError"), resource.data);
      }
    }
  }

  void updateChannelDnd(List<WorkspaceChannel> data) {}
}
