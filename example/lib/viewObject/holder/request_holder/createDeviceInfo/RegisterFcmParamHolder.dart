import "package:mvp/viewObject/common/Holder.dart";

class RegisterFcmParamHolder extends Holder<RegisterFcmParamHolder> {
  RegisterFcmParamHolder({
    required this.fcmRegistrationId,
    required this.version,
    required this.platform,
  });

  final String? fcmRegistrationId;
  final String version;
  final String platform;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["fcmToken"] = fcmRegistrationId;
    map["version"] = version;
    map["platform"] = platform;
    return map;
  }

  @override
  RegisterFcmParamHolder fromMap(dynamic dynamicData) {
    return RegisterFcmParamHolder(
      fcmRegistrationId: dynamicData["fcmToken"] as String,
      version: dynamicData["version"] as String,
      platform: dynamicData["platform"] as String,
    );
  }
}
