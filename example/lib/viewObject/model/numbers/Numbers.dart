import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/numbers/Agents.dart";

class Numbers extends Object<Numbers> {
  String? id;
  String? name;
  String? number;
  String? country;
  String? countryLogo;
  String? countryCode;
  List<Agents>? agents;

  Numbers({
    this.id,
    this.name,
    this.number,
    this.country,
    this.countryLogo,
    this.countryCode,
    this.agents,
  });

  @override
  Numbers? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Numbers(
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        number: dynamicData["number"] == null
            ? null
            : dynamicData["number"] as String,
        country: dynamicData["country"] == null
            ? null
            : dynamicData["country"] as String,
        countryLogo: dynamicData["countryLogo"] == null
            ? null
            : dynamicData["countryLogo"] as String,
        countryCode: dynamicData["countryCode"] == null
            ? null
            : dynamicData["countryCode"] as String,
        agents: Agents().fromMapList(dynamicData["agents"] == null
            ? null
            : dynamicData["agents"] as List<dynamic>),
      );
    } else {
      return null;
    }
  }

  @override
  List<Numbers>? fromMapList(List? dynamicDataList) {
    final List<Numbers> data = <Numbers>[];

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
  String? getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(Numbers? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["name"] = object.name;
      data["number"] = object.number;
      data["country"] = object.country;
      data["countryLogo"] = object.countryLogo;
      data["countryCode"] = object.countryCode;
      data["agents"] = Agents().toMapList(object.agents);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Numbers>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Numbers data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
