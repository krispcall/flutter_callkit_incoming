import "package:mvp/viewObject/common/Object.dart";

class MainScreenNavigationUserPermissions
    extends Object<MainScreenNavigationUserPermissions> {
  final bool? searchBox;
  final bool? showDialer;
  final bool? dashboardView;
  final bool? contactView;
  final bool? settingsView;
  final bool? numbersAddNew;
  final bool? numbersViewDetails;
  final bool? numbersDND;
  final bool? numbersSettings;
  final bool? membersAddNew;
  final bool? teamsAddNew;
  final bool? tagsViewDetails;

  MainScreenNavigationUserPermissions(
      {this.searchBox,
      this.showDialer,
      this.dashboardView,
      this.contactView,
      this.settingsView,
      this.numbersAddNew,
      this.numbersViewDetails,
      this.numbersDND,
      this.numbersSettings,
      this.membersAddNew,
      this.teamsAddNew,
      this.tagsViewDetails});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  MainScreenNavigationUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return MainScreenNavigationUserPermissions(
        searchBox: dynamicData["search_box"] == null? null :dynamicData["search_box"] as bool,
        showDialer: dynamicData["show_dialer"] == null? null :dynamicData["show_dialer"] as bool,
        dashboardView: dynamicData["dashboard_view"] == null? null :dynamicData["dashboard_view"] as bool,
        contactView: dynamicData["contact_view"] == null? null :dynamicData["contact_view"] as bool,
        settingsView: dynamicData["settings_view"] == null? null :dynamicData["settings_view"] as bool,
        numbersAddNew: dynamicData["numbers_add_new"] == null? null :dynamicData["numbers_add_new"] as bool,
        numbersViewDetails: dynamicData["numbers_view_details"] == null? null :dynamicData["numbers_view_details"] as bool,
        numbersDND: dynamicData["numbers_do_not_disturb"] == null? null :dynamicData["numbers_do_not_disturb"] as bool,
        numbersSettings: dynamicData["numbers_settings"] == null? null :dynamicData["numbers_settings"] as bool,
        membersAddNew: dynamicData["members_add_new"] == null? null :dynamicData["members_add_new"] as bool,
        teamsAddNew: dynamicData["teams_add_new"] == null? null :dynamicData["teams_add_new"] as bool,
        tagsViewDetails: dynamicData["tags_view_details"] == null? null :dynamicData["tags_view_details"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(MainScreenNavigationUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["search_box"] = object.searchBox;
      data["show_dialer"] = object.showDialer;
      data["dashboard_view"] = object.dashboardView;
      data["contact_view"] = object.contactView;
      data["settings_view"] = object.settingsView;
      data["numbers_add_new"] = object.numbersAddNew;
      data["numbers_view_details"] = object.numbersViewDetails;
      data["numbers_do_not_disturb"] = object.numbersDND;
      data["numbers_settings"] = object.numbersSettings;
      data["members_add_new"] = object.membersAddNew;
      data["teams_add_new"] = object.teamsAddNew;
      data["tags_view_details"] = object.tagsViewDetails;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<MainScreenNavigationUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<MainScreenNavigationUserPermissions> listMessages =
        <MainScreenNavigationUserPermissions>[];

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
          dynamicList.add(toMap(data as MainScreenNavigationUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
