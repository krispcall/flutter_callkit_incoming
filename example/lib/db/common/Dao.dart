import "dart:async";
import "dart:core";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/common/AppDatabase.dart";
import "package:mvp/viewObject/common/MapObject.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:sembast/sembast.dart";

abstract class Dao<T extends Object<T>> {
  // dynamic dao;
  StoreRef<String, dynamic>? dao;
  T? obj;

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get db async => AppDatabase.instance!.database!;

  void init(T obj) {
    // A Store with int keys and Map<String, dynamic> values.
    // This Store acts like a persistent map, values of which are Fruit objects converted to Map
    dao = stringMapStoreFactory.store(getStoreName());
    this.obj = obj;
  }

  String getStoreName();

  dynamic getPrimaryKey(T object);

  Filter getFilter(T object);

  Future<dynamic> insert(String primaryKey, T object) async {
    await deleteWithFinder(
        Finder(filter: Filter.equals(primaryKey, object.getPrimaryKey())));
    await dao!.add(await db, obj!.toMap(object));

    return true;
  }

  Future<dynamic> insertAll(String? primaryKey, List<T>? objectList) async {
    final List<String> idList = <String>[];
    for (final T data in objectList!) {
      idList.add(data.getPrimaryKey()!);
    }
    await deleteWithFinder(Finder(filter: Filter.inList(primaryKey!, idList)));
    await dao!.addAll(await db, obj!.toMapList(objectList)!);
  }

  Future<dynamic> update(T object, {Finder? finder}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    finder ??= Finder(filter: getFilter(object));

    return dao!.update(await db, obj!.toMap(object), finder: finder);
  }

