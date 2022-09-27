import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenMembersUserPermissions
    extends Object<SettingsScreenMembersUserPermissions> {
  final bool? addNewMember;
  final bool? membersListView;
  final bool? membersViewAssignedNumber;
  final bool? deleteMember;
  final bool? invitedMembersView;
  final bool? invitedMembersResendInvite;

  SettingsScreenMembersUserPermissions(
      {this.addNewMember,
      this.membersListView,
      this.membersViewAssignedNumber,
      this.deleteMember,
      this.invitedMembersView,
      this.invitedMembersResendInvite});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenMembersUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenMembersUserPermissions(
        addNewMember: dynamicData["add_new_member"] == null
            ? null
            : dynamicData["add_new_member"] as bool,
        membersListView: dynamicData["members_list_view"] == null
            ? null
            : dynamicData["members_list_view"] as bool,
        membersViewAssignedNumber:
            dynamicData["members_view_assigned_number"] == null
                ? null
                : dynamicData["members_view_assigned_number"] as bool,
        deleteMember: dynamicData["delete_member"] == null
            ? null
            : dynamicData["delete_member"] as bool,
        invitedMembersView: dynamicData["invited_members_view"] == null
            ? null
            : dynamicData["invited_members_view"] as bool,
        invitedMembersResendInvite:
            dynamicData["invited_members_resend_invite"] == null
                ? null
                : dynamicData["invited_members_resend_invite"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenMembersUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["add_new_member"] = object.addNewMember;
      data["members_list_view"] = object.membersListView;
      data["members_view_assigned_number"] = object.membersViewAssignedNumber;
      data["delete_member"] = object.deleteMember;
      data["invited_members_view"] = object.invitedMembersView;
      data["invited_members_resend_invite"] = object.invitedMembersResendInvite;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenMembersUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenMembersUserPermissions> listMessages =
        <SettingsScreenMembersUserPermissions>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as SettingsScreenMembersUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
