import "package:mvp/viewObject/common/MapObject.dart";

class PageInfo extends MapObject<PageInfo> {
  PageInfo(
      {this.startCursor,
      this.endCursor,
      this.hasNextPage,
      this.hasPreviousPage});

  String? startCursor;
  String? endCursor;
  bool? hasNextPage;
  bool? hasPreviousPage;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  PageInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PageInfo(
        startCursor: dynamicData["startCursor"] == null
            ? null
            : dynamicData["startCursor"] as String,
        endCursor: dynamicData["endCursor"] == null
            ? null
            : dynamicData["endCursor"] as String,
        hasNextPage: dynamicData["hasNextPage"] == null
            ? null
            : dynamicData["hasNextPage"] as bool,
        hasPreviousPage: dynamicData["hasPreviousPage"] == null
            ? null
            : dynamicData["hasPreviousPage"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(PageInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["startCursor"] = object.startCursor;
      data["endCursor"] = object.endCursor;
      data["hasNextPage"] = object.hasNextPage;
      data["hasPreviousPage"] = object.hasPreviousPage;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PageInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PageInfo> basketList = <PageInfo>[];

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
  List<Map<String, dynamic>>? toMapList(List<PageInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final PageInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<dynamic>? mapList, dynamic key, dynamic value) {
    // TODO: implement getIdByKeyValue
    throw UnimplementedError();
  }
}
