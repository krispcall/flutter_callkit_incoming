import "package:mvp/viewObject/common/Holder.dart";

class SearchInputRequestParamHolder
    extends Holder<SearchInputRequestParamHolder> {
  SearchInputRequestParamHolder({
    this.value,
    this.columns,
  });

  String? value;
  List<String>? columns;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["value"] = value;
    map["columns"] = columns;
    return map;
  }

  @override
  SearchInputRequestParamHolder fromMap(dynamic dynamicData) {
    return SearchInputRequestParamHolder(
      value: dynamicData["value"] as String,
      columns: (dynamicData["columns"] as List)
          .map((item) => item as String)
          .toList(),
    );
  }
}
