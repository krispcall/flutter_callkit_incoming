import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenTeamsUserPermissions
    extends Object<SettingsScreenTeamsUserPermissions> {
  final bool? createNewTeam;
  final bool? teamListView;
  final bool? teamEdit;
  final bool? teamDelete;

  SettingsScreenTeamsUserPermissions(
      {this.createNewTeam, this.teamListView, this.teamEdit, this.teamDelete});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenTeamsUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenTeamsUserPermissions(
        createNewTeam: dynamicData["create_new_team"] == null
            ? null
            : dynamicData["create_new_team"] as bool,
        teamListView: dynamicData["team_list_view"] == null
            ? null
            : dynamicData["team_list_view"] as bool,
        teamEdit: dynamicData["team_edit"] == null
            ? null
            : dynamicData["team_edit"] as bool,
        teamDelete: dynamicData["team_delete"] == null
            ? null
            : dynamicData["team_delete"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenTeamsUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["create_new_team"] = object.createNewTeam;
      data["team_list_view"] = object.teamListView;
      data["team_edit"] = object.teamEdit;
      data["team_delete"] = object.teamDelete;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenTeamsUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenTeamsUserPermissions> listMessages =
        <SettingsScreenTeamsUserPermissions>[];

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
          dynamicList.add(toMap(data as SettingsScreenTeamsUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
