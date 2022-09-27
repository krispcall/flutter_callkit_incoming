import "package:mvp/viewObject/ResponseData.dart";
import "package:mvp/viewObject/common/Object.dart";

class ChannelInfoResponse extends Object<ChannelInfoResponse> {
  ChannelInfoResponse({
    this.channelInfo,
  });

  ResponseData? channelInfo;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ChannelInfoResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelInfoResponse(
          channelInfo: ResponseData().fromMap(dynamicData["channelInfo"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ChannelInfoResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["channelInfo"] = ResponseData().toMap(object.channelInfo);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelInfoResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ChannelInfoResponse> userData = <ChannelInfoResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          userData.add(fromMap(dynamicData)!);
        }
      }
    }
    return userData;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ChannelInfoResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChannelInfoResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
