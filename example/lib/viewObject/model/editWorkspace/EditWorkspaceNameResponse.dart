import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/editWorkspace/EditWorkspaceNameResponseData.dart";

class EditWorkspaceNameResponse extends Object<EditWorkspaceNameResponse> {
  EditWorkspaceNameResponse({
    this.editWorkspaceResponseData,
  });

  EditWorkspaceNameResponseData? editWorkspaceResponseData;

  @override
  String? getPrimaryKey() {
    return "";
  }

  @override
  EditWorkspaceNameResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return EditWorkspaceNameResponse(
        editWorkspaceResponseData: EditWorkspaceNameResponseData()
            .fromMap(dynamicData["editWorkspace"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(EditWorkspaceNameResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["editWorkspace"] = EditWorkspaceNameResponseData()
          .toMap(object.editWorkspaceResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<EditWorkspaceNameResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<EditWorkspaceNameResponse> data = <EditWorkspaceNameResponse>[];

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
      List<EditWorkspaceNameResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final EditWorkspaceNameResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
