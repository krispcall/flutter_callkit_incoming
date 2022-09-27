import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/workspace/plan/PlanDetail.dart";

class PlanOverviewData extends Object<PlanOverviewData> {
  PlanOverviewData({
    this.cardInfo,
    this.remainingDays,
    this.subscriptionActive,
    this.trialPeriod,
    this.planDetail,
    this.currentCredit,
  });

  bool? cardInfo;
  int? remainingDays;
  String? subscriptionActive;
  String? trialPeriod;
  PlanDetail? planDetail;
  double? currentCredit;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  PlanOverviewData? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return PlanOverviewData(
        cardInfo: dynamicData["cardInfo"] == null
            ? null
            : dynamicData["cardInfo"] as bool,
        remainingDays: dynamicData["remainingDays"] == null
            ? null
            : dynamicData["remainingDays"] as int,
        subscriptionActive: dynamicData["subscriptionActive"] == null
            ? null
            : dynamicData["subscriptionActive"] as String,
        trialPeriod: dynamicData["trialPeriod"] == null
            ? null
            : dynamicData["trialPeriod"] as String,
        currentCredit: dynamicData["currentCredit"] == null
            ? null
            : dynamicData["currentCredit"] as double,
        planDetail: PlanDetail().fromMap(dynamicData["planDetail"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(PlanOverviewData? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["cardInfo"] = object.cardInfo;
      data["remainingDays"] = object.remainingDays;
      data["subscriptionActive"] = object.subscriptionActive;
      data["trialPeriod"] = object.trialPeriod;
      data["currentCredit"] = object.currentCredit;
      data["planDetail"] = PlanDetail().toMap(object.planDetail);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<PlanOverviewData>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<PlanOverviewData> userData = <PlanOverviewData>[];
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
  List<Map<String, dynamic>>? toMapList(List<PlanOverviewData>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final PlanOverviewData data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
