import "package:mvp/viewObject/common/Holder.dart" show Holder;

class ChangePasswordParameterHolder
    extends Holder<ChangePasswordParameterHolder> {
  ChangePasswordParameterHolder(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword});

  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["current_password"] = currentPassword;
    map["new_password"] = newPassword;
    map["confirm_new_password"] = confirmPassword;

    return map;
  }

  @override
  ChangePasswordParameterHolder fromMap(dynamic dynamicData) {
    return ChangePasswordParameterHolder(
      currentPassword: dynamicData["current_password"] as String,
      newPassword: dynamicData["new_password"] as String,
      confirmPassword: dynamicData["confirm_new_password"] as String,
    );
  }
}