  Future<dynamic> updateWithFinder(T object, Finder finder) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    await dao!.update(
      await db,
      obj!.toMap(object),
      finder: finder,
    );
  }

  Future<dynamic> deleteAll() async {
    await dao!.delete(await db);
  }

  Future<dynamic> delete(T object, {Finder? finder}) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    finder ??= Finder(filter: getFilter(object));

    //final Finder finder = Finder(filter: finder);
    await dao!.delete(
      await db,
      finder: finder,
    );
  }

  Future<dynamic> updateOrInsert(String? key, Map<String, dynamic>? map) async {
    await dao!.record(key!).put(await db, map, merge: false);
  }

  Future<dynamic> deleteWithFinder(Finder finder) async {
    return dao!.delete(
      await db,
      finder: finder,
    );
  }

  Future<Resources<List<T>>> getByKey(String key, String value,
      {List<SortOrder>? sortOrderList, Status status = Status.SUCCESS}) async {
    final Finder finder = Finder(filter: Filter.equals(key, value));
    if (sortOrderList != null && sortOrderList.isNotEmpty) {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];
    recordSnapshots.forEach((dynamic snapshot) {
      resultList.add(obj!.fromMap(snapshot.value)!);
    });

    return Resources<List<T>>(status, "", resultList);
  }

  Future<dynamic> getAllWithSubscription(
      {StreamController<Resources<List<T>>>? stream,
      Finder? finder,
      Status status = Status.SUCCESS,
      Function? onDataUpdated}) async {
    finder ??= Finder();

    final dynamic query = dao!.query(finder: finder);

    final dynamic subscription =
        await query.onSnapshots(await db).listen((dynamic recordSnapshots2) {
      final List<T> resultList = <T>[];
      recordSnapshots2.forEach((dynamic snapshot) {
        final T localObj = obj!.fromMap(snapshot.value)!;
        localObj.key = snapshot.key as String;
        resultList.add(localObj);
      });

      onDataUpdated!(resultList);
    });

    return subscription;
  }

  Future<Resources<List<T>>> getAll(
      {Finder? finder, Status status = Status.SUCCESS}) async {
    finder ??= Finder();
    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );

    final List<T> resultList = <T>[];
    recordSnapshots.forEach((dynamic snapshot) {
      final T localObj = obj!.fromMap(snapshot.value)!;
      localObj.key = snapshot.key as String;
      resultList.add(localObj);
    });

    return Resources<List<T>>(status, "", resultList);
  }

  Future<Resources<T>>? getOne(
      {Finder? finder, Status status = Status.SUCCESS}) async {
    finder ??= Finder();
    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );
    T? result;

    for (final dynamic snapshot in recordSnapshots) {
      final T localObj = obj!.fromMap(snapshot.value)!;
      localObj.key = snapshot.key as String;
      result = localObj;
      break;
    }

    return Resources<T>(status, "", result);
  }

  Future<Resources<List<T>>> getAllByJoin<K extends MapObject<dynamic>>(
      String primaryKey, Dao<Object<dynamic>> mapDao, dynamic mapObj,
      {List<SortOrder>? sortOrderList, Status status = Status.SUCCESS}) async {
    final Resources<List<Object<dynamic>>> dataList = await mapDao.getAll(
        finder: Finder(sortOrders: <SortOrder>[SortOrder("sorting")]));

    final List<String> valueList =
        mapObj.getIdList(dataList.data) as List<String>;

    final Finder finder = Finder(
        filter: Filter.inList(primaryKey, valueList),
        sortOrders: [SortOrder(Field.key)]);
    if (sortOrderList != null && sortOrderList.isNotEmpty) {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];

    // sorting
    for (final String id in valueList) {
      for (final dynamic snapshot in recordSnapshots) {
        if (snapshot.value[primaryKey] == id) {
          resultList.add(obj!.fromMap(snapshot.value)!);
          break;
        }
      }
    }

    return Resources<List<T>>(status, "", resultList);
  }

  Future<Resources<List<T>>>
      getAllDataListWithFilterId<K extends MapObject<dynamic>>(String filterId,
          String filterIdKey, Dao<Object<dynamic>> mapDao, dynamic mapObj,
          {List<SortOrder>? sortOrderList,
          Status status = Status.SUCCESS}) async {
    final Resources<List<Object<dynamic>>> dataList = await mapDao.getAll(
        finder: Finder(sortOrders: <SortOrder>[
      SortOrder("sorting"),
    ]));

    final List<String> valueList =
        mapObj.getIdList(dataList.data) as List<String>;
    //  code close

    final Finder finder = Finder(
      filter: Filter.inList(filterIdKey, valueList),
    );
    if (sortOrderList != null && sortOrderList.isNotEmpty) {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];

    // sorting
    for (final String id in valueList) {
      for (final dynamic snapshot in recordSnapshots) {
        if (snapshot.value["id"] == id) {
          resultList.add(obj!.fromMap(snapshot.value)!);
          break;
        }
      }
    }

    return Resources<List<T>>(status, "", resultList);
  }

  Future<Resources<List<T>>>
      getAllDataListWithFilterValue<K extends MapObject<dynamic>>(
          String filterId,
          String filterIdKey,
          Dao<Object<dynamic>> mapDao,
          dynamic mapObj,
          {List<SortOrder>? sortOrderList,
          Status status = Status.SUCCESS}) async {
    final Resources<List<Object<dynamic>>> dataList = await mapDao.getAll(
        finder: Finder(sortOrders: <SortOrder>[
      SortOrder("sorting"),
    ]));

    final List<String> valueList = mapObj.getIdByKeyValue(
        dataList.data, filterIdKey, filterId) as List<String>;
    //  code close
    final Finder finder = Finder(
        filter: Filter.inList("id", valueList),
        sortOrders: [SortOrder(Field.key)]);

    if (sortOrderList != null && sortOrderList.isNotEmpty) {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );
    final List<T> resultList = <T>[];
    // sorting
    for (final String id in valueList) {
      for (final dynamic snapshot in recordSnapshots) {
        if (snapshot.value["id"] == id) {
          resultList.add(obj!.fromMap(snapshot.value)!);
          break;
        }
      }
    }

    return Resources<List<T>>(status, "", resultList);
  }

  Future<Resources<List<T>>> getAllByMap<K extends MapObject<dynamic>>(
      String primaryKey,
      String mapKey,
      String paramKey,
      Dao<Object<dynamic>> mapDao,
      dynamic mapObj,
      {List<SortOrder>? sortOrderList,
      Status status = Status.SUCCESS}) async {
    final Resources<List<Object<dynamic>>> dataList = await mapDao.getAll(
        finder: Finder(
            filter: Filter.equals(mapKey, paramKey),
            sortOrders: <SortOrder>[SortOrder("sorting")]));

    final List<String> valueList =
        mapObj.getIdList(dataList.data) as List<String>;

    final Finder finder = Finder(
        filter: Filter.inList(primaryKey, valueList),
        sortOrders: [SortOrder(Field.key)]);
    if (sortOrderList != null && sortOrderList.isNotEmpty) {
      finder.sortOrders = sortOrderList;
    }

    final dynamic recordSnapshots = await dao!.find(
      await db,
      finder: finder,
    );

    final List<T> resultList = <T>[];

    // sorting
    for (final String id in valueList) {
      for (final dynamic snapshot in recordSnapshots) {
        if (snapshot.value[primaryKey] == id) {
          resultList.add(obj!.fromMap(snapshot.value)!);
          break;
        }
      }
    }
    return Resources<List<T>>(status, "", resultList);
  }
}
