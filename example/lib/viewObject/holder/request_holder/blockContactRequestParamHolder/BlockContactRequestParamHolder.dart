import "package:mvp/viewObject/common/Holder.dart";

class BlockContactRequestParamHolder
    extends Holder<BlockContactRequestParamHolder> {
  final bool? isBlock;

  BlockContactRequestParamHolder({
    this.isBlock,
  });

  @override
  BlockContactRequestParamHolder fromMap(dynamic dynamicData) {
    return BlockContactRequestParamHolder(
      isBlock: dynamicData["blocked"] as bool,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (isBlock != null) {
      map["blocked"] = isBlock;
    }
    return map;
  }
}
