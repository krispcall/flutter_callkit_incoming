import "dart:async";
import "dart:convert";

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/config/Config.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/PlanRestrictionDao.dart";
import "package:mvp/db/UserDao.dart";
import "package:mvp/db/WorkspaceListDao.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/event/SubscriptionEvent.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/user/UserDetailProvider.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/user/dnd/UserDndView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/Language.dart";
import "package:mvp/viewObject/common/LanguageValueHolder.dart";
import "package:mvp/viewObject/model/cancelCall/CancelCallResponse.dart";
import "package:mvp/viewObject/model/checkDuplicateLogin/CheckDuplicateLogin.dart";
import "package:mvp/viewObject/model/dnd/UserDnd.dart";
import "package:mvp/viewObject/model/forgotPassword/ForgotPasswordResponse.dart";
import "package:mvp/viewObject/model/login/LoginDataDetails.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/login/User.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:mvp/viewObject/model/members/MemberStatus.dart";
import "package:mvp/viewObject/model/onlineStatus/onlineStatusResponse.dart";
import "package:mvp/viewObject/model/profile/EditProfile.dart";
import "package:mvp/viewObject/model/profile/Profile.dart";
import "package:mvp/viewObject/model/profile/changeProfilePicture.dart";
import "package:mvp/viewObject/model/userDnd/Dnd.dart";
import "package:mvp/viewObject/model/userDnd/UserDndResponse.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";
import "package:mvp/viewObject/model/userPlanRestriction/UserPlanRestrictionResponse.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListData.dart";
import "package:provider/provider.dart";
import "package:sembast/sembast.dart";

class UserRepository extends Repository {
  UserRepository({
    this.apiService,
    this.userDao,
    this.workSpaceDao,
    this.planRestrictionDao,
    this.psSharedPreferences,
  });

  ApiService? apiService;
  PsSharedPreferences? psSharedPreferences;
  UserDao? userDao;
  PlanRestrictionDao? planRestrictionDao;
  WorkspaceListDao? workSpaceDao;

  final String primaryKey = "id";

  final StreamController<LanguageValueHolder> _valueController =
      StreamController<LanguageValueHolder>();

  Stream<LanguageValueHolder>? get valueHolder => _valueController.stream;

  Future<dynamic> insert(UserProfileData user) async {
    return userDao!.insert(primaryKey, user);
  }

  Future<dynamic> update(UserProfileData user) async {
    return userDao!.update(user);
  }

  Future<dynamic> delete(UserProfileData user) async {
    return userDao!.delete(user);
  }

