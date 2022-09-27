import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/userPlanRestriction/PlanRestriction.dart";
import "package:sembast/sembast.dart";

class PlanRestrictionDao extends Dao<PlanRestriction> {
  PlanRestrictionDao._() {
    init(PlanRestriction());
  }
  static const String TABLE_NAME = "krispcallMvp_PlanRestriction";
  final String _primaryKey = "id";

  // Singleton instance
  static final PlanRestrictionDao _singleton = PlanRestrictionDao._();

  // Singleton accessor
  static PlanRestrictionDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(PlanRestriction object) {
    return object.id!;
  }

  @override
  Filter getFilter(PlanRestriction object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
