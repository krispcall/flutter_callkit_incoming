import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class Notes extends Object<Notes> {
  Notes({
    this.id,
    this.title,
    this.createdAt,
    this.modifiedAt,
    this.userId,
    this.firstName,
    this.lastName,
    this.profilePicture,
  });

  String? id;
  String? title;
  String? createdAt;
  String? modifiedAt;
  String? userId;
  String? firstName;
  String? lastName;
  String? profilePicture;

  @override
  bool operator ==(dynamic other) => other is Notes && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  Notes? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Notes(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        createdAt: dynamicData["createdAt"] == null
            ? null
            : dynamicData["createdAt"] as String,
        modifiedAt: dynamicData["modifiedAt"] == null
            ? null
            : dynamicData["modifiedAt"] as String,
        userId: dynamicData["userId"] == null
            ? null
            : dynamicData["userId"] as String,
        firstName: dynamicData["firstName"] == null
            ? null
            : dynamicData["firstName"] as String,
        lastName: dynamicData["lastName"] == null
            ? null
            : dynamicData["lastName"] as String,
        profilePicture: dynamicData["profilePicture"] == null
            ? null
            : dynamicData["profilePicture"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Notes? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["title"] = object.title;
      data["createdAt"] = object.createdAt;
      data["modifiedAt"] = object.modifiedAt;
      data["userId"] = object.userId;
      data["firstName"] = object.firstName;
      data["lastName"] = object.lastName;
      data["profilePicture"] = object.profilePicture;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Notes>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Notes> basketList = <Notes>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Notes>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Notes data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