  Future<Resources<LoginDataDetails>> doUserLoginApiCall(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<User> resource =
        await apiService!.doUserLoginApiCall(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.login!.error == null) {
        replaceApiToken(resource.data!.login!.data!.token!);
        replaceSessionId(resource.data!.login!.data!.details!.id!);
        replaceSmsNotificationSetting(true);
        replaceMissedCallNotificationSetting(true);
        replaceVoiceMailNotificationSetting(true);
        replaceChatMessageNotificationSetting(true);
        replaceUserEmail(
            resource.data!.login!.data!.details!.userProfile!.email!);
        replaceUserPassword(jsonMap["details"]["password"] as String);
        replaceUserName(
            "${resource.data!.login!.data!.details!.userProfile!.firstName} ${resource.data!.login!.data!.details!.userProfile!.lastName}");
        replaceUserFirstName(
            resource.data!.login!.data!.details!.userProfile!.firstName!);
        replaceUserLastName(
            resource.data!.login!.data!.details!.userProfile!.lastName!);
        replaceUserOnlineStatus(
            resource.data!.login!.data!.details!.userProfile!.stayOnline);
        replaceUserProfilePicture(
            resource.data!.login!.data!.details!.userProfile!.profilePicture ??
                "");
        replaceIntercomId(resource.data!.login!.data!.intercomIdentity!);

        if (resource.data!.login!.data!.details!.workspaces!.isNotEmpty) {
          await workSpaceDao!.deleteAll();
          if (getLoginUserId() != null) {
            await workSpaceDao!.insert(
              getLoginUserId()!,
              WorkspaceListData(
                id: resource.data!.login!.data!.details!.id,
                status: 200,
                data: resource.data!.login!.data!.details!.workspaces,
              ),
            );
          }
          replaceWorkspaceList(resource.data!.login!.data!.details!.workspaces);
          if (resource.data!.login!.data!.details!.userProfile!
                      .defaultWorkspace !=
                  null &&
              resource.data!.login!.data!.details!.userProfile!
                  .defaultWorkspace!.isNotEmpty) {
            for (int i = 0;
                i < resource.data!.login!.data!.details!.workspaces!.length;
                i++) {
              if (resource.data!.login!.data!.details!.workspaces![i].id ==
                  resource.data!.login!.data!.details!.userProfile!
                      .defaultWorkspace) {
                if (resource.data!.login!.data!.details!.workspaces![i].status!
                        .toLowerCase() ==
                    "active") {
                  replaceDefaultWorkspace(
                      resource.data!.login!.data!.details!.workspaces![i].id!);
                  replaceMemberId(resource
                      .data!.login!.data!.details!.workspaces![i].memberId!);
                } else {
                  replaceDefaultWorkspace(
                      resource.data!.login!.data!.details!.workspaces![0].id!);
                  replaceMemberId(resource
                      .data!.login!.data!.details!.workspaces![0].memberId!);
                }
              }
            }
          } else {
            replaceDefaultWorkspace(
                resource.data!.login!.data!.details!.workspaces![0].id!);
            replaceMemberId(
                resource.data!.login!.data!.details!.workspaces![0].memberId!);
          }
        }

        // _resource.data!.login!.data!.details!.userProfile.defaultLanguage!=null?replaceDefaultLanguage(_resource.data!.login!.data!.details.userProfile.defaultLanguage):replaceDefaultLanguage("en");
        userDao!.deleteAll().then((value) {
          userDao!.insert(
              primaryKey, resource.data!.login!.data!.details!.userProfile!);
        });
        return Resources(
            Status.SUCCESS, "", resource.data!.login!.data!.details);
      } else {
        return Resources(
            Status.ERROR, resource.data!.login!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<CheckDuplicateLogin>> doCheckDuplicateLogin(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<CheckDuplicateLogin> resource =
        await apiService!.doCheckDuplicateLogin(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.clientDndResponseData!.error == null) {
        return Resources(Status.SUCCESS, "", resource.data);
      } else {
        return Resources(Status.ERROR,
            resource.data!.clientDndResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  Future<Resources<UserProfileData>> getUserProfileDetails(
      bool isConnectedToInternet,
      Status status,
      StreamController<Resources<Dnd>> streamControllerUpdatedUserDnd,
      StreamController<bool> streamOnlineStatus,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<Profile> resource =
          await apiService!.getUserProfileDetails();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.profile!.error == null &&
            resource.data!.profile!.data != null) {
          replaceUserEmail(resource.data!.profile!.data!.email!);
          replaceUserName(
              "${resource.data!.profile!.data!.firstName} ${resource.data!.profile!.data!.lastName}");
          replaceDefaultWorkspace(
              resource.data!.profile!.data!.defaultWorkspace!);

          replaceUserProfilePicture(
              resource.data!.profile!.data!.profilePicture ?? "");

          /*replace the details ot the user dnd
          * details if the user logged in from another device
          * or clear cache or data*/

          replaceUserOnlineStatus(resource.data!.profile!.data!.stayOnline);

          sinkUserOnlineStatus(
              streamOnlineStatus, resource.data!.profile!.data!.stayOnline!);

          _replaceUpatedUserDnd(
              streamControllerUpdatedUserDnd,
              Resources(
                  Status.SUCCESS,
                  "",
                  Dnd(
                      dndEnabled: resource.data!.profile!.data!.dndEnabled,
                      dndEndtime: resource.data!.profile!.data!.dndEndtime)));

          setUserDndTimeList(
            resource.data!.profile!.data!.dndDuration ?? 0,
            UserDnd(
              time: resource.data!.profile!.data!.dndDuration ?? 0,
              title: Config
                  .timeList[resource.data!.profile!.data!.dndDuration ?? 0]!
                  .title,
              status: !resource.data!.profile!.data!.stayOnline!,
              endTime: resource.data!.profile!.data!.dndEndtime,
            ),
          );

          await userDao!.deleteWithFinder(
            Finder(
              filter: Filter.matches("email", getUserEmail()),
            ),
          );
          userDao!.insert("email", resource.data!.profile!.data!);
          return Resources(Status.SUCCESS, "", resource.data!.profile!.data);
        } else {
          final Resources<UserProfileData>? dump = await userDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "email",
                RegExp(getUserEmail(), caseSensitive: false),
              ),
            ),
          );
          replaceUserEmail(dump!.data!.email!);
          replaceUserName("${dump.data!.firstName} ${dump.data!.lastName}");
          replaceDefaultWorkspace(dump.data!.defaultWorkspace!);

          replaceUserProfilePicture(dump.data!.profilePicture ?? "");

          /*replace the details ot the user dnd
          * details if the user logged in from another device
          * or clear cache or data*/

          replaceUserOnlineStatus(dump.data!.stayOnline);

          sinkUserOnlineStatus(streamOnlineStatus, dump.data!.stayOnline!);

          _replaceUpatedUserDnd(
            streamControllerUpdatedUserDnd,
            Resources(
              Status.SUCCESS,
              "",
              Dnd(
                dndEnabled: dump.data!.dndEnabled,
                dndEndtime: dump.data!.dndEndtime,
              ),
            ),
          );

          setUserDndTimeList(
            dump.data!.dndDuration ?? 0,
            UserDnd(
              time: dump.data!.dndDuration ?? 0,
              title: Config.timeList[dump.data!.dndDuration ?? 0]!.title,
              status: !dump.data!.stayOnline!,
              endTime: dump.data!.dndEndtime,
            ),
          );

          return Resources(Status.SUCCESS, "", dump.data);
        }
      } else {
        final Resources<UserProfileData>? dump = await userDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "email",
              RegExp(getUserEmail(), caseSensitive: false),
            ),
          ),
        );
        replaceUserEmail(dump!.data!.email!);
        replaceUserName("${dump.data!.firstName} ${dump.data!.lastName}");
        replaceDefaultWorkspace(dump.data!.defaultWorkspace!);

