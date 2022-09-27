import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/createChatMessage/CreateChatMessageData.dart";

class CreateChatMessageResponse extends Object<CreateChatMessageResponse> {
  CreateChatMessageData? createChatMessageData;

  CreateChatMessageResponse({this.createChatMessageData});

  @override
  CreateChatMessageResponse? fromMap(dynamic dynamic) {
    return CreateChatMessageResponse(
        createChatMessageData: dynamic["createChatMessage"] != null
            ? CreateChatMessageData().fromMap(dynamic["createChatMessage"])
            : null);
  }

  Map<String, dynamic>? toMap(CreateChatMessageResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.createChatMessageData != null) {
      data["createChatMessage"] =
          CreateChatMessageData().toMap(object.createChatMessageData);
    }
    return data;
  }

  @override
  List<CreateChatMessageResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CreateChatMessageResponse> list = <CreateChatMessageResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<CreateChatMessageResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as CreateChatMessageResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
