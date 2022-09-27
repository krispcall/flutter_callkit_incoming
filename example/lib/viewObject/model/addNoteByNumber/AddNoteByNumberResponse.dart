/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/addNoteByNumber/AddNoteByNumberResponseData.dart";

class AddNoteByNumberResponse extends Object<AddNoteByNumberResponse> {
  AddNoteByNumberResponse({
    this.addNoteByNumberResponseData,
  });

  AddNoteByNumberResponseData? addNoteByNumberResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  AddNoteByNumberResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return AddNoteByNumberResponse(
        addNoteByNumberResponseData: AddNoteByNumberResponseData()
            .fromMap(dynamicData["addNoteByContact"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(AddNoteByNumberResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["addNoteByContact"] = AddNoteByNumberResponseData()
          .toMap(object.addNoteByNumberResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<AddNoteByNumberResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<AddNoteByNumberResponse> login = <AddNoteByNumberResponse>[];

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
  List<Map<String, dynamic>>? toMapList(
      List<AddNoteByNumberResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final AddNoteByNumberResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
