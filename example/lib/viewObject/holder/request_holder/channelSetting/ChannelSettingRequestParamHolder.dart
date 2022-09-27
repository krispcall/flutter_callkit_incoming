import "package:mvp/viewObject/common/Holder.dart";

class GeneralChannelSettingsInputHolder
    extends Holder<GeneralChannelSettingsInputHolder> {
  final String? channel;
  final GeneralChannelSettingParam? data;

  GeneralChannelSettingsInputHolder({this.channel, this.data});

  @override
  GeneralChannelSettingsInputHolder fromMap(dynamic dynamicData) {
    return GeneralChannelSettingsInputHolder(
        channel: dynamicData["channel"] as String,
        data: dynamicData["data"] as GeneralChannelSettingParam);
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (channel != null) {
      map["channel"] = channel;
    }
    if (data != null) {
      map["data"] = data!.toMap();
    }
    return map;
  }
}

class GeneralChannelSettingParam extends Holder<GeneralChannelSettingParam> {
  final String? emoji;
  final String? name;
  final bool? autoRecordCalls;
  final bool? internationalCallAndMessages;
  final bool? emailNotification;
  final bool? transcription;

  GeneralChannelSettingParam(
      {this.emoji,
      this.name,
      this.autoRecordCalls,
      this.internationalCallAndMessages,
      this.emailNotification,
      this.transcription});

  @override
  GeneralChannelSettingParam fromMap(dynamic dynamicData) {
    return GeneralChannelSettingParam(
        emoji: dynamicData["emoji"] as String,
        name: dynamicData["name"] as String,
        autoRecordCalls: dynamicData["autoRecordCalls"] as bool,
        internationalCallAndMessages:
            dynamicData["internationalCallAndMessages"] as bool,
        emailNotification: dynamicData["emailNotification"] as bool,
        transcription: dynamicData["transcription"] as bool);
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (emoji != null) {
      map["emoji"] = emoji;
    }
    if (name != null) {
      map["name"] = name;
    }
    if (autoRecordCalls != null) {
      map["autoRecordCalls"] = autoRecordCalls;
    }
    if (internationalCallAndMessages != null) {
      map["internationalCallAndMessages"] = internationalCallAndMessages;
    }
    if (emailNotification != null) {
      map["emailNotification"] = emailNotification;
    }
    if (transcription != null) {
      map["transcription"] = transcription;
    }
    return map;
  }
}
