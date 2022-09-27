import "package:mvp/viewObject/common/Object.dart";

class ConversationSeen extends Object<ConversationSeen> {
  bool? success;

  ConversationSeen({
    this.success,
  });

  @override
  ConversationSeen? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ConversationSeen(
        success: dynamicData["success"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ConversationSeen? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["success"] = object!.success;
    return data;
  }

  @override
  List<ConversationSeen>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ConversationSeen> basketList = <ConversationSeen>[];
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
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ConversationSeen>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ConversationSeen data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
