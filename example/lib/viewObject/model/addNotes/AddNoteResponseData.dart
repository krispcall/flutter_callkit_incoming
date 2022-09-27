import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/addNotes/NoteTitle.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
/*
 * *
 *  * Created by Kedar on 7/13/21 8:40 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 8:40 AM
 *  
 */

class AddNoteResponseData extends Object<AddNoteResponseData> {
  AddNoteResponseData({
    this.status,
    this.data,
    this.error,
  });

  int? status;
  NoteTitle? data;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddNoteResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddNoteResponseData(
        status:
            dynamicData["status"] == null ? null : dynamicData["status"] as int,
        data: NoteTitle().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddNoteResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = NoteTitle().toMap(object.data!);
      data["error"] = ResponseError().toMap(object.error!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddNoteResponseData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddNoteResponseData> login = <AddNoteResponseData>[];

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
  List<Map<String, dynamic>>? toMapList(List<AddNoteResponseData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddNoteResponseData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
