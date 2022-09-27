import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/forgotPassword/ForgotPasswordResponseData.dart";

class ForgotPasswordResponse extends Object<ForgotPasswordResponse> {
  ForgotPasswordResponse({
    this.forgotPasswordResponseData,
  });

  ForgotPasswordResponseData? forgotPasswordResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ForgotPasswordResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ForgotPasswordResponse(
        forgotPasswordResponseData:
            ForgotPasswordResponseData().fromMap(dynamicData["forgotPassword"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ForgotPasswordResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["forgotPassword"] = ForgotPasswordResponseData()
          .toMap(object.forgotPasswordResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ForgotPasswordResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ForgotPasswordResponse> data = <ForgotPasswordResponse>[];

    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          data.add(fromMap(dynamicData)!);
        }
      }
    }
    return data;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<ForgotPasswordResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ForgotPasswordResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
