import "package:mvp/api/common/Status.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class ApiStatus extends Object<ApiStatus> {
  ApiStatus({
    this.status,
    this.message,
  });

  Status? status;
  String? message;

  @override
  bool operator ==(dynamic other) =>
      other is ApiStatus && status == other.status;

  @override
  int get hashCode => hash2(status.hashCode, status.hashCode);

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<ApiStatus> fromMapList(List<dynamic>? dynamicDataList) {
    final List<ApiStatus> subCategoryList = <ApiStatus>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  ApiStatus? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ApiStatus(
        status: dynamicData["status"] as Status,
        message: dynamicData["message"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ApiStatus? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status.toString();
      data["message"] = object.message;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ApiStatus>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ApiStatus data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
