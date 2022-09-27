import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/login/LoginWorkspace.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
import "package:quiver/core.dart";

class LoginDataDetails extends Object<LoginDataDetails> {
  LoginDataDetails({
    this.id,
    this.workspaces,
    this.userProfile,
  });

  String? id;
  List<LoginWorkspace>? workspaces;
  UserProfileData? userProfile;

  @override
  bool operator ==(dynamic other) =>
      other is LoginDataDetails && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id!;
  }

  @override
  LoginDataDetails? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginDataDetails(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        workspaces: LoginWorkspace().fromMapList(
            dynamicData["workspaces"] == null
                ? null
                : dynamicData["workspaces"] as List<dynamic>),
        userProfile: UserProfileData().fromMap(dynamicData["userProfile"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginDataDetails? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["workspaces"] = LoginWorkspace().toMapList(object.workspaces!);
      data["userProfile"] = UserProfileData().toMap(object.userProfile!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<LoginDataDetails>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginDataDetails> workSpace = <LoginDataDetails>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          workSpace.add(fromMap(dynamicData)!);
        }
      }
    }
    return workSpace;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<LoginDataDetails>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginDataDetails data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
