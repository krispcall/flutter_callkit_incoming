import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/clientDndResponse/ClientDndResponseData.dart";

class ClientDndResponse extends Object<ClientDndResponse> {
  ClientDndResponse({
    this.clientDndResponseData,
  });

  ClientDndResponseData? clientDndResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ClientDndResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ClientDndResponse(
        clientDndResponseData:
            ClientDndResponseData().fromMap(dynamicData["updateClientDND"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ClientDndResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["updateClientDND"] =
          ClientDndResponseData().toMap(object.clientDndResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ClientDndResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ClientDndResponse> data = <ClientDndResponse>[];

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
  List<Map<String, dynamic>>? toMapList(List<ClientDndResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ClientDndResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
