/*
 * *
 *  * Created by Kedar on 7/8/21 10:57 AM
 *  * Copyright (c) 2021 . All rights reserved.
 *  * Last modified 6/29/21 7:52 AM
 *
 */

import "dart:async";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/MyNumberRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/numbers/Numbers.dart";

class MyNumberProvider extends Provider {
  MyNumberProvider({
    required this.myNumberRepository,
    int limit = 20,
  }) : super(myNumberRepository!, limit) {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    streamControllerNumbers =
        StreamController<Resources<List<Numbers>>>.broadcast();

    subscriptionNumbers = streamControllerNumbers!.stream
        .listen((Resources<List<Numbers>> resource) {
      if (resource.status != Status.BLOCK_LOADING &&
          resource.status != Status.PROGRESS_LOADING) {
        _numbers = resource;
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  MyNumberRepository? myNumberRepository;
  ValueHolder? valueHolder;

  StreamController<Resources<List<Numbers>>>? streamControllerNumbers;
  StreamSubscription<Resources<List<Numbers>>>? subscriptionNumbers;

  Resources<List<Numbers>> _numbers =
      Resources<List<Numbers>>(Status.NO_ACTION, "", null);

  Resources<List<Numbers>>? get numbers => _numbers;
  bool? _isNumberExist = false;
  bool? get isNumberExist => _isNumberExist;

  @override
  void dispose() {
    subscriptionNumbers!.cancel();
    streamControllerNumbers!.close();
    isDispose = true;
    _isNumberExist = false;
    super.dispose();
  }

  Future<dynamic> doGetMyNumbersListApiCall() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    final Resources<List<Numbers>> resource =
        await myNumberRepository!.doGetMyNumbersListApiCall(
            limit, isConnectedToInternet, Status.PROGRESS_LOADING);
    _sinkNumberStream(streamControllerNumbers!, resource);
    if (resource.data!.isNotEmpty) {
      _isNumberExist = true;
    }
    return resource;
  }

  Future<void> doDbNumbersSearch(String text) async {
    final Resources<List<Numbers>> resource =
        await myNumberRepository!.doSearchMyNumbersLocally(text);
    _sinkNumberStream(streamControllerNumbers!, resource);
  }

  void _sinkNumberStream(
      StreamController<Resources<List<Numbers>>> streamControllerNumbers,
      Resources<List<Numbers>> resources) {
    if (!streamControllerNumbers.isClosed) {
      streamControllerNumbers.sink.add(resources);
    }
  }
}
