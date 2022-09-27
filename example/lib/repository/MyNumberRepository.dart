/*
 * *
 *  * Created by Kedar on 7/29/21 11:47 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 7/29/21 11:47 AM
 *  
 */

import "dart:async";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/NumberDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/viewObject/model/numbers/NumberResponse.dart";
import "package:mvp/viewObject/model/numbers/Numbers.dart";
import "package:sembast/sembast.dart";

class MyNumberRepository extends Repository {
  MyNumberRepository({
    required this.apiService,
    required this.numbersDao,
  });

  ApiService apiService;
  NumberDao numbersDao;
  String primaryKey = "id";

  Future<Resources<List<Numbers>>> doSearchMyNumbersLocally(String text) async {
    final Finder finder = Finder(
      filter: Filter.or(
        [
          Filter.matchesRegExp(
            "name",
            RegExp(text, caseSensitive: false),
          ),
          Filter.matchesRegExp(
            "number",
            RegExp(text, caseSensitive: false),
          )
        ],
      ),
    );
    return numbersDao.getAll(finder: finder);
  }

  Future<Resources<List<Numbers>>> doGetMyNumbersListApiCall(
      int limit, bool isConnectedToInternet, Status status) async {
    final Resources<NumberResponse> resource = await apiService.getMyNumbers();
    if (resource.status == Status.SUCCESS) {
      if (resource.data!.data!.error == null) {
        if (resource.data!.data!.numbers != null) {
          await numbersDao.deleteAll();
          await numbersDao.insertAll(primaryKey, resource.data!.data!.numbers);
          return Resources(Status.SUCCESS, "", resource.data!.data!.numbers);
        } else {
          return numbersDao.getAll();
        }
      } else {
        return numbersDao.getAll();
      }
    } else {
      return numbersDao.getAll();
    }
  }
}
