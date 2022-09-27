import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";

class UploadPhoneContactResponse extends Object<UploadPhoneContactResponse> {
  UploadBulkContacts? uploadBulkContacts;

  UploadPhoneContactResponse({this.uploadBulkContacts});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  UploadPhoneContactResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UploadPhoneContactResponse(
        uploadBulkContacts:
            UploadBulkContacts().fromMap(dynamicData["uploadBulkContacts"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UploadPhoneContactResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["uploadBulkContacts"] =
          UploadBulkContacts().toMap(object.uploadBulkContacts!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UploadPhoneContactResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<UploadPhoneContactResponse> data =
        <UploadPhoneContactResponse>[];

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
  List<Map<String, dynamic>>? toMapList(
      List<UploadPhoneContactResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UploadPhoneContactResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class UploadBulkContacts extends Object<UploadBulkContacts> {
  int? status;
  ResponseError? error;
  ContactUploadResponseData? data;

  UploadBulkContacts({this.status, this.error, this.data});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  UploadBulkContacts? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return UploadBulkContacts(
        status: dynamicData["status"] as int,
        error: ResponseError().fromMap(dynamicData["error"]),
        data: ContactUploadResponseData().fromMap(dynamicData["data"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(UploadBulkContacts? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["error"] = ResponseError().toMap(object.error!);
      data["data"] = ContactUploadResponseData().toMap(object.data!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<UploadBulkContacts>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<UploadBulkContacts> data = <UploadBulkContacts>[];

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
  List<Map<String, dynamic>>? toMapList(List<UploadBulkContacts>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final UploadBulkContacts data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  UploadBulkContacts.fromJson(Map<String, dynamic> json) {
    status = json["status"] as int;
    error =
        json["error"] != null ? ResponseError().fromMap(json["error"]) : null;
    data = json["data"] != null
        ? ContactUploadResponseData.fromJson(
            json["data"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["status"] = status;
    if (error != null) {
      data["error"] = error;
    }
    if (this.data != null) {
      data["data"] = this.data!.toJson();
    }
    return data;
  }
}

class ContactUploadResponseData extends Object<ContactUploadResponseData> {
  int? totalRecords;
  int? savedRecords;

  ContactUploadResponseData({this.totalRecords, this.savedRecords});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ContactUploadResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ContactUploadResponseData(
        totalRecords: dynamicData["totalRecords"] as int,
        savedRecords: dynamicData["savedRecords"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ContactUploadResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["totalRecords"] = object.totalRecords;
      data["savedRecords"] = object.savedRecords;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ContactUploadResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ContactUploadResponseData> data = <ContactUploadResponseData>[];

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
  List<Map<String, dynamic>>? toMapList(
      List<ContactUploadResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ContactUploadResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  ContactUploadResponseData.fromJson(Map<String, dynamic> json) {
    totalRecords =
        json["totalRecords"] == null ? null : json["totalRecords"] as int;
    savedRecords =
        json["savedRecords"] == null ? null : json["savedRecords"] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["totalRecords"] = totalRecords;
    data["savedRecords"] = savedRecords;
    return data;
  }
}

class Extensions {
  Tracing? tracing;

  Extensions({this.tracing});

  Extensions.fromJson(Map<String, dynamic> json) {
    tracing = json["tracing"] != null
        ? Tracing.fromJson(json["tracing"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tracing != null) {
      data["tracing"] = tracing!.toJson();
    }
    return data;
  }
}

class Tracing {
  int? version;
  String? startTime;
  String? endTime;
  int? duration;
  Execution? execution;

  Tracing(
      {this.version,
      this.startTime,
      this.endTime,
      this.duration,
      this.execution});

  Tracing.fromJson(Map<String, dynamic> json) {
    version = json["version"] == null ? null : json["version"] as int;
    startTime = json["startTime"] == null ? null : json["startTime"] as String;
    endTime = json["endTime"] == null ? null : json["endTime"] as String;
    duration = json["duration"] == null ? null : json["duration"] as int;
    execution = json["execution"] != null
        ? Execution.fromJson(json["execution"] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["version"] = version;
    data["startTime"] = startTime;
    data["endTime"] = endTime;
    data["duration"] = duration;
    if (execution != null) {
      data["execution"] = execution!.toJson();
    }
    return data;
  }
}

class Execution {
  List<Resolvers>? resolvers;

  Execution({this.resolvers});

  Execution.fromJson(Map<String, dynamic> json) {
    if (json["resolvers"] != null) {
      resolvers = [];
      json["resolvers"].forEach((v) {
        resolvers!.add(Resolvers.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (resolvers != null) {
      data["resolvers"] = resolvers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Resolvers {
  List<String>? path;
  String? parentType;
  String? fieldName;
  String? returnType;
  int? startOffset;
  int? duration;

  Resolvers(
      {this.path,
      this.parentType,
      this.fieldName,
      this.returnType,
      this.startOffset,
      this.duration});

  Resolvers.fromJson(Map<String, dynamic> json) {
    path = json["path"] == null ? null : json["path"] as List<String>;
    parentType =
        json["parentType"] == null ? null : json["parentType"] as String;
    fieldName = json["fieldName"] == null ? null : json["fieldName"] as String;
    returnType =
        json["returnType"] == null ? null : json["returnType"] as String;
    startOffset =
        json["startOffset"] == null ? null : json["startOffset"] as int;
    duration = json["duration"] == null ? null : json["duration"] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["path"] = path;
    data["parentType"] = parentType;
    data["fieldName"] = fieldName;
    data["returnType"] = returnType;
    data["startOffset"] = startOffset;
    data["duration"] = duration;
    return data;
  }
}
