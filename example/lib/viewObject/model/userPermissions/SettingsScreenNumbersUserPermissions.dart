import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenNumbersUserPermissions
    extends Object<SettingsScreenNumbersUserPermissions> {
  final bool? portNumberConfig;
  final bool? addNewNumber;
  final bool? viewNumberList;
  final bool? editNumberDetails;
  final bool? autoRecordCalls;
  final bool? editToggleIntnCalls;
  final bool? shareAccess;
  final bool? autoVoicemailTranscription;
  final bool? deleteNumber;

  SettingsScreenNumbersUserPermissions(
      {this.portNumberConfig,
      this.addNewNumber,
      this.viewNumberList,
      this.editNumberDetails,
      this.autoRecordCalls,
      this.editToggleIntnCalls,
      this.shareAccess,
      this.autoVoicemailTranscription,
      this.deleteNumber});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenNumbersUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenNumbersUserPermissions(
        portNumberConfig: dynamicData["port_number_config"] == null? null :dynamicData["port_number_config"] as bool,
        addNewNumber: dynamicData["add_new_number"] == null? null :dynamicData["add_new_number"] as bool,
        viewNumberList: dynamicData["view_number_list"] == null? null :dynamicData["view_number_list"] as bool,
        editNumberDetails: dynamicData["edit_number_details"] == null? null :dynamicData["edit_number_details"] as bool,
        autoRecordCalls: dynamicData["auto_record_calls"] == null? null :dynamicData["auto_record_calls"] as bool,
        editToggleIntnCalls: dynamicData["edit_toggle_intn_calls"] == null? null :dynamicData["edit_toggle_intn_calls"] as bool,
        shareAccess: dynamicData["share_access"] == null? null :dynamicData["share_access"] as bool,
        autoVoicemailTranscription:
            dynamicData["auto_voicemail_transcription"] == null? null :dynamicData["auto_voicemail_transcription"] as bool,
        deleteNumber: dynamicData["delete_number"] == null? null :dynamicData["delete_number"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenNumbersUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["port_number_config"] = object.portNumberConfig;
      data["add_new_number"] = object.addNewNumber;
      data["view_number_list"] = object.viewNumberList;
      data["edit_number_details"] = object.editNumberDetails;
      data["auto_record_calls"] = object.autoRecordCalls;
      data["edit_toggle_intn_calls"] = object.editToggleIntnCalls;
      data["share_access"] = object.shareAccess;
      data["auto_voicemail_transcription"] = object.autoVoicemailTranscription;
      data["delete_number"] = object.deleteNumber;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenNumbersUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenNumbersUserPermissions> listMessages =
        <SettingsScreenNumbersUserPermissions>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          listMessages.add(fromMap(dynamicData)!);
        }
      }
    }
    return listMessages;
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as SettingsScreenNumbersUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
