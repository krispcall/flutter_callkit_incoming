import "package:mvp/viewObject/common/Object.dart";

class NumberAbilities extends Object<NumberAbilities> {
  final bool? call;
  final bool? sms;
  final bool? mms;

  NumberAbilities({
    this.call = false,
    this.sms = false,
    this.mms = false,
  });

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  NumberAbilities? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NumberAbilities(
        call: dynamicData["call"] == null ? null : dynamicData["call"] as bool,
        sms: dynamicData["sms"] == null ? null : dynamicData["sms"] as bool,
        mms: dynamicData["mms"] == null ? null : dynamicData["mms"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NumberAbilities? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["call"] = object.call;
      data["sms"] = object.sms;
      data["mms"] = object.mms;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NumberAbilities>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NumberAbilities> listMessages = <NumberAbilities>[];

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
          dynamicList.add(toMap(data as NumberAbilities)!);
        }
      }
    }
    return dynamicList;
  }
}
