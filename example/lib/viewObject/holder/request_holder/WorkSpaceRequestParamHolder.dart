import "package:mvp/viewObject/common/Holder.dart";

class WorkSpaceRequestParamHolder extends Holder<WorkSpaceRequestParamHolder> {
  WorkSpaceRequestParamHolder(
      {required this.authToken,
      required this.workspaceId,
      required this.memberId});

  final String authToken;
  final String workspaceId;
  final String memberId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["authToken"] = authToken;
    map["workspaceId"] = workspaceId;
    map["memberId"] = memberId;
    return map;
  }

  @override
  WorkSpaceRequestParamHolder fromMap(dynamic dynamicData) {
    return WorkSpaceRequestParamHolder(
      authToken: dynamicData["authToken"] as String,
      workspaceId: dynamicData["workspaceId"] as String,
      memberId: dynamicData["memberId"] as String,
    );
  }
}
