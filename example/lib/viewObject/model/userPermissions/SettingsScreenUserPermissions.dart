import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenBillingUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenContactsUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenDevicesUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenIntegrationUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenLanguageUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenMembersUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenNotificationsUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenNumbersUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenProfileUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenTeamsUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenWorkplaceUserPermissions.dart";

class SettingsScreenUserPermissions
    extends Object<SettingsScreenUserPermissions> {
  final SettingsScreenProfileUserPermissions?
      settingsScreenProfileUserPermissions;
  final SettingsScreenNumbersUserPermissions?
      settingsScreenNumbersUserPermissions;
  final SettingsScreenMembersUserPermissions?
      settingsScreenMembersUserPermissions;
  final SettingsScreenTeamsUserPermissions? settingsScreenTeamsUserPermissions;
  final SettingsScreenContactsUserPermissions?
      settingsScreenContactsUserPermissions;
  final SettingsScreenWorkplaceUserPermissions?
      settingsScreenWorkplaceUserPermissions;
  final SettingsScreenIntegrationUserPermissions?
      settingsScreenIntegrationUserPermissions;
  final SettingsScreenBillingUserPermissions?
      settingsScreenBillingUserPermissions;
  final SettingsScreenDevicesUserPermissions?
      settingsScreenDevicesUserPermissions;
  final SettingsScreenNotificationsUserPermissions?
      settingsScreenNotificationsUserPermissions;
  final SettingsScreenLanguageUserPermissions?
      settingsScreenLanguageUserPermissions;

  SettingsScreenUserPermissions(
      {this.settingsScreenProfileUserPermissions,
      this.settingsScreenNumbersUserPermissions,
      this.settingsScreenMembersUserPermissions,
      this.settingsScreenTeamsUserPermissions,
      this.settingsScreenContactsUserPermissions,
      this.settingsScreenWorkplaceUserPermissions,
      this.settingsScreenIntegrationUserPermissions,
      this.settingsScreenBillingUserPermissions,
      this.settingsScreenDevicesUserPermissions,
      this.settingsScreenNotificationsUserPermissions,
      this.settingsScreenLanguageUserPermissions});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenUserPermissions(
        settingsScreenProfileUserPermissions:
            SettingsScreenProfileUserPermissions()
                .fromMap(dynamicData["my_profile"]),
        settingsScreenNumbersUserPermissions:
            SettingsScreenNumbersUserPermissions()
                .fromMap(dynamicData["my_numbers"]),
        settingsScreenMembersUserPermissions:
            SettingsScreenMembersUserPermissions()
                .fromMap(dynamicData["members"]),
        settingsScreenTeamsUserPermissions: SettingsScreenTeamsUserPermissions()
            .fromMap(dynamicData["my_team"]),
        settingsScreenContactsUserPermissions:
            SettingsScreenContactsUserPermissions()
                .fromMap(dynamicData["contacts"]),
        settingsScreenWorkplaceUserPermissions:
            SettingsScreenWorkplaceUserPermissions()
                .fromMap(dynamicData["workplace"]),
        settingsScreenIntegrationUserPermissions:
            SettingsScreenIntegrationUserPermissions()
                .fromMap(dynamicData["integration"]),
        settingsScreenBillingUserPermissions:
            SettingsScreenBillingUserPermissions()
                .fromMap(dynamicData["billing_plans"]),
        settingsScreenDevicesUserPermissions:
            SettingsScreenDevicesUserPermissions()
                .fromMap(dynamicData["devices"]),
        settingsScreenNotificationsUserPermissions:
            SettingsScreenNotificationsUserPermissions()
                .fromMap(dynamicData["notifications"]),
        settingsScreenLanguageUserPermissions:
            SettingsScreenLanguageUserPermissions()
                .fromMap(dynamicData["language"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["my_profile"] = SettingsScreenProfileUserPermissions()
          .toMap(object.settingsScreenProfileUserPermissions);
      data["my_numbers"] = SettingsScreenNumbersUserPermissions()
          .toMap(object.settingsScreenNumbersUserPermissions);
      data["members"] = SettingsScreenMembersUserPermissions()
          .toMap(object.settingsScreenMembersUserPermissions);
      data["my_team"] = SettingsScreenTeamsUserPermissions()
          .toMap(object.settingsScreenTeamsUserPermissions);
      data["contacts"] = SettingsScreenContactsUserPermissions()
          .toMap(object.settingsScreenContactsUserPermissions);
      data["workplace"] = SettingsScreenWorkplaceUserPermissions()
          .toMap(object.settingsScreenWorkplaceUserPermissions!);
      data["integration"] = SettingsScreenIntegrationUserPermissions()
          .toMap(object.settingsScreenIntegrationUserPermissions);
      data["billing_plans"] = SettingsScreenBillingUserPermissions()
          .toMap(object.settingsScreenBillingUserPermissions);
      data["devices"] = SettingsScreenDevicesUserPermissions()
          .toMap(object.settingsScreenDevicesUserPermissions);
      data["notifications"] = SettingsScreenNotificationsUserPermissions()
          .toMap(object.settingsScreenNotificationsUserPermissions);
      data["language"] = SettingsScreenLanguageUserPermissions()
          .toMap(object.settingsScreenLanguageUserPermissions);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenUserPermissions> listMessages =
        <SettingsScreenUserPermissions>[];

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
          dynamicList.add(toMap(data as SettingsScreenUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
