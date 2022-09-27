/*
 * *
 *  * Created by Kedar on 7/29/21 9:15 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 9:15 AM
 *
 */

import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/model/blockContact/BlockContactData.dart";

class BlockContactResponse extends Object<BlockContactResponse> {
  BlockContactData? blockContact;
  BlockContactData? blockNumber;

  BlockContactResponse({this.blockContact, this.blockNumber});

  @override
  String getPrimaryKey() {
    return "";
  }

  @override
  BlockContactResponse fromMap(dynamic dynamicData) {
    // if (dynamicData != null) {
      return BlockContactResponse(
        blockContact: BlockContactData().fromMap(dynamicData["blockContact"]),
        blockNumber: BlockContactData().fromMap(dynamicData["blockNumber"]),
      );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic> toMap(BlockContactResponse? object) {
    // if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      if (object?.blockContact != null) {
        data["blockContact"] = BlockContactData().toMap(object!.blockContact!);
      }
      if (object?.blockNumber != null) {
        data["blockNumber"] = BlockContactData().toMap(object!.blockNumber);
      }
      return data;
    // } else {
    //   return null;
    // }
  }

  @override
  List<BlockContactResponse>? fromMapList(List? dynamicDataList) {
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>>? toMapList(List<BlockContactResponse>? objectList) {
    throw UnimplementedError();
  }
}
