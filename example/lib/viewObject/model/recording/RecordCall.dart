import "package:mvp/viewObject/common/Object.dart";

class RecordCall extends Object<RecordCall> {
  RecordCall({
    this.status,
  });

  String? status;

  @override
  RecordCall? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return RecordCall(
        status:dynamicData["status"] == null? null : dynamicData["status"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic> ?toMap(RecordCall ?object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<RecordCall>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  String getPrimaryKey() {
    // TODO: implement getPrimaryKey
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<RecordCall> ?objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
