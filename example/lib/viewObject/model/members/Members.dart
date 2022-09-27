import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/members/ChatMessage.dart";
import "package:mvp/viewObject/model/members/MemberNumber.dart";

class Members extends Object<Members> {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? role;
  String? gender;
  String? email;
  String? createdOn;
  String? profilePicture;
  bool? online;
  int? unSeenMsgCount;
  List<MemberNumber>? numbers;
  bool? onCall;
  ChatMessageNodes? chatMessageNode;
  int? onlineConnection;

  Members({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.role,
    this.gender,
    this.email,
    this.createdOn,
    this.profilePicture,
    this.numbers,
    this.online,
    this.unSeenMsgCount,
    this.onCall,
    this.chatMessageNode,
    this.onlineConnection,
  });

  @override
  Members? fromMap(dynamic dynamicData) {
    if (dynamicData != null) {
      return Members(
        id: dynamicData["id"] == null ? null : dynamicData["id"] as String,
        firstName: dynamicData["firstname"] == null
            ? null
            : dynamicData["firstname"] as String,
        lastName: dynamicData["lastname"] == null
            ? null
            : dynamicData["lastname"] as String,
        fullName: "${dynamicData["firstname"]} ${dynamicData["lastname"]}",
        role:
            dynamicData["role"] == null ? null : dynamicData["role"] as String,
        gender: dynamicData["gender"] == null
            ? null
            : dynamicData["gender"] as String,
        email: dynamicData["email"] == null
            ? null
            : dynamicData["email"] as String,
        createdOn: dynamicData["createdOn"] == null
            ? null
            : dynamicData["createdOn"] as String,
        profilePicture: dynamicData["profilePicture"] == null
            ? null
            : dynamicData["profilePicture"] as String,
        online: dynamicData["online"] == null
            ? null
            : dynamicData["online"] as bool,
        unSeenMsgCount: dynamicData["unSeenMsgCount"] == null
            ? null
            : dynamicData["unSeenMsgCount"] as int,
        numbers: MemberNumber().fromMapList(dynamicData["numbers"] == null
            ? null
            : dynamicData["numbers"] as List<dynamic>),
        onCall: dynamicData["onCall"] == null
            ? null
            : dynamicData["onCall"] as bool,
        chatMessageNode: dynamicData["last_message"] != null
            ? ChatMessageNodes().fromMap(dynamicData["last_message"])
            : null,
        onlineConnection: dynamicData["onlineConnection"] == null
            ? null
            : dynamicData["onlineConnection"] as int,
      );
    } else {
      return null;
    }
  }

  @override
  List<Members>? fromMapList(List? dynamicDataList) {
    final List<Members> data = <Members>[];

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
  String? getPrimaryKey() {
    return "id";
  }

  @override
  Map<String, dynamic>? toMap(Members? object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["id"] = object.id;
      data["firstname"] = object.firstName;
      data["lastname"] = object.lastName;
      data["fullName"] = object.fullName;
      data["role"] = object.role;
      data["gender"] = object.gender;
      data["email"] = object.email;
      data["createdOn"] = object.createdOn;
      data["profilePicture"] = object.profilePicture;
      data["online"] = object.online;
      data["unSeenMsgCount"] = object.unSeenMsgCount;
      data["numbers"] = MemberNumber().toMapList(object.numbers);
      data["onCall"] = object.onCall;
      data["last_message"] = object.chatMessageNode != null
          ? ChatMessageNodes().toMap(object.chatMessageNode)
          : null;
      data["onlineConnection"] = object.onlineConnection;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<Members>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (final Members data in objectList) {
        mapList.add(toMap(data)!);
      }
    }
    return mapList;
  }
}
