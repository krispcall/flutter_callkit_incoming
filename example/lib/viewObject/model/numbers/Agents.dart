import "package:mvp/viewObject/common/Object.dart";

class Agents extends Object<Agents> {
  String? id;
  String? firstname;
  String? lastname;
  String? photo;

  Agents({this.id, this.firstname, this.lastname, this.photo});

  @override
  Agents? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Agents(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        firstname: dynamicData["firstname"] == null
            ? null
            : dynamicData["firstname"] as String,
        lastname: dynamicData["lastname"] == null
            ? null
            : dynamicData["lastname"] as String,
        photo: dynamicData["photo"] == null
            ? null
            : dynamicData["photo"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  List<Agents>? fromMapList(List? dynamicDataList) {
    final List<Agents> data = <Agents>[];

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
  String? getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(Agents? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["firstname"] = object.firstname;
      data["lastname"] = object.lastname;
      data["photo"] = object.photo;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Agents>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Agents data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
