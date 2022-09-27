import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allNotes/AllNotesResponseData.dart";

class AllNotesResponse extends Object<AllNotesResponse> {
  AllNotesResponse({
    this.clientNotes,
  });

  AllNotesResponseData? clientNotes;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllNotesResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllNotesResponse(
        clientNotes: AllNotesResponseData().fromMap(dynamicData["clientNotes"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllNotesResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["clientNotes"] = AllNotesResponseData().toMap(object.clientNotes!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllNotesResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllNotesResponse> data = <AllNotesResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<AllNotesResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllNotesResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
