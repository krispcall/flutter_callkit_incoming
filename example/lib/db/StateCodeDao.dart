import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";
import "package:sembast/sembast.dart";

class StateCodeDao extends Dao<StateCodes> {
  StateCodeDao._() {
    init(StateCodes());
  }
  static const String STORE_NAME = "krispcallMvp_StateCode";
  final String _primaryKey = "dialCode";

  // Singleton instance
  static final StateCodeDao _singleton = StateCodeDao._();

  // Singleton accessor
  static StateCodeDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String getPrimaryKey(StateCodes object) {
    return obj!.dialCode!;
  }

  @override
  Filter getFilter(StateCodes object) {
    return Filter.equals(_primaryKey, object.dialCode);
  }
}
