import "package:mvp/viewObject/common/Object.dart";
import "package:quiver/core.dart";

class NotificationMessage extends Object<NotificationMessage> {
  NotificationMessage({
    this.data,
  });

  Data? data;

  @override
  bool operator ==(dynamic other) =>
      other is NotificationMessage && data!.id == other.data!.id;

  @override
  int get hashCode => hash2(data!.id.hashCode, data!.id.hashCode);

  @override
  String? getPrimaryKey() {
    return "";
  }

  NotificationMessage.fromJson(Map<String, dynamic> json) {
    data = json["data"] != null
        ? Data.fromJson(json["data"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data["data"] = this.data!.toJson();
    }
    return data;
  }

  @override
  NotificationMessage? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return NotificationMessage(
        data: Data().fromMap(dynamicData["data"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(NotificationMessage? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["data"] = Data().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<NotificationMessage>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<NotificationMessage> subCategoryList = <NotificationMessage>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<NotificationMessage>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final NotificationMessage data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }
}

class Notification extends Object<Notification> {
  String? body;
  String? title;

  Notification({this.body, this.title});

  Notification.fromJson(Map<String, dynamic> json) {
    body = json["body"] as String;
    title = json["title"] as String;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["body"] = body;
    data["title"] = title;
    return data;
  }

  @override
  Notification? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Notification(
        body: dynamicData["body"] as String,
        title: dynamicData["title"] as String,
      );
    } else {
      return null;
    }
  }

  @override
  List<Notification>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Notification> subCategoryList = <Notification>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Notification>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Notification data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  Map<String, dynamic>? toMap(Notification? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["body"] = object.body;
      data["title"] = object.title;
      return data;
    } else {
      return null;
    }
  }
}

class Data extends Object<Data> {
  int? id;
  String? twiCallSid;
  String? twiTo;
  String? twiFrom;
  CustomParameters? customParameters;
  ChannelInfo? channelInfo;

  Data(
      {this.id,
      this.twiCallSid,
      this.twiTo,
      this.twiFrom,
      this.customParameters,
      this.channelInfo});

