import "package:mvp/viewObject/common/Holder.dart" show Holder;

class TeamsMemberListUpdateRequestParamHolder
    extends Holder<TeamsMemberListUpdateRequestParamHolder> {
  TeamsMemberListUpdateRequestParamHolder(
      {required this.teamId, required this.data});

  final String teamId;
  final TeamsMemberListMemberUpdateDataRequestParamHolder data;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = teamId;
    map["data"] = TeamsMemberListMemberUpdateDataRequestParamHolder(
      memberId: data.memberId,
    ).toMap();
    return map;
  }

  @override
  TeamsMemberListUpdateRequestParamHolder fromMap(dynamic dynamicData) {
    return TeamsMemberListUpdateRequestParamHolder(
      teamId: dynamicData["id"] as String,
      data: dynamicData["data"]
          as TeamsMemberListMemberUpdateDataRequestParamHolder,
    );
  }
}

class TeamsMemberListMemberUpdateDataRequestParamHolder
    extends Holder<TeamsMemberListMemberUpdateDataRequestParamHolder> {
  final List<String>? memberId;

  TeamsMemberListMemberUpdateDataRequestParamHolder({
    this.memberId,
  });

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["members"] = memberId;
    return map;
  }

  @override
  TeamsMemberListMemberUpdateDataRequestParamHolder fromMap(
      dynamic dynamicData) {
    return TeamsMemberListMemberUpdateDataRequestParamHolder(
      memberId: dynamicData["members"] as List<String>,
    );
  }
}
