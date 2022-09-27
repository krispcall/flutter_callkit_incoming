import "package:mvp/viewObject/common/Holder.dart";
/*
 * *
 *  * Created by Kedar on 7/19/21 12:31 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/19/21 12:31 PM
 *  
 */

class UpdateClientDNDRequestParamHolder
    extends Holder<UpdateClientDNDRequestParamHolder> {
  UpdateClientDNDRequestParamHolder({
    required this.contact,
    required this.minutes,
    required this.removeFromDND,
  });

  final String contact;
  final int minutes;
  final bool removeFromDND;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["contact"] = contact;
    map["minutes"] = minutes;
    map["removeFromDND"] = removeFromDND;
    return map;
  }

  @override
  UpdateClientDNDRequestParamHolder fromMap(dynamic dynamicData) {
    return UpdateClientDNDRequestParamHolder(
      contact: dynamicData["contact"] as String,
      minutes: dynamicData["minutes"] as int,
      removeFromDND: dynamicData["removeFromDND"] as bool,
    );
  }
}
