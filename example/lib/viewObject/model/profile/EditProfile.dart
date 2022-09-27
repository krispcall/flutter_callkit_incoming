import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/profile/ProfileData.dart";

class EditProfile extends Object<EditProfile> {
  EditProfile({
    this.profile,
  });

  ProfileData? profile;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  EditProfile? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditProfile(
        profile: ProfileData().fromMap(dynamicData["changeProfileNames"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(EditProfile? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["changeProfileNames"] = ProfileData().toMap(object.profile!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<EditProfile>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<EditProfile> userData = <EditProfile>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData)!);
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<EditProfile>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final EditProfile data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
