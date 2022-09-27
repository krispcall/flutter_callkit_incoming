import "package:mvp/viewObject/common/Object.dart";

class NoteTitle extends Object<NoteTitle> {
  NoteTitle({
    this.title,
  });

  String? title;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  NoteTitle? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NoteTitle(
        title: dynamicData["title"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NoteTitle? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["title"] = object.title;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NoteTitle>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NoteTitle> login = <NoteTitle>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<NoteTitle>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NoteTitle data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
