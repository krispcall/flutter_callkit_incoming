import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/numberSettings/NumberSettings.dart";

class WorkspaceChannel extends Object<WorkspaceChannel> {
  // {
  // "id": "5vdcVWZWV2MtEgHTE8M7dw",
  // "countryLogo": "/storage/flags/afg.svg",
  // "country": "7opfWxvyTNhWq9yArDRrEv",
  // "countryCode": "+93",
  // "number": "+14153048396",
  // "name": "Sabnam",
  // "dndEndtime": null,
  // "dndEnabled": false,
  // "dndRemainingTime": null,
  // "dndOn": "2021-05-31T06:04:51.737118+00:00",
  // "unseenMessageCount": 142
  // }

  WorkspaceChannel(
      {this.id,
      this.country,
      this.name,
      this.countryLogo,
      this.countryCode,
      this.number,
      this.call,
      this.sms,
      this.mms,
      this.dndEndTime,
      this.dndEnabled,
      this.dndRemainingTime,
      this.dndOn,
      this.dndDuration,
      this.unseenMessageCount,
      this.settings});

  String? id;
  String? country;
  String? name;
  String? countryLogo;
  String? countryCode;
  String? number;
  bool? call;
  bool? sms;
  bool? mms;
  int? dndEndTime;
  bool? dndEnabled;
  int? dndRemainingTime;
  String? dndOn;
  int? dndDuration;
  int? unseenMessageCount;
  NumberSettings? settings;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  WorkspaceChannel? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return WorkspaceChannel(
          id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
          country: dynamicData["country"] == null
              ? null
              : dynamicData["country"] as String,
          name: dynamicData["name"] == null
              ? null
              : dynamicData["name"] as String,
          countryLogo: dynamicData["countryLogo"] == null
              ? null
              : dynamicData["countryLogo"] as String,
          countryCode: dynamicData["countryCode"] == null
              ? null
              : dynamicData["countryCode"] as String,
          number: dynamicData["number"] == null
              ? null
              : dynamicData["number"] as String,
          call:
              dynamicData["call"] == null ? null : dynamicData["call"] as bool,
          sms: dynamicData["sms"] == null ? null : dynamicData["sms"] as bool,
          mms: dynamicData["mms"] == null ? null : dynamicData["mms"] as bool,
          dndEndTime: dynamicData["dndEndtime"] == null
              ? null
              : dynamicData["dndEndtime"] as int,
          dndEnabled: dynamicData["dndEnabled"] == null
              ? null
              : dynamicData["dndEnabled"] as bool,
          dndRemainingTime: dynamicData["dndRemainingTime"] == null
              ? null
              : dynamicData["dndRemainingTime"] as int,
          dndOn: dynamicData["dndOn"] == null
              ? null
              : dynamicData["dndOn"] as String,
          dndDuration: dynamicData["dndDuration"] == null
              ? null
              : dynamicData["dndDuration"] as int,
          unseenMessageCount: dynamicData["unseenMessageCount"] == null
              ? null
              : dynamicData["unseenMessageCount"] as int,
          settings: dynamicData["settings"] != null
              ? NumberSettings().fromMap(dynamicData["settings"])
              : null);
    } else {
      return null;
    }
  }

  WorkspaceChannel.fromJson(Map<String, dynamic> json) {
    id = json["id"] == null ? null : json["id"] as String;
    country = json["country"] == null ? null : json["country"] as String;
    name = json["name"] == null ? null : json["name"] as String;
    countryLogo =
        json["countryLogo"] == null ? null : json["countryLogo"] as String;
    countryCode =
        json["countryCode"] == null ? null : json["countryCode"] as String;
    number = json["number"] == null ? null : json["number"] as String;
    call = json["call"] == null ? null : json["call"] as bool;
    sms = json["sms"] == null ? null : json["sms"] as bool;
    mms = json["mms"] == null ? null : json["mms"] as bool;
    dndEndTime = json["dndEndtime"] == null ? null : json["dndEndtime"] as int;
    dndEnabled = json["dndEnabled"] == null ? null : json["dndEnabled"] as bool;
    dndRemainingTime = json["dndRemainingTime"] == null
        ? null
        : json["dndRemainingTime"] as int;
    dndDuration =
        json["dndDuration"] == null ? null : json["dndDuration"] as int;
    dndOn = json["dndOn"] == null ? null : json["dndOn"] as String;
    unseenMessageCount = json["unseenMessageCount"] == null
        ? null
        : json["unseenMessageCount"] as int;
    settings = json["settings"] == null
        ? null
        : json["settings"] != null
            ? NumberSettings().fromMap(json["settings"])
            : null;
  }

  @override
  Map<String, dynamic>? toMap(WorkspaceChannel? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["country"] = object.country;
      data["name"] = object.name;
      data["countryLogo"] = object.countryLogo;
      data["countryCode"] = object.countryCode;
      data["number"] = object.number;
      data["call"] = object.call;
      data["sms"] = object.sms;
      data["mms"] = object.mms;
      data["dndEndtime"] = object.dndEndTime;
      data["dndEnabled"] = object.dndEnabled;
      data["dndRemainingTime"] = object.dndRemainingTime;
      data["dndDuration"] = object.dndDuration;
      data["dndOn"] = object.dndOn;
      data["unseenMessageCount"] = object.unseenMessageCount;
      data["settings"] = NumberSettings().toMap(object.settings);
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["country"] = country;
    data["name"] = name;
    data["countryLogo"] = countryLogo;
    data["countryCode"] = countryCode;
    data["number"] = number;
    data["call"] = call;
    data["sms"] = sms;
    data["mms"] = mms;
    data["dndEndtime"] = dndEndTime;
    data["dndEnabled"] = dndEnabled;
    data["dndRemainingTime"] = dndRemainingTime;
    data["dndDuration"] = dndDuration;
    data["dndOn"] = dndOn;
    data["unseenMessageCount"] = unseenMessageCount;
    data["settings"] = NumberSettings().toMap(settings);
    return data;
  }

  @override
  List<WorkspaceChannel>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<WorkspaceChannel> userData = <WorkspaceChannel>[];
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
  List<Map<String, dynamic>>? toMapList(List<WorkspaceChannel>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final WorkspaceChannel data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
