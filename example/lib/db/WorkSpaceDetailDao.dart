import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/workspace/workspace_detail/Workspace.dart";
import "package:sembast/sembast.dart";

class WorkspaceDetailDao extends Dao<Workspace> {
  WorkspaceDetailDao._() {
    init(Workspace());
  }

  static const String STORE_NAME = "krispcallMvp_Workspace";
  final String _primaryKey = "id";

  // Singleton instance
  static final WorkspaceDetailDao _singleton = WorkspaceDetailDao._();

  // Singleton accessor
  static WorkspaceDetailDao get instance => _singleton;

  @override
  String getPrimaryKey(Workspace object) {
    return object.workspace!.data!.id!;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(Workspace object) {
    return Filter.equals(_primaryKey, object.workspace!.data!.id);
  }
}
