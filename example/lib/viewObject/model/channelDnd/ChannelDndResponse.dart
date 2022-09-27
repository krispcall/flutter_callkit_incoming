import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/userDnd/DndData.dart";

class ChannelDndResponse extends Object<ChannelDndResponse> {
  ChannelDndResponse({
    this.channelDndResponse,
    this.removeDndResponse,
  });

  DndData? channelDndResponse;
  DndData? removeDndResponse;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChannelDndResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelDndResponse(
        channelDndResponse: DndData().fromMap(dynamicData["setChannelDnd"]),
        removeDndResponse: DndData().fromMap(dynamicData["removeChannelDnd"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ChannelDndResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      if (object.channelDndResponse != null) {
        data["setChannelDnd"] = DndData().toMap(object.channelDndResponse!);
      }
      if (object.removeDndResponse != null) {
        data["removeChannelDnd"] = DndData().toMap(object.channelDndResponse!);
      }
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelDndResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ChannelDndResponse> data = <ChannelDndResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<ChannelDndResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChannelDndResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
