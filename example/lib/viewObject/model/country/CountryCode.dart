import "dart:convert";

import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class CountryCode extends Object<CountryCode> {
  CountryCode({
    this.id,
    this.name,
    this.flagUri,
    this.code,
    this.dialCode,
    this.length,
  });

  String? id;
  String? name;
  String? flagUri;
  String? code;
  String? dialCode;
  String? length;

  @override
  bool operator ==(dynamic other) => other is CountryCode && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return id!;
  }

  @override
  CountryCode? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CountryCode(
        id: dynamicData["uid"] == null ? null : dynamicData["uid"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        flagUri: dynamicData["flagUrl"] == null
            ? null
            : dynamicData["flagUrl"] as String,
        code: dynamicData["alphaTwoCode"] == null
            ? null
            : dynamicData["alphaTwoCode"] as String,
        dialCode: dynamicData["dialingCode"] == null
            ? null
            : dynamicData["dialingCode"] as String,
        length: dynamicData["length"] == null
            ? null
            : dynamicData["length"] as String,
      );
    } else {
      return null;
    }
  }

  CountryCode.fromJson(Map<String, dynamic> dynamicData) {
    id = dynamicData["uid"] == null ? null : dynamicData["uid"] as String;
    name = dynamicData["name"] == null ? null : dynamicData["name"] as String;
    flagUri = dynamicData["flagUrl"] == null
        ? null
        : dynamicData["flagUrl"] as String;
    code = dynamicData["alphaTwoCode"] == null
        ? null
        : dynamicData["alphaTwoCode"] as String;
    dialCode = dynamicData["dialingCode"] == null
        ? null
        : dynamicData["dialingCode"] as String;
    length =
        dynamicData["length"] == null ? null : dynamicData["length"] as String;
  }

  CountryCode? fromJson(dynamic dynamicData) {
    if (dynamicData != null) {
      return CountryCode(
        id: dynamicData["uid"] == null ? null : dynamicData["uid"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        flagUri: dynamicData["flagUrl"] == null
            ? null
            : dynamicData["flagUrl"] as String,
        code: dynamicData["alphaTwoCode"] == null
            ? null
            : dynamicData["alphaTwoCode"] as String,
        dialCode: dynamicData["dialingCode"] == null
            ? null
            : dynamicData["dialingCode"] as String,
        length: dynamicData["length"] == null
            ? null
            : dynamicData["length"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CountryCode? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["uid"] = object.id;
      data["name"] = object.name;
      data["flagUrl"] = object.flagUri;
      data["alphaTwoCode"] = object.code;
      data["dialingCode"] = object.dialCode;
      data["length"] = object.length;
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["uid"] = id;
    data["name"] = name;
    data["flagUrl"] = flagUri;
    data["alphaTwoCode"] = code;
    data["dialingCode"] = dialCode;
    data["length"] = length;
    return data;
  }

  @override
  List<CountryCode>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CountryCode> commentList = <CountryCode>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          commentList.add(fromMap(dynamicData)!);
        }
      }
    }
    return commentList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<CountryCode>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CountryCode data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }
}

CountryCode countryResponseFromJson(String str) =>
    CountryCode.fromJson(json.decode(str) as Map<String, dynamic>);

List<CountryCode> countryCodeFromJson(String str) => List<CountryCode>.from(
    json.decode(str).map((x) => CountryCode.fromJson(x as Map<String, dynamic>))
        as Iterable<dynamic>);

String countryCodeToJson(List<CountryCode> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
