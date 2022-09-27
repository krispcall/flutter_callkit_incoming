import "package:mvp/viewObject/common/Object.dart";
import 'package:mvp/viewObject/model/login/LoginWorkspaceReview.dart';
import "package:mvp/viewObject/model/workspace/plan/WorkSpacePlan.dart";
import "package:mvp/viewObject/model/workspace/role/LoginRole.dart";
import "package:quiver/core.dart";

class LoginWorkspace extends Object<LoginWorkspace> {
  LoginWorkspace({
    this.id,
    this.title,
    this.notification,
    this.photo,
    this.memberId,
    this.status,
    this.plan,
    this.loginMemberRole,
    this.loginWorkspaceReview,
  });

  String? id;
  String? title;
  bool? notification;
  String? photo;
  String? memberId;
  String? status;
  PlanOverviewData? plan;
  LoginRole? loginMemberRole;
  LoginWorkspaceReview? loginWorkspaceReview;

  @override
  bool operator ==(dynamic other) => other is LoginWorkspace && id == other.id;

  @override
  int get hashCode {
    return hash2(id.hashCode, id.hashCode);
  }

  @override
  String? getPrimaryKey() {
    return id!;
  }

  @override
  LoginWorkspace? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return LoginWorkspace(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        title: dynamicData["title"] == null
            ? null
            : dynamicData["title"] as String,
        notification: dynamicData["notification"] == null
            ? true
            : dynamicData["notification"] as bool,
        photo: dynamicData["photo"] == null
            ? null
            : dynamicData["photo"] as String,
        memberId: dynamicData["memberId"] == null
            ? null
            : dynamicData["memberId"] as String,
        status: dynamicData["status"] == null
            ? null
            : dynamicData["status"] as String,
        plan: dynamicData["plan"] == null
            ? null
            : PlanOverviewData().fromMap(dynamicData["plan"]),
        loginMemberRole: dynamicData["loginMemberRole"] == null
            ? null
            : LoginRole().fromMap(dynamicData["loginMemberRole"]),
        loginWorkspaceReview: dynamicData["review"] == null
            ? null
            : LoginWorkspaceReview().fromMap(dynamicData["review"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(LoginWorkspace? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["title"] = object.title;
      data["notification"] = object.notification;
      data["photo"] = object.photo;
      data["memberId"] = object.memberId;
      data["status"] = object.status;
      data["plan"] = PlanOverviewData().toMap(object.plan);
      data["loginMemberRole"] = LoginRole().toMap(object.loginMemberRole);
      data["review"] =
          LoginWorkspaceReview().toMap(object.loginWorkspaceReview);
      return data;
    } else {
      return null;
    }
  }

  LoginWorkspace.fromJson(Map<String, dynamic> dynamicData) {
    id = dynamicData["id"] == null ? null : dynamicData["id"] as String;
    title =
        dynamicData["title"] == null ? null : dynamicData["title"] as String;
    notification = dynamicData["notification"] == null
        ? null
        : dynamicData["notification"] as bool;
    photo =
        dynamicData["photo"] == null ? null : dynamicData["photo"] as String;
    memberId = dynamicData["memberId"] == null
        ? null
        : dynamicData["memberId"] as String;
    status =
        dynamicData["status"] == null ? null : dynamicData["status"] as String;
    plan = PlanOverviewData().fromMap(dynamicData["plan"]);
    loginMemberRole = LoginRole().fromMap(dynamicData["loginMemberRole"]);
    loginWorkspaceReview =
        LoginWorkspaceReview().fromMap(dynamicData["review"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["notification"] = notification;
    data["photo"] = photo;
    data["memberId"] = memberId;
    data["status"] = status;
    data["plan"] = PlanOverviewData().toMap(plan!);
    data["loginMemberRole"] = LoginRole().toMap(loginMemberRole);
    data["review"] = LoginWorkspaceReview().toMap(loginWorkspaceReview);
    return data;
  }

  @override
  List<LoginWorkspace>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<LoginWorkspace> workSpace = <LoginWorkspace>[];
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
  List<Map<String, dynamic>>? toMapList(List<LoginWorkspace>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final LoginWorkspace data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