  Data.fromJson(Map<String, dynamic> json) {
    id = 1;
    twiCallSid = json["twi_call_sid"].toString().trim();
    twiTo = json["twi_to"].toString().trim();
    twiFrom = json["twi_from"] as String;
    customParameters = json["customParameters"] != null
        ? CustomParameters.fromJson(
            json["customParameters"] as Map<String, dynamic>)
        : null;
    channelInfo = json["channelInfo"] != null
        ? ChannelInfo.fromJson(json["channelInfo"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["twi_call_sid"] = twiCallSid;
    data["twi_to"] = twiTo;
    data["twi_from"] = twiFrom;
    if (customParameters != null) {
      data["customParameters"] = customParameters!.toJson();
    }
    if (channelInfo != null) {
      data["channelInfo"] = channelInfo!.toJson();
    }
    return data;
  }

  @override
  Data? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Data(
        id: 1,
        twiCallSid: dynamicData["twi_call_sid"] as String,
        twiTo: dynamicData["twi_to"] as String,
        twiFrom: dynamicData["twi_from"] as String,
        customParameters:
            CustomParameters().fromMap(dynamicData["customParameters"]),
        channelInfo: ChannelInfo().fromMap(dynamicData["channelInfo"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Data? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = 1;
      data["twi_call_sid"] = object.twiCallSid;
      data["twi_to"] = object.twiTo;
      data["twi_from"] = object.twiFrom;
      data["customParameters"] =
          CustomParameters().toMap(object.customParameters);
      data["channelInfo"] = ChannelInfo().toMap(object.channelInfo);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Data>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<Data> subCategoryList = <Data>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Data>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Data data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}

class CustomParameters extends Object<CustomParameters> {
  String? conversationSid;

  // String afterHold;
  bool? afterTransfer;
  String? from;
  String? contactNumber;
  String? contactName;
  String? channelSid;

  CustomParameters({
    this.conversationSid,
    // this.afterHold,
    this.afterTransfer,
    this.from,
    this.contactNumber,
    this.contactName,
    this.channelSid,
  });

  CustomParameters.fromJson(Map<String, dynamic> json) {
    conversationSid = json["conversation_sid"].toString().trim();
    // afterHold = json["after_hold"] as String;
    afterTransfer =
        json["after_transfer"].toString().trim().toUpperCase() == "TRUE"
            ? true
            : false;
    from = json["from"].toString().trim();
    contactNumber = json["contact_number"].toString().trim();
    contactName = json["contact_name"].toString().trim();
    channelSid = json["channel_sid"].toString().trim();
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["conversation_sid"] = conversationSid;
    // data["after_hold"] = afterHold;
    data["after_transfer"] = afterTransfer;
    data["from"] = from;
    data["contact_number"] = contactNumber;
    data["contact_name"] = contactName;
    data["channel_sid"] = channelSid;
    return data;
  }

  @override
  CustomParameters? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CustomParameters(
        conversationSid: dynamicData["conversation_sid"].toString().trim(),
        // afterHold: dynamicData["after_hold"] as String,
        afterTransfer:
            dynamicData["after_transfer"].toString().trim().toUpperCase() ==
                    "TRUE"
                ? true
                : false,
        from: dynamicData["from"].toString().trim(),
        contactNumber: dynamicData["contact_number"].toString().trim(),
        contactName: dynamicData["contact_name"].toString().trim(),
        channelSid: dynamicData["channel_sid"].toString().trim(),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CustomParameters? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["conversation_sid"] = object.conversationSid;
      // data["after_hold"] = object.afterHold;
      data["after_transfer"] = object.afterTransfer;
      data["from"] = object.from;
      data["contact_number"] = object.contactNumber;
      data["contact_name"] = object.contactName;
      data["channel_sid"] = object.channelSid;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CustomParameters>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<CustomParameters> subCategoryList = <CustomParameters>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<CustomParameters>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final CustomParameters data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}

class ChannelInfo extends Object<ChannelInfo> {
  String? number;
  String? country;
  String? countryCode;
  String? name;
  String? id;
  String? numberSid;
  String? countryLogo;

  ChannelInfo({
    this.number,
    this.country,
    this.countryCode,
    this.name,
    this.id,
    this.numberSid,
    this.countryLogo,
  });

  ChannelInfo.fromJson(Map<String, dynamic> json) {
    number = json["number"].toString().trim();
    country = json["country"].toString().trim();
    countryCode = json["country_code"].toString().trim();
    name = json["name"].toString().trim();
    id = json["id"].toString().trim();
    numberSid = json["number_sid"].toString().trim();
    countryLogo = json["country_logo"].toString().trim();
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["number"] = number;
    data["country"] = country;
    data["country_code"] = countryCode;
    data["name"] = name;
    data["id"] = id;
    data["number_sid"] = numberSid;
    data["country_logo"] = countryLogo;
    return data;
  }

  @override
  ChannelInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ChannelInfo(
        number: dynamicData["number"].toString().trim(),
        country: dynamicData["country"].toString().trim(),
        countryCode: dynamicData["country_code"].toString().trim(),
        name: dynamicData["name"].toString().trim(),
        id: dynamicData["id"].toString().trim(),
        numberSid: dynamicData["number_sid"].toString().trim(),
        countryLogo: dynamicData["country_logo"].toString().trim(),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ChannelInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["number"] = object.number;
      data["country"] = object.country;
      data["country_code"] = object.countryCode;
      data["name"] = object.name;
      data["id"] = object.id;
      data["number_sid"] = object.numberSid;
      data["country_logo"] = object.countryLogo;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ChannelInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ChannelInfo> subCategoryList = <ChannelInfo>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          subCategoryList.add(fromMap(dynamicData)!);
        }
      }
    }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<ChannelInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ChannelInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }

    return mapList;
  }

  @override
  String getPrimaryKey() {
    return "";
  }
}
