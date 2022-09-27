import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenWorkplaceUserPermissions
    extends Object<SettingsScreenWorkplaceUserPermissions> {
  final bool? updateProfilePicture;
  final bool? changeWorkplaceName;
  final bool? enableNotification;
  final bool? deleteWorkplace;

  SettingsScreenWorkplaceUserPermissions(
      {this.updateProfilePicture,
      this.changeWorkplaceName,
      this.enableNotification,
      this.deleteWorkplace});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenWorkplaceUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenWorkplaceUserPermissions(
        updateProfilePicture: dynamicData["update_profile_picture"] == null
            ? null
            : dynamicData["update_profile_picture"] as bool,
        changeWorkplaceName: dynamicData["change_workplace_name"] == null? null :dynamicData["change_workplace_name"] as bool,
        enableNotification: dynamicData["enable_notification"] == null? null :dynamicData["enable_notification"] as bool,
        deleteWorkplace: dynamicData["delete_workplace"] == null? null :dynamicData["delete_workplace"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenWorkplaceUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["update_profile_picture"] = object.updateProfilePicture;
      data["change_workplace_name"] = object.changeWorkplaceName;
      data["enable_notification"] = object.enableNotification;
      data["delete_workplace"] = object.deleteWorkplace;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenWorkplaceUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenWorkplaceUserPermissions> listMessages =
        <SettingsScreenWorkplaceUserPermissions>[];

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
          dynamicList
              .add(toMap(data as SettingsScreenWorkplaceUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
