import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/profile/ProfileData.dart";

class ChangeProfilePicture extends Object<ChangeProfilePicture> {
  ChangeProfilePicture({
    this.data,
  });

  ProfileData? data;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  ChangeProfilePicture? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChangeProfilePicture(
        data: ProfileData().fromMap(dynamicData["changeProfilePicture"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ChangeProfilePicture? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["changeProfilePicture"] = ProfileData().toMap(object.data!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChangeProfilePicture>? fromMapList(List<dynamic> ?dynamicDataList) {
    final List<ChangeProfilePicture> data = <ChangeProfilePicture>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ChangeProfilePicture>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChangeProfilePicture data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
