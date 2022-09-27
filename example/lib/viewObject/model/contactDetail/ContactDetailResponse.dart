import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/contactDetail/ContactDetailResponseData.dart";

class ContactDetailResponse extends Object<ContactDetailResponse> {
  ContactDetailResponse({
    this.contactDetailResponseData,
  });

  ContactDetailResponseData? contactDetailResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ContactDetailResponse ?fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ContactDetailResponse(
        contactDetailResponseData:
            ContactDetailResponseData().fromMap(dynamicData["contact"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ContactDetailResponse? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["contact"] =
          ContactDetailResponseData().toMap(object.contactDetailResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ContactDetailResponse>? fromMapList(List<dynamic>? dynamicDataList) {
    final List<ContactDetailResponse> data = <ContactDetailResponse>[];

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
  List<Map<String, dynamic>> ?toMapList(List<ContactDetailResponse> ?objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ContactDetailResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}

class ClientDetailResponse extends Object<ClientDetailResponse> {
  ClientDetailResponse({
    this.contactDetailResponseData,
  });

  ContactDetailResponseData? contactDetailResponseData;

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  ClientDetailResponse? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return ClientDetailResponse(
        contactDetailResponseData:
            ContactDetailResponseData().fromMap(dynamicData["clientDetail"]),
      );
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toMap(ClientDetailResponse ?object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["clientDetail"] =
          ContactDetailResponseData().toMap(object.contactDetailResponseData!);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<ClientDetailResponse>? fromMapList(List<dynamic> ?dynamicDataList) {
    final List<ClientDetailResponse> data = <ClientDetailResponse>[];

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
  List<Map<String, dynamic>> ?toMapList(List<ClientDetailResponse>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final ClientDetailResponse data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
