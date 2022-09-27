import "package:mvp/viewObject/common/Holder.dart";
/*
 * *
 *  * Created by Kedar on 7/19/21 12:31 PM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/19/21 12:31 PM
 *  
 */

class ChannelDndHolder extends Holder<ChannelDndHolder> {
  ChannelDndHolder({
    required this.id,
    this.minutes,
  });

  final String id;
  final int? minutes;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["id"] = id;
    if (minutes != null) {
      map["minutes"] = minutes;
    }
    return map;
  }

  @override
  ChannelDndHolder fromMap(dynamic dynamicData) {
    return ChannelDndHolder(
      id: dynamicData["id"] as String,
      minutes: dynamicData["minutes"] as int,
    );
  }
}
