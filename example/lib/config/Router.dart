import "package:flutter/material.dart";
import "package:mvp/constant/RoutePaths.dart";
import "package:mvp/ui/app_info/AppInfoView.dart";
import "package:mvp/ui/blocklist/BlockListWidget.dart";
import "package:mvp/ui/common/EmptyWorkSpaceWidget.dart";
import "package:mvp/ui/contacts/contact_add/ContactAddView.dart";
import "package:mvp/ui/contacts/contact_individual_detail_edit/ContactIndividualDetailEdit.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/ui/members/NavigationMemberListView.dart";
import "package:mvp/ui/members/memberMessageDetail/MemberMessageDetailView.dart";
import "package:mvp/ui/message/conversation_search/MessageConversationSearchView.dart";
import "package:mvp/ui/message/message_detail/MessageDetailView.dart";
import "package:mvp/ui/notes/AddNotesView.dart";
import "package:mvp/ui/notes/NotesListView.dart";
import "package:mvp/ui/number/NumberListView.dart";
import "package:mvp/ui/number_setting/edit/ChannelNameEditView.dart";
import "package:mvp/ui/number_setting/notification/ChannelNotificationView.dart";
import "package:mvp/ui/overview/OverViewWidget.dart";
import "package:mvp/ui/sound_settings/SoundSettingsView.dart";
import "package:mvp/ui/teams/NavigationTeamsListView.dart";
import "package:mvp/ui/teams/teamsMemberList/TeamsMemberListView.dart";
import "package:mvp/ui/user/edit_profile/EditProfileDetailView.dart";
import "package:mvp/ui/user/edit_profile/ProfileIndividualEditView.dart";
import "package:mvp/ui/user/forgot_password/ForgotPasswordView.dart";
import "package:mvp/ui/user/login/LoginView.dart";
import "package:mvp/ui/user_notification/UserNotificationSettingView.dart";
import "package:mvp/viewObject/holder/intent_holder/AddContactIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/AddNotesIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditContactIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EditProfileIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/EmptyCardDetailsParamHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MemberListIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MemberMessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/MessageDetailIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/NumberListIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/NumberSettingIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/OverWorkspaceIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/SearchConversationIntentHolder.dart";
import "package:mvp/viewObject/holder/intent_holder/TeamListIntentHolder.dart";

