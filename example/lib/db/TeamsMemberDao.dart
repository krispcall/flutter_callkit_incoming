/*
 * *
 *  * Created by Kedar on 7/13/21 7:30 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 7:30 AM
 *  
 */

import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/members/MemberEdges.dart";
import "package:sembast/sembast.dart";

class TeamsMemberDao extends Dao<MemberEdges> {
  TeamsMemberDao._() {
    init(MemberEdges());
  }

  static const String TABLE_NAME = "krispcallMvp_TeamsMember";
  final String _primaryKey = "id";

  // Singleton instance
  static final TeamsMemberDao _singleton = TeamsMemberDao._();

  // Singleton accessor
  static TeamsMemberDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(MemberEdges object) {
    return object.members!.id!;
  }

  @override
  Filter getFilter(MemberEdges object) {
    return Filter.equals(_primaryKey, object.members!.id);
  }
}
