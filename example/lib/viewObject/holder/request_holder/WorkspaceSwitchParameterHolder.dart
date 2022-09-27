import "package:mvp/viewObject/common/Holder.dart";

class WorkspaceSwitchParameterHolder
    extends Holder<WorkspaceSwitchParameterHolder> {
  WorkspaceSwitchParameterHolder({
    required this.defaultWorkspace,
  });

  final String defaultWorkspace;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["defaultWorkspace"] = defaultWorkspace;
    return map;
  }

  @override
  WorkspaceSwitchParameterHolder fromMap(dynamic dynamicData) {
    return WorkspaceSwitchParameterHolder(
      defaultWorkspace: dynamicData["defaultWorkspace"] as String,
    );
  }
}
