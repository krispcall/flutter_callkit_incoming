/*
 * *
 *  * Created by Kedar on 8/2/21 11:01 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 11:01 AM
 *  
 */

/*
 * *
 *  * Created by Kedar on 8/2/21 10:56 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 8/2/21 10:56 AM
 *  
 */
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/overview/Card.dart";
import "package:mvp/viewObject/model/overview/Credit.dart";
import "package:mvp/viewObject/model/overview/Plan.dart";

class OverViewData extends Object<OverViewData> {
  OverViewData({
    this.customerId,
    this.currentPeriodEnd,
    this.hideKrispcallBranding,
    this.dueAmount,
    this.subscriptionActive,
    this.card,
    this.credit,
    this.plan,
  });

  String? customerId;
  String? currentPeriodEnd;
  bool? hideKrispcallBranding;
  double? dueAmount;
  String? subscriptionActive;
  Card? card;
  Credit? credit;
  Plan? plan;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  OverViewData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return OverViewData(
        customerId: dynamicData["customerId"] == null
            ? null
            : dynamicData["customerId"] as String,
        currentPeriodEnd: dynamicData["currentPeriodEnd"] == null
            ? null
            : dynamicData["currentPeriodEnd"] as String,
        hideKrispcallBranding: dynamicData["hideKrispcallBranding"] == null
            ? null
            : dynamicData["hideKrispcallBranding"] as bool,
        dueAmount: dynamicData["dueAmount"] == null
            ? null
            : dynamicData["dueAmount"] as double,
        subscriptionActive: dynamicData["subscriptionActive"] == null
            ? null
            : dynamicData["subscriptionActive"] as String,
        card: Card().fromMap(dynamicData["card"]),
        credit: Credit().fromMap(dynamicData["credit"]),
        plan: Plan().fromMap(dynamicData["plan"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(OverViewData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["customerId"] = object.customerId;
      data["currentPeriodEnd"] = object.currentPeriodEnd;
      data["hideKrispcallBranding"] = object.hideKrispcallBranding;
      data["dueAmount"] = object.dueAmount;
      data["subscriptionActive"] = object.subscriptionActive;
      data["card"] = Card().toMap(object.card);
      data["credit"] = Credit().toMap(object.credit);
      data["plan"] = Plan().toMap(object.plan!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<OverViewData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<OverViewData> workSpace = <OverViewData>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          workSpace.add(fromMap(dynamicData)!);
        }
      }
    }
    return workSpace;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<OverViewData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final OverViewData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
