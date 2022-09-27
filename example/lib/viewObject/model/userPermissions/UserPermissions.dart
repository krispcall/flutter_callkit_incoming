import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userPermissions/ContactsScreenUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/MainScreenUserPermissions.dart";
import "package:mvp/viewObject/model/userPermissions/SettingsScreenUserPermissions.dart";

class UserPermissions extends Object<UserPermissions> {
  final MainScreenUserPermissions? mainScreenUserPermissions;
  final ContactsScreenUserPermissions? contactsScreenUserPermissions;
  final SettingsScreenUserPermissions? settingsScreenUserPermissions;

  UserPermissions(
      {this.mainScreenUserPermissions,
      this.contactsScreenUserPermissions,
      this.settingsScreenUserPermissions});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserPermissions(
        mainScreenUserPermissions:
            MainScreenUserPermissions().fromMap(dynamicData["main_screen"]),
        contactsScreenUserPermissions:
            ContactsScreenUserPermissions().fromMap(dynamicData["contacts"]),
        settingsScreenUserPermissions:
            SettingsScreenUserPermissions().fromMap(dynamicData["settings"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["main_screen"] =
          MainScreenUserPermissions().toMap(object.mainScreenUserPermissions);
      data["contacts"] = ContactsScreenUserPermissions()
          .toMap(object.contactsScreenUserPermissions);
      data["settings"] = SettingsScreenUserPermissions()
          .toMap(object.settingsScreenUserPermissions);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserPermissions>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserPermissions> listMessages = <UserPermissions>[];

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
          dynamicList.add(toMap(data as UserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
