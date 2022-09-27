import "package:azlistview/azlistview.dart";
import "package:mvp/viewObject/ResponseData.dart";
import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/allContact/Tags.dart";
import "package:quiver/core.dart";

class Contacts extends MapObject<Contacts> implements ISuspensionBean {
  Contacts({
    this.id,
    this.name,
    this.country,
    this.company,
    this.number,
    this.email,
    this.profilePicture,
    this.blocked,
    // this.dndEnabled,
    // this.dndDuration,
    // this.dndEndtime,
    this.visibility,
    this.tags,
    this.notes,
    this.createdOn,
    this.address,
    this.dndInfo,
    this.cursor,
    this.sorting,
    this.check,
    this.workspaceId,
    // this.dndMissed,
  });

  String? id;
  String? name;
  String? country;
  String? company;
  String? number;
  String? email;
  String? profilePicture;
  bool? blocked;
  bool? visibility;
  List<Tags>? tags;
  List<Tags>? notes;
  String? createdOn;
  String? address;
  DndInfo? dndInfo;
  String? cursor;
  int? sorting;
  bool? check = false;
  String? tagIndex;
  String? namePinyin;
  String? workspaceId;

  @override
  bool operator ==(dynamic other) => other is Contacts && id! == other.id!;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String getPrimaryKey() {
    return "number";
  }

  @override
  Contacts? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Contacts(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        name:
            dynamicData["name"] == null ? null : dynamicData["name"] as String,
        country: dynamicData["country"] == null
            ? null
            : dynamicData["country"] as String,
        company: dynamicData["company"] == null
            ? null
            : dynamicData["company"] as String,
        number: dynamicData["number"] == null
            ? null
            : dynamicData["number"] as String,
        email: dynamicData["email"] == null
            ? null
            : dynamicData["email"] as String,
        profilePicture: dynamicData["profilePicture"] == null
            ? null
            : dynamicData["profilePicture"] as String,
        blocked: (dynamicData["blocked"] ?? false) as bool,
        tags: Tags().fromMapList(dynamicData["tags"] == null
            ? null
            : dynamicData["tags"] as List<dynamic>),
        notes: Tags().fromMapList(dynamicData["notes"] == null
            ? null
            : dynamicData["notes"] as List<dynamic>),
        createdOn: dynamicData["createdOn"] == null
            ? null
            : dynamicData["createdOn"] as String,
        address: dynamicData["address"] == null
            ? null
            : dynamicData["address"] as String,
        dndInfo: DndInfo().fromMap(dynamicData["dndInfo"]),
        cursor: dynamicData["cursor"] == null
            ? null
            : dynamicData["cursor"] as String,
        sorting: dynamicData["sorting"] == null
            ? null
            : dynamicData["sorting"] as int,
        workspaceId: dynamicData["workspaceId"] == null
            ? null
            : dynamicData["workspaceId"] as String,
        check:
            dynamicData["check"] == null ? null : dynamicData["check"] as bool,
        // dndMissed: false,
      );
      // Todo dnd missed in contact
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(Contacts? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["name"] = object.name;
      data["country"] = object.country;
      data["company"] = object.company;
      data["number"] = object.number;
      data["email"] = object.email;
      data["country"] = object.country;
      data["profilePicture"] = object.profilePicture;
      data["visibility"] = object.visibility;
      data["blocked"] = object.blocked;
      data["profilePicture"] = object.profilePicture;
      data["tags"] = Tags().toMapList(object.tags);
      data["notes"] = Tags().toMapList(object.notes);
      data["createdOn"] = object.createdOn;
      data["address"] = object.address;
      data["dndInfo"] = DndInfo().toMap(object.dndInfo);
      data["cursor"] = object.cursor;
      data["sorting"] = object.sorting;
      data["check"] = object.check;
      data["workspaceId"] = object.workspaceId;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Contacts> fromMapList(dynamic dynamicDataList) {
    final List<Contacts> basketList = <Contacts>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          basketList.add(fromMap(dynamicData)!);
        }
      }
    }
    return basketList;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Contacts>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Contacts data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }

  @override
  List<String>? getIdList(List<dynamic>? mapList) {
    final List<String> idList = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (messages != null) {
          idList.add(messages.id as String);
        }
      }
    }
    return idList;
  }

  @override
  List<String>? getIdByKeyValue(
      List<Contacts>? mapList, dynamic key, dynamic value) {
    final List<String> filterParamlist = <String>[];
    if (mapList != null) {
      for (final dynamic messages in mapList) {
        if (Contacts().toMap(messages as Contacts)!["$key"] == value) {
          filterParamlist.add(messages.id as String);
        }
      }
    }
    return filterParamlist;
  }

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  bool isShowSuspension = false;
}

//Delete Contacts
class DeleteContactResponse extends Object<DeleteContactResponse> {
/*  {
  "data": {
  "deleteContacts": {
  "status": 200,
  "error": null,
  "data": {
  "success": true
  }
  }
  }
  }*/

  DeleteContactResponse({
    this.data,
  });

  ResponseData? data;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  DeleteContactResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DeleteContactResponse(
        data: ResponseData().fromMap(dynamicData["deleteContacts"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(DeleteContactResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["deleteContacts"] = ResponseData().toMap(object.data);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DeleteContactResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<DeleteContactResponse> data = <DeleteContactResponse>[];

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
      List<DeleteContactResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DeleteContactResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

//Delete Contacts
class DndInfo extends Object<DndInfo> {
  bool dndEnabled;
  int? dndDuration;
  int? dndEndtime;

  DndInfo({
    this.dndEnabled = false,
    this.dndDuration,
    this.dndEndtime,
  });

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  DndInfo? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return DndInfo(
        dndEnabled: (dynamicData["dndEnabled"] ?? false) as bool,
        dndDuration: dynamicData["dndDuration"] == null
            ? null
            : dynamicData["dndDuration"] as int,
        dndEndtime: dynamicData["dndEndtime"] == null
            ? null
            : dynamicData["dndEndtime"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(DndInfo? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["dndEnabled"] = dndEnabled;
      data["dndDuration"] = dndDuration;
      data["dndEndtime"] = dndEndtime;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<DndInfo>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<DndInfo> data = <DndInfo>[];

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
  List<Map<String, dynamic>>? toMapList(List<DndInfo>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final DndInfo data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
