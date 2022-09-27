import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenProfileUserPermissions
    extends Object<SettingsScreenProfileUserPermissions> {
  final bool? editFullName;
  final bool? editEmail;
  final bool? changePassword;
  final bool? changeProfilePicture;

  SettingsScreenProfileUserPermissions(
      {this.editFullName,
      this.editEmail,
      this.changePassword,
      this.changeProfilePicture});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenProfileUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenProfileUserPermissions(
        editFullName: dynamicData["edit_full_name"] == null
            ? null
            : dynamicData["edit_full_name"] as bool,
        editEmail: dynamicData["edit_email"] == null? null :dynamicData["edit_email"] as bool,
        changePassword: dynamicData["change_password"] == null? null :dynamicData["change_password"] as bool,
        changeProfilePicture: dynamicData["change_profile_picture"] == null? null :dynamicData["change_profile_picture"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenProfileUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["edit_full_name"] = object.editFullName;
      data["edit_email"] = object.editEmail;
      data["change_password"] = object.changePassword;
      data["change_profile_picture"] = object.changeProfilePicture;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenProfileUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenProfileUserPermissions> listMessages =
        <SettingsScreenProfileUserPermissions>[];

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
          dynamicList.add(toMap(data as SettingsScreenProfileUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
