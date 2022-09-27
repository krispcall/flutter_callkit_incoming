import "dart:async";

import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/provider/common/ps_provider.dart";
import "package:mvp/repository/MacrosRepository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";
import "package:mvp/viewObject/model/macros/addMacros/AddMacrosResponse.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";
import "package:mvp/viewObject/model/macros/removeMacros/RemoveMacros.dart";

class MacrosProvider extends Provider {
  MacrosProvider(
      {required MacrosRepository repository,
        this.valueHolder,
        int limit = 0})
      : super(repository, limit) {
    _repository = repository;
    isDispose = false;

    streamControllerMacros = StreamController<Resources<List<Macro>>>.broadcast();
    subscriptionMacros =
        streamControllerMacros!.stream.listen((Resources<List<Macro>> value) {
          _macros = value;
          if (!isDispose) {
            notifyListeners();
          }
        });
  }

  MacrosRepository? _repository;
  ValueHolder? valueHolder;

  Resources<List<Macro>>? _macros = Resources<List<Macro>>(Status.NO_ACTION, "", null);
  Resources<List<Macro>>? get macros => _macros;
  StreamController<Resources<List<Macro>>>? streamControllerMacros;
  StreamSubscription<Resources<List<Macro>>>? subscriptionMacros;



  @override
  void dispose() {
    isDispose = true;
    streamControllerMacros!.close();
    subscriptionMacros!.cancel();
    super.dispose();
  }

  Future<void> getMacros() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
        _repository!.getMacros(
         streamControllerMacros!,
         isConnectedToInternet,
         Status.PROGRESS_LOADING,
       );
  }

  Future<Resources<AddMacrosResponse>> addMacros(Map<String,dynamic> param) async{
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  _repository!.doAddMacrosApiCall(param, isConnectedToInternet);
  }


  Future<Resources<RemoveMacros>> removeMacros(Map<String,dynamic> param) async{
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return  _repository!.removeMacros(param, isConnectedToInternet);
  }

  void searchMacrosFromList(String query) {
    _repository!.searchMacros(
        query,
      streamControllerMacros!
    );
  }

}
