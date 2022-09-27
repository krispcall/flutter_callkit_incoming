import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/voiceToken/VoiceTokenData.dart";

class VoiceTokenResponse extends Object<VoiceTokenResponse> {
  VoiceTokenResponse({
    this.voiceTokenData,
  });

  VoiceTokenData? voiceTokenData;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  VoiceTokenResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return VoiceTokenResponse(
        voiceTokenData: VoiceTokenData().fromMap(dynamicData["getVoiceToken"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["getVoiceToken"] =
          VoiceTokenData().toMap(object.voiceTokenData as VoiceTokenData);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<VoiceTokenResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<VoiceTokenResponse> voiceTokenResponseList =
        <VoiceTokenResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic json in dynamicDataList) {
        if (json != null) {
          voiceTokenResponseList.add(fromMap(json)!);
        }
      }
    }
    return voiceTokenResponseList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<dynamic> dynamicList = <dynamic>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
    }

    return dynamicList as List<Map<String, dynamic>>;
  }
}
