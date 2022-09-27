import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/call/pinnedContact/PinnedConversationData.dart";

class PinnedConversationResponse extends Object<PinnedConversationResponse> {
  PinnedConversationData? pinnedConversationData;

  PinnedConversationResponse({this.pinnedConversationData});

  @override
  PinnedConversationResponse fromMap(dynamic dynamicData) {
    return PinnedConversationResponse(
      pinnedConversationData: dynamicData["contactPinnedConversation"] != null
          ? PinnedConversationData()
              .fromMap(dynamicData["contactPinnedConversation"])
          : null,
    );
  }

  @override
  Map<String, dynamic>? toMap(PinnedConversationResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.pinnedConversationData != null) {
      data["contactPinnedConversation"] =
          PinnedConversationData().toMap(object.pinnedConversationData!);
    }
    return data;
  }

  @override
  List<PinnedConversationResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PinnedConversationResponse> basketList =
        <PinnedConversationResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData));
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
  List<Map<String, dynamic>>? toMapList(
      List<PinnedConversationResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final PinnedConversationResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
