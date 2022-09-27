import "package:mvp/viewObject/common/Holder.dart" show Holder;
import "package:mvp/viewObject/holder/request_holder/blockContactRequestParamHolder/BlockContactRequestParamHolder.dart";

class BlockContactRequestHolder extends Holder<BlockContactRequestHolder> {
  BlockContactRequestHolder({
    this.contactId,
    required this.number,
    required this.data,
  });

  final BlockContactRequestParamHolder data;
  final String? contactId;
  final String number;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["data"] = BlockContactRequestParamHolder(
      isBlock: data.isBlock,
    ).toMap();
    if (contactId != null) {
      map["uid"] = contactId;
    }
    map["number"] = number;
    return map;
  }

  @override
  BlockContactRequestHolder fromMap(dynamic dynamicData) {
    return BlockContactRequestHolder(
      data: BlockContactRequestParamHolder().fromMap(dynamicData["data"]),
      contactId: dynamicData["uid"] as String,
      number: dynamicData["number"] as String,
    );
  }
}
