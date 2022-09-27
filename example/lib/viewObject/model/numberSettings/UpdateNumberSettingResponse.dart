import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettingsResponseData.dart";

class UpdateNumberSettingResponse extends Object<UpdateNumberSettingResponse> {
  // {"data":{"updateGeneralSettings":{"status":200,"data":{"name":"Joshan Tandukar","autoRecordCalls":false,"internationalCallAndMessages":true,"emailNotification":false,"transcription":false,"__typename":"ChannelSettingsNode"},"error":null,"__typename":"ChannelSettingsPayload"}},"extensions":{"tracing":{"version":1,"startTime":"2022-01-25T05:52:26.527094Z","endTime":"2022-01-25T05:52:26.590565Z","duration":63471259,"execution":{"resolvers":[{"path":["updateGeneralSettings"],"parentType":"Mutation","fieldName":"updateGeneralSettings","returnType":"ChannelSettingsPayload!","startOffset":21521043,"duration":41234032}]}}}}

  NumberSettingsResponseData? data;

  UpdateNumberSettingResponse({this.data});

  @override
  UpdateNumberSettingResponse? fromMap(dynamic dynamic) {
    return UpdateNumberSettingResponse(
        data: dynamic["updateGeneralSettings"] != null
            ? NumberSettingsResponseData()
                .fromMap(dynamic["updateGeneralSettings"])
            : null);
  }

  Map<String, dynamic>? toMap(UpdateNumberSettingResponse? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object!.data != null) {
      data["updateGeneralSettings"] =
          NumberSettingsResponseData().toMap(object.data);
    }
    return data;
  }

  @override
  List<UpdateNumberSettingResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UpdateNumberSettingResponse> list =
        <UpdateNumberSettingResponse>[];

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
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<UpdateNumberSettingResponse>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as UpdateNumberSettingResponse)!);
        }
      }
    }
    return dynamicList;
  }
}
