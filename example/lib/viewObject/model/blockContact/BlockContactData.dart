import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class BlockContactData<T> extends Object<BlockContactData<T>> {
  BlockContactData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  T? data;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  BlockContactData<T>? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return BlockContactData(
        status: dynamicData["status"] as int,
        data: dynamicData["data"] as T,
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(BlockContactData<T>? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = object.data;
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<BlockContactData<T>>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<BlockContactData<T>>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
