import "package:mvp/viewObject/common/Holder.dart";

class UserNameUpdateParamHolder extends Holder<UserNameUpdateParamHolder> {
  final String? userName;

  UserNameUpdateParamHolder({required this.userName});

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map["new_full_name"] = userName;
    return map;
  }

  @override
  UserNameUpdateParamHolder fromMap(dynamic dynamicData) {
    return UserNameUpdateParamHolder(
        userName: dynamicData["new_full_name"] as String);
  }
}
