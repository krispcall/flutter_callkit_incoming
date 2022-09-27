import "package:mvp/viewObject/common/Object.dart";

class UserProfileData extends Object<UserProfileData> {
  UserProfileData({
    this.status,
    this.profilePicture,
    this.firstName,
    this.lastName,
    this.email,
    this.defaultLanguage,
    this.defaultWorkspace,
    this.stayOnline,
    this.dndEnabled,
    this.dndEndtime,
    this.dndDuration,
  });

  String? status;
  String? profilePicture;
  String? firstName;
  String? lastName;
  String? email;
  String? defaultLanguage;
  String? defaultWorkspace;
  bool? stayOnline;
  bool? dndEnabled;
  int? dndEndtime;
  int? dndDuration;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  UserProfileData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UserProfileData(
        status: dynamicData["status"] == null
            ? null
            : dynamicData["status"] as String,
        profilePicture: dynamicData["profilePicture"] == null
            ? null
            : dynamicData["profilePicture"] as String,
        firstName: dynamicData["firstname"] == null
            ? null
            : dynamicData["firstname"] as String,
        lastName: dynamicData["lastname"] == null
            ? null
            : dynamicData["lastname"] as String,
        email: dynamicData["email"] == null
            ? null
            : dynamicData["email"] as String,
        defaultLanguage: dynamicData["defaultLanguage"] == null
            ? null
            : dynamicData["defaultLanguage"] as String,
        defaultWorkspace: dynamicData["defaultWorkspace"] == null
            ? null
            : dynamicData["defaultWorkspace"] as String,
        stayOnline: dynamicData["stayOnline"] == null
            ? null
            : dynamicData["stayOnline"] as bool,
        dndEnabled: dynamicData["dndEnabled"] == null
            ? null
            : dynamicData["dndEnabled"] as bool,
        dndEndtime: dynamicData["dndEndtime"] == null
            ? null
            : dynamicData["dndEndtime"] as int,
        dndDuration: dynamicData["dndDuration"] == null
            ? null
            : dynamicData["dndDuration"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UserProfileData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["profilePicture"] = object.profilePicture;
      data["firstname"] = object.firstName;
      data["lastname"] = object.lastName;
      data["email"] = object.email;
      data["defaultLanguage"] = object.defaultLanguage;
      data["defaultWorkspace"] = object.defaultWorkspace;
      data["stayOnline"] = object.stayOnline;
      data["dndEnabled"] = object.dndEnabled;
      data["dndEndtime"] = object.dndEndtime;
      data["dndDuration"] = object.dndDuration;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UserProfileData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UserProfileData> userProfile = <UserProfileData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userProfile.add(fromMap(dynamicData)!);
        }
      }
    }
    return userProfile;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<UserProfileData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UserProfileData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
