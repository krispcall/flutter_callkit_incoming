import "package:mvp/viewObject/common/Holder.dart";

class UpdateUserNotificationSettingParameterHolder
    extends Holder<UpdateUserNotificationSettingParameterHolder> {
  UpdateUserNotificationSettingParameterHolder({
    required this.callMessages,
    required this.newLeads,
    required this.flashTaskbar,
  });

  bool callMessages;
  bool newLeads;
  bool flashTaskbar;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["callMessages"] = callMessages;
    map["newLeads"] = newLeads;
    map["flashTaskbar"] = flashTaskbar;
    return map;
  }

  @override
  UpdateUserNotificationSettingParameterHolder fromMap(dynamic dynamicData) {
    return UpdateUserNotificationSettingParameterHolder(
      callMessages: dynamicData["callMessages"] as bool,
      newLeads: dynamicData["newLeads"] as bool,
      flashTaskbar: dynamicData["flashTaskbar"] as bool,
    );
  }
}
