import "package:mvp/viewObject/common/Holder.dart";

class ForgotPasswordRequestParamHolder
    extends Holder<ForgotPasswordRequestParamHolder> {
  ForgotPasswordRequestParamHolder({this.userEmail, this.route});

  final String? userEmail;
  final String? route;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map["email"] = userEmail;
    map["route"] = route;
    return map;
  }

  @override
  ForgotPasswordRequestParamHolder fromMap(dynamic dynamicData) {
    return ForgotPasswordRequestParamHolder(
      userEmail: dynamicData["email"] as String,
      route: dynamicData["route"] as String,
    );
  }
}
