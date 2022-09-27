import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/blockContact/BlockContactData.dart";

class BlockContactListResponse extends Object<BlockContactListResponse> {
  BlockContactListResponse({
    this.blockContacts,
  });

  BlockContactData? blockContacts;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  BlockContactListResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return BlockContactListResponse(
        blockContacts:
            BlockContactData().fromMap(dynamicData["blockedContacts"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(BlockContactListResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["blockContacts"] = BlockContactData().toMap(object.blockContacts);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<BlockContactListResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<BlockContactListResponse> psBlockContactListResponseList =
        <BlockContactListResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          psBlockContactListResponseList.add(fromMap(json)!);
        }
      }
    }
    return psBlockContactListResponseList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as BlockContactListResponse));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