final routes = {
  "/": (context) => const AppInfoView(),
  RoutePaths.emptyWorkspace: (BuildContext context) => EmptyWorkspaceWidget(
        onContinueToWebsiteClick: (ModalRoute.of(context)!.settings.arguments
                as EmptyCardDetailsParamHolder)
            .onContinueToWebsiteClick,
        onLogoutPressed: (ModalRoute.of(context)?.settings.arguments
                as EmptyCardDetailsParamHolder)
            .onLogoutClick,
        userProvider: (ModalRoute.of(context)?.settings.arguments
                as EmptyCardDetailsParamHolder)
            .userProvider,
      ),
  RoutePaths.home: (BuildContext context) => DashboardView(),
  // RoutePaths.home: (BuildContext context) => const MyHomePage(
  //       title: "Discord",
  //     ),
  RoutePaths.loginView: (BuildContext context) => LoginView(),
  RoutePaths.newContact: (BuildContext context) => ContactAddView(
        key: UniqueKey(),
        defaultCountryCode: (ModalRoute.of(context)!.settings.arguments
                as AddContactIntentHolder)
            .defaultCountryCode,
        phoneNumber: (ModalRoute.of(context)!.settings.arguments
                as AddContactIntentHolder)
            .phoneNumber,
        onIncomingTap: (ModalRoute.of(context)!.settings.arguments
                as AddContactIntentHolder)
            .onIncomingTap!,
        onOutgoingTap: (ModalRoute.of(context)!.settings.arguments
                as AddContactIntentHolder)
            .onOutgoingTap!,
      ),
  RoutePaths.editContact: (BuildContext context) =>
      ContactIndividualDetailEditView(
        editName: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .editName!,
        contactName: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .contactName!,
        contactNumber: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .contactNumber!,
        email: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .email!,
        company: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .company!,
        address: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .address!,
        visibility: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .visibility!,
        photoUpload: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .photoUpload!,
        tags: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .tags!,
        id: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .id!,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as EditContactIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.editProfileDetail: (BuildContext context) => EditProfileDetailView(
        onProfileUpdateCallback: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onProfileUpdateCallback,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.profileIndividualEditView: (BuildContext context) =>
      ProfileIndividualDetailEditView(
        whichToEdit: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .whichToEdit,
        onProfileUpdateCallback: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onProfileUpdateCallback,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as EditProfileIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.messageDetail: (context) => MessageDetailView(
        clientId: (ModalRoute.of(context)!.settings.arguments!
                as MessageDetailIntentHolder)
            .clientId,
        clientName: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .clientName,
        clientPhoneNumber: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .clientPhoneNumber,
        countryId: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .countryId,
        clientProfilePicture: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .clientProfilePicture,
        lastChatted: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .lastChatted,
        channelId: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .channelId,
        channelName: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .channelName,
        channelNumber: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .channelNumber,
        isBlocked: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .isBlocked,
        // dndMissed: (ModalRoute.of(context)?.settings.arguments
        //         as MessageDetailIntentHolder)
        //     .dndMissed,
        onIncomingTap: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .onIncomingTap!,
        onOutgoingTap: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .onOutgoingTap!,
        makeCallWithSid: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .makeCallWithSid,
        onContactBlocked: (ModalRoute.of(context)!.settings.arguments
                as MessageDetailIntentHolder)
            .onContactBlocked,
      ),
  RoutePaths.memberMessageDetail: (context) => MemberMessageDetailView(
        clientId: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .clientId,
        clientName: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .clientName,
        clientProfilePicture: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .clientProfilePicture
            .trim(),
        onlineStatus: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .onlineStatus,
        clientEmail: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .clientEmail,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as MemberMessageDetailIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.searchConversation: (context) => MessageConversationSearchView(
        channelId: (ModalRoute.of(context)?.settings.arguments
                as SearchConversationIntentHolder)
            .channelId,
        contactNumber: (ModalRoute.of(context)?.settings.arguments
                as SearchConversationIntentHolder)
            .contactNumber,
        contactName: (ModalRoute.of(context)?.settings.arguments
                as SearchConversationIntentHolder)
            .contactName,
        animationController: (ModalRoute.of(context)?.settings.arguments
                as SearchConversationIntentHolder)
            .animationController,
      ),
  RoutePaths.notesList: (context) => NotesListView(
        clientId:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .clientId,
        clientNumber:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .number,
        channelId:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .channelId,
        onIncomingTap:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .onIncomingTap,
        onOutgoingTap:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .onOutgoingTap,
      ),
  RoutePaths.addNewNotes: (context) => AddNotesView(
        clientId:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .clientId,
        clientNumber:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .number,
        channelId:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .channelId,
        onIncomingTap:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .onIncomingTap,
        onOutgoingTap:
            (ModalRoute.of(context)?.settings.arguments as AddNotesIntentHolder)
                .onOutgoingTap,
      ),
  RoutePaths.teamsList: (context) => NavigationTeamListView(
        onIncomingTap:
            (ModalRoute.of(context)?.settings.arguments as TeamListIntentHolder)
                .onIncomingTap,
        onOutgoingTap:
            (ModalRoute.of(context)?.settings.arguments as TeamListIntentHolder)
                .onOutgoingTap,
      ),
  RoutePaths.teamsMemberList: (context) => TeamsMemberListView(
        teamId:
            (ModalRoute.of(context)?.settings.arguments as TeamListIntentHolder)
                .teamId,
        onIncomingTap:
            (ModalRoute.of(context)?.settings.arguments as TeamListIntentHolder)
                .onIncomingTap,
        onOutgoingTap:
            (ModalRoute.of(context)?.settings.arguments as TeamListIntentHolder)
                .onOutgoingTap,
      ),
  RoutePaths.myNumbers: (context) => NumberListView(
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.memberList: (context) => NavigationMemberListView(
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as MemberListIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as MemberListIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.overview: (context) => OverViewWidget(
        onUpdateCallback: (ModalRoute.of(context)?.settings.arguments
                as OverViewWorkspaceIntentHolder)
            .onUpdateCallback,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as OverViewWorkspaceIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as OverViewWorkspaceIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.forgotPassword: (context) => ForgotPasswordView(),
  RoutePaths.userNotificationSetting: (context) => NotificationSettingView(
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.soundSettings: (context) => SoundSettingsView(
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.editChannelName: (context) => ChannelNameEditView(
        onUpdateCallback: (ModalRoute.of(context)?.settings.arguments
                as NumberSettingIntentHolder)
            .onUpdateCallback!,
        channel: (ModalRoute.of(context)?.settings.arguments
                as NumberSettingIntentHolder)
            .channel!,
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberSettingIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberSettingIntentHolder)
            .onOutgoingTap,
      ),
  RoutePaths.channelNotification: (context) => const ChannelNotificationView(),
  RoutePaths.blockList: (context) => BlockListWidget(
        onIncomingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onIncomingTap,
        onOutgoingTap: (ModalRoute.of(context)?.settings.arguments
                as NumberListIntentHolder)
            .onOutgoingTap,
      ),
};
