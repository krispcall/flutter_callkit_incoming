/*
 * *
 *  * Created by Kedar on 7/14/21 1:09 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/14/21 1:09 PM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/error/ResponseError.dart";
import "package:mvp/viewObject/model/recording/RecordCall.dart";

class CallRecordResponse extends Object<CallRecordResponse> {
  CallRecordResponse({
    this.callRecord,
  });

  CallRecordResponseData? callRecord;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  CallRecordResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallRecordResponse(
        callRecord:
            CallRecordResponseData().fromMap(dynamicData["callRecording"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CallRecordResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["callRecording"] =
          CallRecordResponseData().toMap(object.callRecord!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallRecordResponse>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<CallRecordResponse>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}

class CallRecordResponseData extends Object<CallRecordResponseData> {
  CallRecordResponseData({
    this.status,
    this.recordCall,
    this.error,
  });

  int? status;
  RecordCall? recordCall;
  ResponseError? error;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  CallRecordResponseData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return CallRecordResponseData(
        status: dynamicData["status"] as int,
        recordCall: RecordCall().fromMap(dynamicData["data"]),
        error: ResponseError().fromMap(dynamicData["error"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(CallRecordResponseData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["status"] = object.status;
      data["data"] = RecordCall().toMap(object.recordCall!);
      data["error"] = ResponseError().toMap(object.error);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<CallRecordResponseData>? fromMapList(List? dynamicDataList) {
    // TODO: implement fromMapList
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<CallRecordResponseData>? objectList) {
    // TODO: implement toMapList
    throw UnimplementedError();
  }
}
