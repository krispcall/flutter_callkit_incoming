import "package:mvp/viewObject/common/Holder.dart";

class ContactDetailRequestParamHolder
    extends Holder<ContactDetailRequestParamHolder> {
  final String? uid;

  ContactDetailRequestParamHolder({
    this.uid,
  });

  @override
  ContactDetailRequestParamHolder fromMap(dynamic dynamicData) {
    return ContactDetailRequestParamHolder(
      uid: dynamicData["uid"] as String,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["uid"] = uid;
    return map;
  }
}

class ContactDetailByNumberRequestParamHolder
    extends Holder<ContactDetailByNumberRequestParamHolder> {
  final String? number;

  ContactDetailByNumberRequestParamHolder({
    this.number,
  });

  @override
  ContactDetailByNumberRequestParamHolder fromMap(dynamic dynamicData) {
    return ContactDetailByNumberRequestParamHolder(
      number: dynamicData["number"] as String,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["number"] = number;
    return map;
  }
}
