import "package:mvp/db/common/Dao.dart";
import "package:mvp/viewObject/model/allNotes/Notes.dart";
import "package:sembast/sembast.dart";
/*
 * *
 *  * Created by Kedar on 7/13/21 7:30 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/13/21 7:30 AM
 *  
 */

class NotesDao extends Dao<Notes> {
  NotesDao._() {
    init(Notes());
  }

  static const String TABLE_NAME = "krispcallMvp_Notes";
  final String _primaryKey = "id";

  // Singleton instance
  static final NotesDao _singleton = NotesDao._();

  // Singleton accessor
  static NotesDao get instance => _singleton;

  @override
  String getStoreName() {
    return TABLE_NAME;
  }

  @override
  String getPrimaryKey(Notes object) {
    return object.id!;
  }

  @override
  Filter getFilter(Notes object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
