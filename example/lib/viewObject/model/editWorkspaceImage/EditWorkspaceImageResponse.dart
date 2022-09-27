import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/editWorkspaceImage/EditWorkspaceImageResponseData.dart";

class EditWorkspaceImageResponse extends Object<EditWorkspaceImageResponse> {
  EditWorkspaceImageResponse({
    this.editWorkspaceImageResponseData,
  });

  EditWorkspaceImageResponseData? editWorkspaceImageResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  EditWorkspaceImageResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditWorkspaceImageResponse(
        editWorkspaceImageResponseData: EditWorkspaceImageResponseData()
            .fromMap(dynamicData["changeWorkspacePhoto"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(EditWorkspaceImageResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["changeWorkspacePhoto"] = EditWorkspaceImageResponseData()
          .toMap(object.editWorkspaceImageResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<EditWorkspaceImageResponse>? fromMapList(
      List<dynamic>? dynamicDataList) {
    final List<EditWorkspaceImageResponse> login =
        <EditWorkspaceImageResponse>[];
    if (dynamicDataList != null) {
      for (final dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          login.add(fromMap(dynamicData)!);
        }
      }
    }
    return login;
  }

  @override
  List<Map<String, dynamic>>? toMapList(
      List<EditWorkspaceImageResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final EditWorkspaceImageResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
