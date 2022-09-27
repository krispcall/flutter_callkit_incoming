import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/numberSettings/NumberAbilities.dart";

class NumberSettings extends Object<NumberSettings> {
  final String? id;
  final String? name;
  final bool? autoRecordCalls;
  final bool? internationalCallAndMessages;
  final bool? emailNotification;
  final bool? transcription;
  final NumberAbilities? numberAbilities;

  NumberSettings({
    this.name,
    this.autoRecordCalls = false,
    this.internationalCallAndMessages = false,
    this.emailNotification = false,
    this.transcription,
    this.id,
    this.numberAbilities,
  });

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  NumberSettings? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NumberSettings(
          name: dynamicData["name"] == null
              ? null
              : dynamicData["name"] as String,
          autoRecordCalls: dynamicData["autoRecordCalls"] == null
              ? null
              : dynamicData["autoRecordCalls"] as bool,
          internationalCallAndMessages:
              dynamicData["internationalCallAndMessages"] == null
                  ? null
                  : dynamicData["internationalCallAndMessages"] as bool,
          emailNotification: dynamicData["emailNotification"] == null
              ? null
              : dynamicData["emailNotification"] as bool,
          transcription: dynamicData["transcription"] == null
              ? null
              : dynamicData["transcription"] as bool,
          id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
          numberAbilities: NumberAbilities().fromMap(dynamicData["abilities"]));
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NumberSettings? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["name"] = object.name;
      data["autoRecordCalls"] = object.autoRecordCalls;
      data["internationalCallAndMessages"] =
          object.internationalCallAndMessages;
      data["emailNotification"] = object.emailNotification;
      data["transcription"] = object.transcription;
      data["id"] = object.id;
      data["abilities"] = NumberAbilities().toMap(object.numberAbilities);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NumberSettings>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NumberSettings> listMessages = <NumberSettings>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as NumberSettings)!);
        }
      }
    }
    return dynamicList;
  }
}
