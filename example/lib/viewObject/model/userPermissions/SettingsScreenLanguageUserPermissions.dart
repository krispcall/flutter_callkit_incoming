import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenLanguageUserPermissions
    extends Object<SettingsScreenLanguageUserPermissions> {
  final bool? languageSwitch;

  SettingsScreenLanguageUserPermissions({this.languageSwitch});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenLanguageUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenLanguageUserPermissions(
        languageSwitch: dynamicData["language_switch"] == null? null :dynamicData["language_switch"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenLanguageUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["language_switch"] = object.languageSwitch;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenLanguageUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenLanguageUserPermissions> listMessages =
        <SettingsScreenLanguageUserPermissions>[];

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
          dynamicList.add(toMap(data as SettingsScreenLanguageUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
