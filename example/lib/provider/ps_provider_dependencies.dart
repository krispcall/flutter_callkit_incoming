import "package:flutter/material.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/db/BlockListDao.dart";
import "package:mvp/db/CallLogDao.dart";
import "package:mvp/db/ChannelListDao.dart";
import "package:mvp/db/ContactDao.dart";
import "package:mvp/db/ContactDetailDao.dart";
import "package:mvp/db/CountryDao.dart";
import "package:mvp/db/MemberDao.dart";
import "package:mvp/db/MemberMessageDetailsDao.dart";
import "package:mvp/db/MessageDetailsDao.dart";
import "package:mvp/db/NotesDao.dart";
import "package:mvp/db/NumberDao.dart";
import "package:mvp/db/NumberSettingsDao.dart";
import "package:mvp/db/PlanRestrictionDao.dart";
import "package:mvp/db/StateCodeDao.dart";
import "package:mvp/db/TeamDao.dart";
import "package:mvp/db/TeamsMemberDao.dart";
import "package:mvp/db/UserDao.dart";
import "package:mvp/db/WorkSpaceDetailDao.dart";
import "package:mvp/db/WorkspaceListDao.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/provider/dashboard/DashboardProvider.dart";
import "package:mvp/provider/user/UserDetailProvider.dart";
import "package:mvp/repository/AppInfoRepository.dart";
import "package:mvp/repository/AreaCodeRepository.dart";
import "package:mvp/repository/CallHoldRepository.dart";
import "package:mvp/repository/CallLogRepository.dart";
import "package:mvp/repository/CallRecordRepository.dart";
import "package:mvp/repository/CallTransferRepository.dart";
import "package:mvp/repository/Common/CallRatingRepository.dart";
import "package:mvp/repository/Common/NotificationRepository.dart";
import "package:mvp/repository/ContactRepository.dart";
import "package:mvp/repository/CountryListRepository.dart";
import "package:mvp/repository/LoginWorkspaceRepository.dart";
import "package:mvp/repository/MacrosRepository.dart";
import "package:mvp/repository/MemberMessageDetailsRepository.dart";
import "package:mvp/repository/MemberRepository.dart";
import "package:mvp/repository/MessageDetailsRepository.dart";
import "package:mvp/repository/MyNumberRepository.dart";
import "package:mvp/repository/TeamsRepository.dart";
import "package:mvp/repository/ThemeRepository.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";

List<SingleChildWidget> providers = <SingleChildWidget>[
  ...independentProviders,
  ..._dependentProviders,
  ..._valueProviders,
];

List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
  ChangeNotifierProvider<UserDetailProvider>(
      create: (_) => UserDetailProvider()),
  Provider<PsSharedPreferences>.value(value: PsSharedPreferences.instance!),
  Provider<ApiService>.value(value: ApiService()),
  Provider<UserDao>.value(value: UserDao.instance),
  Provider<ContactDao>.value(value: ContactDao.instance),
  Provider<MemberDao>.value(value: MemberDao.instance),
  Provider<MessageDetailsDao>.value(value: MessageDetailsDao.instance),
  Provider<MemberMessageDetailsDao>.value(
      value: MemberMessageDetailsDao.instance),
  Provider<CallLogDao>.value(value: CallLogDao.instance),
  Provider<WorkspaceListDao>.value(value: WorkspaceListDao.instance),
  Provider<WorkspaceDetailDao>.value(value: WorkspaceDetailDao.instance),
  Provider<CountryDao>.value(value: CountryDao.instance),
  Provider<NotesDao>.value(value: NotesDao.instance),
  Provider<ContactDetailDao>.value(value: ContactDetailDao.instance),
  Provider<TeamDao>.value(value: TeamDao.instance),
  Provider<NumberDao>.value(value: NumberDao.instance),
  Provider<NumberSettingsDao>.value(value: NumberSettingsDao.instance),
  Provider<PlanRestrictionDao>.value(value: PlanRestrictionDao.instance),
  Provider<TeamsMemberDao>.value(value: TeamsMemberDao.instance),
  Provider<ChannelListDao>.value(value: ChannelListDao.instance),
  Provider<BlockListDao>.value(value: BlockListDao.instance),
  Provider<StateCodeDao>.value(value: StateCodeDao.instance),
];

