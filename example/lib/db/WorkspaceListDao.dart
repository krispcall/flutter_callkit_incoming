import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/workspace/workspacelist/WorkspaceListData.dart";
import "package:sembast/sembast.dart";

class WorkspaceListDao extends Dao<WorkspaceListData> {
  WorkspaceListDao._() {
    init(WorkspaceListData());
  }

  static const String STORE_NAME = "krispcallMvp_WorkspaceList";
  final String _primaryKey = "id";

  // Singleton instance
  static final WorkspaceListDao _singleton = WorkspaceListDao._();

  // Singleton accessor
  static WorkspaceListDao get instance => _singleton;

  @override
  String getPrimaryKey(WorkspaceListData object) {
    return object.id!;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(WorkspaceListData object) {
    return Filter.equals(_primaryKey, object.id!);
  }
}
