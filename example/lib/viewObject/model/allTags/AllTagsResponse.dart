import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allTags/AllTagsResponseData.dart";

class AllTagsResponse extends Object<AllTagsResponse> {
  AllTagsResponse({
    this.allTagsResponseData,
  });

  AllTagsResponseData? allTagsResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AllTagsResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AllTagsResponse(
        allTagsResponseData: AllTagsResponseData().fromMap(dynamicData["tags"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AllTagsResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["tags"] = AllTagsResponseData().toMap(object.allTagsResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AllTagsResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AllTagsResponse> data = <AllTagsResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<AllTagsResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AllTagsResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