List<SingleChildWidget> _dependentProviders = <SingleChildWidget>[
  ProxyProvider<PsSharedPreferences, PsThemeRepository>(
    update: (_, PsSharedPreferences? ssSharedPreferences,
            PsThemeRepository? psThemeRepository) =>
        PsThemeRepository(psSharedPreferences: ssSharedPreferences!),
  ),
  ProxyProvider<ApiService, AppInfoRepository>(
    update: (_, ApiService? apiService, AppInfoRepository? appInfoRepository) =>
        AppInfoRepository(apiService: apiService!),
  ),
  ProxyProvider<ApiService, NotificationRepository>(
    update:
        (_, ApiService? apiService, NotificationRepository? userRepository) =>
            NotificationRepository(
      service: apiService!,
    ),
  ),
  ProxyProvider3<ApiService, MemberDao, MemberMessageDetailsDao,
      MemberRepository>(
    update: (
      _,
      ApiService? apiService,
      MemberDao? memberDao,
      MemberMessageDetailsDao? memberMessageDetailsDao,
      MemberRepository? memberRepository,
    ) =>
        // MemberRepository(apiService: apiService, memberDao: messagesDao,),
        MemberRepository(
      apiService: apiService,
      memberDao: memberDao,
      memberMessageDetailsDao: memberMessageDetailsDao,
    ),
  ),
  ProxyProvider3<ApiService, MemberDao, MemberMessageDetailsDao,
      MemberMessageDetailsRepository>(
    update: (
      _,
      ApiService? apiService,
      MemberDao? memberDao,
      MemberMessageDetailsDao? memberMessageDetailsDao,
      MemberMessageDetailsRepository? memberMessageDetailsRepository,
    ) =>
        MemberMessageDetailsRepository(
      apiService: apiService,
      memberDao: memberDao,
      memberMessageDetailsDao: memberMessageDetailsDao,
    ),
  ),
  ProxyProvider2<ApiService, MessageDetailsDao, MessageDetailsRepository>(
    update: (_, ApiService? apiService, MessageDetailsDao messagesDetailsDao,
            MessageDetailsRepository? messagesRepository) =>
        MessageDetailsRepository(
            apiService: apiService, messageDetailsDao: messagesDetailsDao),
  ),
  ProxyProvider2<ApiService, CountryDao, CountryRepository>(
    update: (_, ApiService? apiService, CountryDao? countryDao,
            CountryRepository? countryRepository) =>
        CountryRepository(apiService: apiService, countryDao: countryDao),
  ),
  ProxyProvider2<ApiService, CallLogDao, CallLogRepository>(
    update: (_, ApiService? apiService, CallLogDao? callLogsDao,
            CallLogRepository? messagesRepository) =>
        CallLogRepository(apiService: apiService!, callLogDao: callLogsDao!),
  ),
  ProxyProvider3<ApiService, TeamDao, TeamsMemberDao, TeamRepository>(
    update: (_, ApiService? apiService, TeamDao? teamDao,
            TeamsMemberDao? teamsMemberDao, TeamRepository? repository) =>
        TeamRepository(
      apiService: apiService!,
      teamDao: teamDao!,
      teamsMemberDao: teamsMemberDao!,
    ),
  ),
  ProxyProvider2<ApiService, NumberDao, MyNumberRepository>(
    update: (_, ApiService? apiService, NumberDao? numberDao,
            MyNumberRepository? repository) =>
        MyNumberRepository(apiService: apiService!, numbersDao: numberDao!),
  ),
  ProxyProvider6<ApiService, WorkspaceListDao, WorkspaceDetailDao, CountryDao,
      NumberSettingsDao, ChannelListDao, LoginWorkspaceRepository>(
    update: (
      _,
      ApiService? apiService,
      WorkspaceListDao? workspaceListDao,
      WorkspaceDetailDao? workspaceDetailDao,
      CountryDao? countryDao,
      NumberSettingsDao? numberSettingsDao,
      ChannelListDao? channelListDao,
      LoginWorkspaceRepository? loginWorkspaceRepository,
    ) =>
        LoginWorkspaceRepository(
      apiService: apiService,
      workSpaceDao: workspaceListDao,
      countryDao: countryDao,
      workspaceDetailDao: workspaceDetailDao,
      numberSettingsDao: numberSettingsDao,
      channelListDao: channelListDao,
    ),
  ),
  ProxyProvider5<ApiService, UserDao, WorkspaceListDao, PlanRestrictionDao,
      PsSharedPreferences, UserRepository>(
    update: (_,
            ApiService? apiService,
            UserDao? userDao,
            WorkspaceListDao? workSpaceDao,
            PlanRestrictionDao? planRestrictionDao,
            PsSharedPreferences? psSharedPreferences,
            UserRepository? userRepository) =>
        UserRepository(
      apiService: apiService,
      workSpaceDao: workSpaceDao,
      userDao: userDao,
      planRestrictionDao: planRestrictionDao,
      psSharedPreferences: psSharedPreferences,
    ),
  ),
  ProxyProvider6<ApiService, ContactDao, ContactDetailDao, NotesDao, CountryDao,
      BlockListDao, ContactRepository>(
    update: (
      _,
      ApiService? apiService,
      ContactDao? contactDao,
      ContactDetailDao? contactDetailDao,
      NotesDao? notesDao,
      CountryDao? countryDao,
      BlockListDao? blockListDao,
      ContactRepository? contactRepository,
    ) =>
        ContactRepository(
      apiService: apiService,
      contactDao: contactDao,
      contactDetailDao: contactDetailDao,
      notesDao: notesDao,
      countryDao: countryDao,
      blockListDao: blockListDao,
    ),
  ),
  ProxyProvider<ApiService, CallRecordRepository>(
    update: (_, ApiService? apiService,
            CallRecordRepository? callRecordRepository) =>
        CallRecordRepository(service: apiService!),
  ),
  ProxyProvider<ApiService, MacrosRepository>(
    update: (_, ApiService? apiService, MacrosRepository? macroRepository) =>
        MacrosRepository(service: apiService!),
  ),
  ProxyProvider<ApiService, CallTransferRepository>(
    update: (_, ApiService? apiService,
            CallTransferRepository? callRecordRepository) =>
        CallTransferRepository(service: apiService!),
  ),
  ProxyProvider<ApiService, CallHoldRepository>(
    update:
        (_, ApiService? apiService, CallHoldRepository? callHoldRepository) =>
            CallHoldRepository(service: apiService!),
  ),
  ProxyProvider<ApiService, CallRatingRepository>(
    update: (_, ApiService? apiService,
            CallRatingRepository? callRatingRepository) =>
        CallRatingRepository(service: apiService!),
  ),
  ProxyProvider2<ApiService, StateCodeDao, AreaCodeRepository>(
    update: (_, ApiService? apiService, StateCodeDao stateCodeDao,
            AreaCodeRepository? areaCodeRepository) =>
        AreaCodeRepository(service: apiService!, codeDao: stateCodeDao),
  ),
];

List<SingleChildWidget> _valueProviders = <SingleChildWidget>[
  StreamProvider<ValueHolder>(
    initialData: ValueHolder(),
    create: (BuildContext context) =>
        Provider.of<PsSharedPreferences>(context, listen: false).valueHolder,
  ),
];
