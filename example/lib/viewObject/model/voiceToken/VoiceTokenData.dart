import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/voiceToken/VoiceToken.dart";

class VoiceTokenData extends Object<VoiceTokenData> {
  VoiceTokenData({
    this.status,
    this.voiceToken,
    this.error,
  });

  int? status;
  VoiceToken? voiceToken;
  ResponseError? error;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  VoiceTokenData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return VoiceTokenData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        voiceToken: VoiceToken().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(VoiceTokenData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = VoiceToken().toMap(object.voiceToken);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<VoiceTokenData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<VoiceTokenData> login = <VoiceTokenData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<VoiceTokenData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final VoiceTokenData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
