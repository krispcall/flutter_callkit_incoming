import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenNotificationsUserPermissions
    extends Object<SettingsScreenNotificationsUserPermissions> {
  final bool? enableDesktopNotification;
  final bool? enableNewCallsMessage;
  final bool? enableNewLeads;
  final bool? enableFlashTaskBar;

  SettingsScreenNotificationsUserPermissions(
      {this.enableDesktopNotification,
      this.enableNewCallsMessage,
      this.enableNewLeads,
      this.enableFlashTaskBar});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenNotificationsUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenNotificationsUserPermissions(
        enableDesktopNotification:
            dynamicData["enable_desktop_notification"] == null? null :dynamicData["enable_desktop_notification"] as bool,
        enableNewCallsMessage: dynamicData["enable_new_calls_message"] == null? null :dynamicData["enable_new_calls_message"] as bool,
        enableNewLeads: dynamicData["enable_new_leads"] == null? null :dynamicData["enable_new_leads"] as bool,
        enableFlashTaskBar: dynamicData["enable_flash_taskbar"] == null? null :dynamicData["enable_flash_taskbar"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(
      SettingsScreenNotificationsUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["enable_desktop_notification"] = object.enableDesktopNotification;
      data["enable_new_calls_message"] = object.enableNewCallsMessage;
      data["enable_new_leads"] = object.enableNewLeads;
      data["enable_flash_taskbar"] = object.enableFlashTaskBar;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenNotificationsUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenNotificationsUserPermissions> listMessages =
        <SettingsScreenNotificationsUserPermissions>[];

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
              .add(toMap(data as SettingsScreenNotificationsUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
