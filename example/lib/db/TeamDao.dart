/*
 * *
 *  * Created by Kedar on 7/13/21 7:30 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 7:30 AM
 *  
 */

import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/teams/Teams.dart";
import "package:sembast/sembast.dart";

class TeamDao extends Dao<Teams> {
  TeamDao._() {
    init(Teams());
  }

  static const String TABLE_NAME = "krispcallMvp_Teams";
  final String _primaryKey = "id";

  // Singleton instance
  static final TeamDao _singleton = TeamDao._();

  // Singleton accessor
  static TeamDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(Teams object) {
    return object.id!;
  }

  @override
  Filter getFilter(Teams object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
