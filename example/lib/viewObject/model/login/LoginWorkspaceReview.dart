import "package:mvp/viewObject/common/Object.dart";

class LoginWorkspaceReview extends Object<LoginWorkspaceReview> {
  LoginWorkspaceReview({
    this.reviewStatus,
    this.riskScore,
  });

  String? reviewStatus;
  int? riskScore;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  LoginWorkspaceReview? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginWorkspaceReview(
        reviewStatus: dynamicData["review_status"] == null
            ? null
            : dynamicData["review_status"] as String,
        riskScore: dynamicData["risk_score"] == null
            ? null
            : dynamicData["risk_score"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginWorkspaceReview? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["review_status"] = object.reviewStatus;
      data["risk_score"] = object.riskScore;
      return data;
    } else {
      return null;
    }
  }

  LoginWorkspaceReview.fromJson(Map<String, dynamic> dynamicData) {
    reviewStatus = dynamicData["review_status"] == null
        ? null
        : dynamicData["review_status"] as String;
    riskScore = dynamicData["risk_score"] == null
        ? null
        : dynamicData["risk_score"] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["review_status"] = reviewStatus;
    data["risk_score"] = riskScore;
    return data;
  }

  @override
  List<LoginWorkspaceReview>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginWorkspaceReview> workSpace = <LoginWorkspaceReview>[];
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
  List<Map<String, dynamic>>? toMapList(
      List<LoginWorkspaceReview>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginWorkspaceReview data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
