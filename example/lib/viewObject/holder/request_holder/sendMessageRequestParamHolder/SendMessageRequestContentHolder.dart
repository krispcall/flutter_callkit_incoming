import "package:mvp/viewObject/common/Holder.dart";

class SendMessageRequestContentHolder
    extends Holder<SendMessageRequestContentHolder> {
  final String? body;

  SendMessageRequestContentHolder({
    this.body,
  });

  @override
  SendMessageRequestContentHolder fromMap(dynamic dynamicData) {
    return SendMessageRequestContentHolder(
      body: dynamicData["body"] as String,
    );
  }

  @override
  Map toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map["body"] = body;
    return map;
  }
}
