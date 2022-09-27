import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class AllNotesResponseData extends Object<AllNotesResponseData> {
  AllNotesResponseData({
    this.status,
    this.listNotes,
    this.error,
  });

  int? status;
  List<Notes>? listNotes;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllNotesResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllNotesResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        listNotes: Notes().fromMapList(dynamicData["data"] as List<dynamic>),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllNotesResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = Notes().toMapList(object.listNotes!);
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllNotesResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllNotesResponseData> login = <AllNotesResponseData>[];
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
  List<Map<String, dynamic>>? toMapList(
      List<AllNotesResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllNotesResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