        replaceUserProfilePicture(dump.data!.profilePicture ?? "");

        /*replace the details ot the user dnd
          * details if the user logged in from another device
          * or clear cache or data*/

        replaceUserOnlineStatus(dump.data!.stayOnline);

        sinkUserOnlineStatus(streamOnlineStatus, dump.data!.stayOnline!);

        _replaceUpatedUserDnd(
          streamControllerUpdatedUserDnd,
          Resources(
            Status.SUCCESS,
            "",
            Dnd(
              dndEnabled: dump.data!.dndEnabled,
              dndEndtime: dump.data!.dndEndtime,
            ),
          ),
        );

        setUserDndTimeList(
          dump.data!.dndDuration ?? 0,
          UserDnd(
            time: dump.data!.dndDuration ?? 0,
            title: Config.timeList[dump.data!.dndDuration ?? 0]!.title,
            status: !dump.data!.stayOnline!,
            endTime: dump.data!.dndEndtime,
          ),
        );

        return Resources(Status.SUCCESS, "", dump.data);
      }
    } else {
      final Resources<UserProfileData>? dump = await userDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "email",
            RegExp(getUserEmail(), caseSensitive: false),
          ),
        ),
      );
      replaceUserEmail(dump!.data!.email!);
      replaceUserName("${dump.data!.firstName} ${dump.data!.lastName}");
      replaceDefaultWorkspace(dump.data!.defaultWorkspace!);

      replaceUserProfilePicture(dump.data!.profilePicture ?? "");

      /*replace the details ot the user dnd
          * details if the user logged in from another device
          * or clear cache or data*/

      replaceUserOnlineStatus(dump.data!.stayOnline);

      sinkUserOnlineStatus(streamOnlineStatus, dump.data!.stayOnline!);

      _replaceUpatedUserDnd(
        streamControllerUpdatedUserDnd,
        Resources(
          Status.SUCCESS,
          "",
          Dnd(
            dndEnabled: dump.data!.dndEnabled,
            dndEndtime: dump.data!.dndEndtime,
          ),
        ),
      );

      setUserDndTimeList(
        dump.data!.dndDuration ?? 0,
        UserDnd(
          time: dump.data!.dndDuration ?? 0,
          title: Config.timeList[dump.data!.dndDuration ?? 0]!.title,
          status: !dump.data!.stayOnline!,
          endTime: dump.data!.dndEndtime,
        ),
      );

      return Resources(Status.SUCCESS, "", dump.data);
    }
  }

  Future<dynamic> changeProfilePicture(
      Map<String, String> param,
      StreamController<Resources<Dnd>> streamControllerUpdatedUserDnd,
      StreamController<bool> streamOnlineStatus,
      bool isConnectedToInternet) async {
    if (isConnectedToInternet) {
      final Resources<ChangeProfilePicture> resource =
          await apiService!.changeProfilePicture(param);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null &&
            resource.data!.data!.data != null) {
          replaceUserEmail(resource.data!.data!.data!.email!);
          replaceUserName(
              "${resource.data!.data!.data!.firstName} ${resource.data!.data!.data!.lastName}");
          replaceDefaultWorkspace(resource.data!.data!.data!.defaultWorkspace!);

          replaceUserProfilePicture(
              resource.data!.data!.data!.profilePicture ?? "");

          /*replace the details ot the user dnd
          * details if the user logged in from another device
          * or clear cache or data*/

          replaceUserOnlineStatus(resource.data!.data!.data!.stayOnline);

          sinkUserOnlineStatus(
              streamOnlineStatus, resource.data!.data!.data!.stayOnline!);

          _replaceUpatedUserDnd(
              streamControllerUpdatedUserDnd,
              Resources(
                  Status.SUCCESS,
                  "",
                  Dnd(
                      dndEnabled: resource.data!.data!.data!.dndEnabled,
                      dndEndtime: resource.data!.data!.data!.dndEndtime)));

          setUserDndTimeList(
              resource.data!.data!.data!.dndDuration ?? 0,
              UserDnd(
                  time: resource.data!.data!.data!.dndDuration ?? 0,
                  title: Config
                      .timeList[resource.data!.data!.data!.dndDuration ?? 0]!
                      .title,
                  status: !resource.data!.data!.data!.stayOnline!,
                  endTime: resource.data!.data!.data!.dndEndtime));

          userDao!.update(resource.data!.data!.data!);
          return Resources(Status.SUCCESS, "", resource.data!.data!.data);
        } else {
          return Resources(
              Status.ERROR, resource.data!.data!.error!.message, null);
        }
      }
    }
  }

  Future<dynamic> onlineStatus(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<OnlineStatusResponse> resource =
          await apiService!.onlineStatus(jsonMap);

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null &&
            resource.data!.data!.data != null) {
          replaceUserOnlineStatus(resource.data!.data!.data!.onlineStatus);
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(
              Status.ERROR, resource.data!.data!.error!.message, null);
        }
      } else {
        return Resources(
            Status.ERROR, resource.data!.data!.error!.message, null);
      }
    }
  }

  Future<Resources<EditProfile>> editUsernameApiCall(bool isConnectedToInternet,
      Status status, Map<String, dynamic> json) async {
    if (isConnectedToInternet) {
      final Resources<EditProfile> resource =
          await apiService!.editUsernameApiCall(json);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.profile!.error == null &&
            resource.data!.profile!.data != null) {
          replaceUserName(
              "${resource.data!.profile!.data!.firstName} ${resource.data!.profile!.data!.lastName}");
          replaceUserFirstName(resource.data!.profile!.data!.firstName!);
          replaceUserLastName(resource.data!.profile!.data!.lastName!);
          userDao!.update(resource.data!.profile!.data!);
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(
              Status.ERROR, resource.data!.profile!.error!.message, null);
        }
      } else {
        return Resources(
          Status.ERROR,
          resource.data!.profile!.error!.message ??
              Utils.getString("serverError"),
          null,
        );
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<dynamic> changeEmail(
      Map<String, dynamic> jsonMap, bool isConnectedToInternet) async {
    if (isConnectedToInternet) {
      final Resources<UpdateUserEmail> resource =
          await apiService!.postUserEmailUpdate(jsonMap);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null &&
            resource.data!.data!.data != null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(
              Status.ERROR, resource.data!.data!.error!.message, null);
        }
      } else {
        return Resources(
            Status.ERROR, resource.data!.data!.error!.message, null);
      }
    }
  }

  Future<dynamic> callCancelApi(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet) async {
    if (isConnectedToInternet) {
      final Resources<CancelCallResponse> resources =
          await apiService!.cancelOutgoingCall(jsonMap);
      if (resources.status == Status.SUCCESS) {
        if (resources.data!.callResponse!.error == null) {
          return Resources(
              Status.SUCCESS, "", resources.data!.callResponse!.key);
        } else {
          return Resources(Status.ERROR, "", null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> rejectCall(String id, bool isConnectedToInternet) async {
    if (isConnectedToInternet) {
      final Resources<CancelCallResponse> resources =
          await apiService!.rejectCall(id);
      if (resources.status == Status.SUCCESS) {
        // print("this is rejected ${_resources.toString()}");
        if (resources.data!.callResponse!.error == null) {
          return Resources(Status.SUCCESS, "", resources.data!.callResponse);
        } else {
          return Resources(
              Status.ERROR, resources.data!.callResponse!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  Future<dynamic> doUserForgotPasswordApiCall(
      Map<dynamic, dynamic> jsonMap, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    final Resources<ForgotPasswordResponse> resource =
        await apiService!.doUserForgotPasswordApiCall(jsonMap);
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.forgotPasswordResponseData!.error == null &&
          resource.data!.forgotPasswordResponseData!.forgotPassword != null) {
        return Resources(Status.SUCCESS, "",
            resource.data!.forgotPasswordResponseData!.forgotPassword!.message);
      } else {
        return Resources(Status.ERROR,
            resource.data!.forgotPasswordResponseData!.error!.message, null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("serverError"), null);
    }
  }

  void loadLanguageValueHolder() {
    final String languageCodeKey = psSharedPreferences!.shared!
        .getString(Const.LANGUAGE_LANGUAGE_CODE_KEY)!;
    final String countryCodeKey = psSharedPreferences!.shared!
        .getString(Const.LANGUAGE_COUNTRY_CODE_KEY)!;

    ///TODO Sushan change usage
    const String languageNameKey = "English US";

    _valueController.add(
      LanguageValueHolder(
        languageCode: languageCodeKey,
        countryCode: countryCodeKey,
        name: languageNameKey,
      ),
    );
  }

  Future<void> addLanguage(Language language) async {
    await psSharedPreferences!.shared!.setString(
        Const.LANGUAGE_LANGUAGE_CODE_KEY, language.languageCode ?? "en");
    await psSharedPreferences!.shared!.setString(
        Const.LANGUAGE_COUNTRY_CODE_KEY, language.countryCode ?? "US");
    await psSharedPreferences!.shared!.setString(
        Const.LANGUAGE_LANGUAGE_NAME_KEY, language.name ?? "English US");
    await psSharedPreferences!.shared!.setString("locale",
        Locale(language.languageCode!, language.countryCode).toString());
    loadLanguageValueHolder();
  }

  Language getLanguage() {
    final String? languageCode = psSharedPreferences!.shared!
            .getString(Const.LANGUAGE_LANGUAGE_CODE_KEY) ??
        Config.defaultLanguage.languageCode;
    final String? countryCode = psSharedPreferences!.shared!
            .getString(Const.LANGUAGE_COUNTRY_CODE_KEY) ??
        Config.defaultLanguage.countryCode;
    final String? languageName = psSharedPreferences!.shared!
            .getString(Const.LANGUAGE_LANGUAGE_NAME_KEY) ??
        Config.defaultLanguage.name;

    return Language(
      languageCode: languageCode,
      countryCode: countryCode,
      name: languageName,
    );
  }

  Future<dynamic> doSubscriptionUserProfile(
      StreamController<Resources<UserProfileData>>? streamControllerUserProfile,
      StreamController<List<UserDnd>>? streamControllerUserDndList,
      StreamController<bool>? streamOnlineStatus,
      bool? isConnectedToInternet,
      Status? status,
      BuildContext? context,
      {Function(LoginWorkspace)? switchWorkspace}) async {
    final userDetailProvider =
        Provider.of<UserDetailProvider>(context!, listen: false);
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    final Stream<QueryResult> result = await apiService!
        .doSubscriptionUserProfile(Map.from({"user": getLoginUserId()}));
    result.listen((event) async {
      if (event.data != null) {
        if (event.data!["userProfile"]["event"] == "update_user_profile") {
          final UserProfileData userProfile =
              UserProfileData().fromMap(event.data!["userProfile"]["message"])!;

          final String? defaultLanguage = psSharedPreferences!.shared!
              .getString(Const.LANGUAGE_LANGUAGE_CODE_KEY);
          final String defaultWorkspaceId = getDefaultWorkspace();
          if (defaultLanguage != null &&
              userProfile.defaultLanguage != null &&
              defaultLanguage != userProfile.defaultLanguage) {
            await addLanguage(Config
                .psSupportedLanguageMap[userProfile.defaultLanguage ?? "en"]!);

            EasyLocalization.of(context)!.setLocale(
              Locale(
                Config
                    .psSupportedLanguageMap[
                        userProfile.defaultLanguage ?? "en"]!
                    .languageCode!,
                Config
                    .psSupportedLanguageMap[
                        userProfile.defaultLanguage ?? "en"]!
                    .countryCode,
              ),
            );
            AppBuilder.of(context)!.rebuild();
          } else if (userProfile.defaultWorkspace != null &&
              defaultWorkspaceId != userProfile.defaultWorkspace) {
            userDetailProvider.changeWorkspace = true;
            userDetailProvider.defaultWorkspaceId =
                userProfile.defaultWorkspace!;
            replaceUserEmail(userProfile.email!);
            replaceUserName("${userProfile.firstName} ${userProfile.lastName}");
            if (!dashboardProvider.outgoingIsCallConnected &&
                !dashboardProvider.incomingIsCallConnected) {
              replaceDefaultWorkspace(userProfile.defaultWorkspace!);
              userDetailProvider.changeWorkspace = false;
              switchWorkspace!(getWorkspaceList()!
                  .where(
                      (element) => element.id == userProfile.defaultWorkspace)
                  .first);
            }
          } else {
            replaceUserEmail(userProfile.email!);
            replaceUserName("${userProfile.firstName} ${userProfile.lastName}");
            replaceDefaultWorkspace(userProfile.defaultWorkspace!);

            await addLanguage(Config
                .psSupportedLanguageMap[userProfile.defaultLanguage ?? "en"]!);

            try {
              EasyLocalization.of(context)!.setLocale(
                Locale(
                  Config
                      .psSupportedLanguageMap[
                          userProfile.defaultLanguage ?? "en"]!
                      .languageCode!,
                  Config
                      .psSupportedLanguageMap[
                          userProfile.defaultLanguage ?? "en"]!
                      .countryCode,
                ),
              );
              AppBuilder.of(context)!.rebuild();
            } catch (_) {}
            userDao!.update(userProfile);
            if (!streamControllerUserProfile!.isClosed) {
              streamControllerUserProfile.sink
                  .add(Resources(Status.SUCCESS, "", userProfile));
            }

            // showUserOfflineDialog(context, userProfile.stayOnline);

            /*
            Replace user dnd list
            * user online status
            * and update the streams
            * */

            replaceUserOnlineStatus(userProfile.stayOnline);
            sinkUserOnlineStatus(streamOnlineStatus!, userProfile.stayOnline!);

            setUserDndTimeList(
                userProfile.dndDuration ?? 0,
                UserDnd(
                    time: userProfile.dndDuration ?? 0,
                    title: Config.timeList[userProfile.dndDuration ?? 0]!.title,
                    status: !userProfile.stayOnline!,
                    endTime: userProfile.dndEndtime));
            /*reset time list
            * and update time list*/
            UserDndViewWidget.onOfflineEvent
                .fire(UserOnlineOfflineEvent(online: userProfile.stayOnline));

            /*send event stream to dashboard*/
            DashboardView.subscriptionMemberOnline.fire(
              SubscriptionMemberOnlineEvent(
                event: "updateMemberOnline",
                memberStatus: MemberStatus(
                  id: getMemberId(),
                  online: userProfile.stayOnline,
                ),
              ),
            );
            // Future<Resources> abc = Resources(Status.SUCCESS, "", userProfile) as Future<Resources>;
            return Future.value(Resources(Status.SUCCESS, "", userProfile));
          }
        }
      }
    });
  }

  Future<Resources<PlanRestriction>> doGetPlanRestriction(
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<UserPlanRestrictionResponse> resource =
          await apiService!.doGetPlanRestrictionApiCall();

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.userPlanRestrictionResponseData!.error == null) {
          resource.data!.userPlanRestrictionResponseData!.planRestriction!.id =
              getDefaultWorkspace();
          await planRestrictionDao!.deleteWithFinder(
            Finder(
              filter: Filter.matches("id", getDefaultWorkspace()),
            ),
          );
          await planRestrictionDao!.insert(
            getDefaultWorkspace(),
            resource.data!.userPlanRestrictionResponseData!.planRestriction!,
          );
          return Resources(Status.SUCCESS, "",
              resource.data!.userPlanRestrictionResponseData!.planRestriction);
        } else {
          final Resources<PlanRestriction>? dump =
              await planRestrictionDao!.getOne(
            finder: Finder(
              filter: Filter.matchesRegExp(
                "id",
                RegExp(getDefaultWorkspace(), caseSensitive: false),
              ),
            ),
          );
          return Resources(Status.SUCCESS, "", dump!.data);
        }
      } else {
        final Resources<PlanRestriction>? dump =
            await planRestrictionDao!.getOne(
          finder: Finder(
            filter: Filter.matchesRegExp(
              "id",
              RegExp(getDefaultWorkspace(), caseSensitive: false),
            ),
          ),
        );
        return Resources(Status.SUCCESS, "", dump!.data);
      }
    } else {
      final Resources<PlanRestriction>? dump = await planRestrictionDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(getDefaultWorkspace(), caseSensitive: false),
          ),
        ),
      );
      return Resources(Status.SUCCESS, "", dump!.data);
    }
  }

  Future<void> getUserDndTimeList(
      StreamController<List<UserDnd>> streamControllerUserDndTimeList,
      bool userStatus) async {
    try {
      if (userStatus) {
        streamControllerUserDndTimeList.sink.add(UserDnd().fromMapList(
            jsonDecode(PsSharedPreferences.instance!.getUserDndTimeList())
                as List<dynamic>)!);
      } else {
        streamControllerUserDndTimeList.sink
            .add(Config.timeList.values.toList());
      }
    } catch (e) {
      Utils.cPrint(e.toString());
      streamControllerUserDndTimeList.sink.add(Config.timeList.values.toList());
    }
  }

  void setUserDndTimeList(int i, UserDnd data) {
    final List<UserDnd> list = [];
    Config.timeList.forEach((key, value) {
      if (i == key) {
        list.add(data);
      } else {
        list.add(UserDnd(time: value.time, title: value.title, status: false));
      }
    });

    psSharedPreferences!
        .setUserDndEnabledTimeValue(jsonEncode(UserDnd().toMap(data)));
    psSharedPreferences!
        .setUserDndTimeList(jsonEncode(UserDnd().toMapList(list)));
  }

  void resetUserDndTimeList() {
    psSharedPreferences!.setUserDndTimeList(
        jsonEncode(UserDnd().toMapList(Config.timeList.values.toList())));
  }

  UserDnd? getUserDndTimeValue() {
    if (psSharedPreferences!.getUserDndEnabledTimeValue().isNotEmpty) {
      return UserDnd().fromMap(
          jsonDecode(psSharedPreferences!.getUserDndEnabledTimeValue()));
    } else {
      return null;
    }
  }

  Future<Resources<UserDndResponse>> onSetUserDnd(
      int time,
      bool value,
      bool isConnectedToInternet,
      StreamController<Resources<Dnd>> streamControllerUpdatedUserDnd) async {
    if (isConnectedToInternet) {
      final Resources<UserDndResponse> resource =
          await apiService!.onSetUserDnd(Map.from({
        "data": {"minutes": time, "removeFromDND": !value}
      }));

      if (resource.status == Status.SUCCESS) {
        if (resource.data!.data!.error == null) {
          /*replace user online status
          * and user dnd details
          * and update the stream*/

          replaceUserOnlineStatus(!resource.data!.data!.data!.dndEnabled!);

          setUserDndTimeList(
              time,
              UserDnd(
                  title: Config.timeList[time]!.title,
                  time: time,
                  endTime: resource.data!.data!.data!.dndEndtime,
                  status: resource.data!.data!.data!.dndEnabled));
          _replaceUpatedUserDnd(streamControllerUpdatedUserDnd,
              Resources(Status.SUCCESS, "", resource.data!.data!.data));
          UserDndViewWidget.onOfflineEvent.fire(UserOnlineOfflineEvent(
              online: !resource.data!.data!.data!.dndEnabled!));
          return Resources(Status.SUCCESS, "", resource.data);
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

  void _replaceUpatedUserDnd(
      StreamController<Resources<Dnd>> streamControllerUpdatedUserDnd,
      Resources<Dnd> resources) {
    streamControllerUpdatedUserDnd.sink.add(resources);
  }

  Future<void> getUserDndEnabledValue(
      StreamController<Resources<Dnd>> streamControllerUpdatedUserDnd) async {
    final UserDnd? dnd = UserDnd().fromMap(jsonDecode(
        psSharedPreferences!.getUserDndEnabledTimeValue().isNotEmpty
            ? psSharedPreferences!.getUserDndEnabledTimeValue()
            : "{}"));
    if (dnd != null) {
      _replaceUpatedUserDnd(
          streamControllerUpdatedUserDnd,
          Resources(
              Status.SUCCESS,
              "",
              Dnd(
                dndEndtime: dnd.endTime,
                dndEnabled: dnd.status,
                dndRemainingTime: dnd.time,
              )));
    } else {
      _replaceUpatedUserDnd(
          streamControllerUpdatedUserDnd, Resources(Status.SUCCESS, "", null));
    }

    return Future.value();
  }

  Future<dynamic> doGetPlanRestrictionFromDB(
      int limit, bool isConnectedToInternet, Status status,
      {bool isLoadFromServer = true}) async {
    if (isConnectedToInternet) {
      final Resources<PlanRestriction>? resource =
          await planRestrictionDao!.getOne(
        finder: Finder(
          filter: Filter.matchesRegExp(
            "id",
            RegExp(getDefaultWorkspace(), caseSensitive: false),
          ),
        ),
      );

      if (resource?.status == Status.SUCCESS) {
        if (resource?.data != null) {
          return Resources(Status.SUCCESS, "", resource?.data);
        } else {
          return Resources(Status.ERROR, resource?.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    }
  }

  void sinkUserOnlineStatus(
      StreamController<bool> streamOnlineStatus, bool stayOnline) {
    if (!streamOnlineStatus.isClosed) {
      streamOnlineStatus.sink.add(stayOnline);
    }
  }
}
