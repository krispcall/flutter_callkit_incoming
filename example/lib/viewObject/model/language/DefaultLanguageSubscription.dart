import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/login/UserProfile.dart";
/*
 * *
 *  * Created by Kedar on 9/16/21 10:46 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 9/16/21 10:46 AM
 *
 */

class DefaultLanguageSubscription extends Object<DefaultLanguageSubscription> {
  String? event;
  UserProfileData? message;

  DefaultLanguageSubscription({this.event, this.message});

  @override
  DefaultLanguageSubscription? fromMap(dynamic dynamic) {
    return DefaultLanguageSubscription(
        message: dynamic["message"] != null
            ? UserProfileData().fromMap(dynamic["message"])
            : null,
        event: dynamic["event"] == null ? null : dynamic["event"] as String);
  }

  Map<String, dynamic>? toMap(DefaultLanguageSubscription? object) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (object != null) {
      data["message"] = UserProfileData().toMap(object.message!);
      data["event"] = object.event;
    }
    return data;
  }

  @override
  List<DefaultLanguageSubscription>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<DefaultLanguageSubscription> list =
        <DefaultLanguageSubscription>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          list.add(fromMap(dynamicData)!);
        }
      }
    }
    return list;
  }

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<DefaultLanguageSubscription>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as DefaultLanguageSubscription)!);
        }
      }
    }
    return dynamicList;
  }
}
