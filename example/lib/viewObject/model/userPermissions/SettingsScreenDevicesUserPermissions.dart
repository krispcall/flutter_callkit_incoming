import "package:mvp/viewObject/common/Object.dart";

class SettingsScreenDevicesUserPermissions
    extends Object<SettingsScreenDevicesUserPermissions> {
  final bool? selectInputDevice;
  final bool? selectOutputDevices;
  final bool? adjustInputVolume;
  final bool? adjustOutputVolume;
  final bool? microphoneTest;
  final bool? cancelEcho;
  final bool? reduceNoise;

  SettingsScreenDevicesUserPermissions(
      {this.selectInputDevice,
      this.selectOutputDevices,
      this.adjustInputVolume,
      this.adjustOutputVolume,
      this.microphoneTest,
      this.cancelEcho,
      this.reduceNoise});

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  SettingsScreenDevicesUserPermissions? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return SettingsScreenDevicesUserPermissions(
        selectInputDevice: dynamicData["select_input_device"] == null
            ? null
            : dynamicData["select_input_device"] as bool,
        selectOutputDevices: dynamicData["select_output_devices"] == null
            ? null
            : dynamicData["select_output_devices"] as bool,
        adjustInputVolume: dynamicData["adjust_input_volume"] == null
            ? null
            : dynamicData["adjust_input_volume"] as bool,
        adjustOutputVolume: dynamicData["adjust_output_volume"] == null
            ? null
            : dynamicData["adjust_output_volume"] as bool,
        microphoneTest: dynamicData["microphone_test"] == null
            ? null
            : dynamicData["microphone_test"] as bool,
        cancelEcho: dynamicData["cancel_echo"] == null
            ? null
            : dynamicData["cancel_echo"] as bool,
        reduceNoise: dynamicData["reduce_noise"] == null
            ? null
            : dynamicData["reduce_noise"] as bool,
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(SettingsScreenDevicesUserPermissions? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["select_input_device"] = object.selectInputDevice;
      data["select_output_devices"] = object.selectOutputDevices;
      data["adjust_input_volume"] = object.adjustInputVolume;
      data["adjust_output_volume"] = object.adjustOutputVolume;
      data["microphone_test"] = object.microphoneTest;
      data["cancel_echo"] = object.cancelEcho;
      data["reduce_noise"] = object.reduceNoise;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SettingsScreenDevicesUserPermissions>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<SettingsScreenDevicesUserPermissions> listMessages =
        <SettingsScreenDevicesUserPermissions>[];

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
  List<Map<String, dynamic>> toMapList(List<dynamic>? objectList) {
    final List<Map<String, dynamic>> dynamicList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data as SettingsScreenDevicesUserPermissions)!);
        }
      }
    }
    return dynamicList;
  }
}
