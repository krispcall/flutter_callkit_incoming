import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/channel/ChannelData.dart";
import "package:sembast/sembast.dart";

class ChannelListDao extends Dao<ChannelData> {
  ChannelListDao._() {
    init(ChannelData());
  }

  static const String STORE_NAME = "krispcallMvp_ChannelList";
  final String _primaryKey = "id";

  // Singleton instance
  static final ChannelListDao _singleton = ChannelListDao._();

  // Singleton accessor
  static ChannelListDao get instance => _singleton;

  @override
  String getPrimaryKey(ChannelData object) {
    return object.data![0].id!;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ChannelData object) {
    return Filter.equals(_primaryKey, object.data![0].id);
  }
}
