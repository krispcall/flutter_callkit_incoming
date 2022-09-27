import "dart:async";

import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/macros/addMacros/AddMacrosResponse.dart";
import "package:mvp/viewObject/model/macros/list/Macro.dart";
import "package:mvp/viewObject/model/macros/list/MacrosResponse.dart";
import "package:mvp/viewObject/model/macros/removeMacros/RemoveMacros.dart";

class MacrosRepository extends Repository {
  MacrosRepository({
    required ApiService service,
  }) {
    apiService = service;
  }

  ApiService? apiService;
  List<Macro> macrosList = [];

  Future<void> getMacros(
      StreamController<Resources<List<Macro>>> streamControllerMacros,
      bool isConnectedToInternet,
      Status progressLoading) async {
    final Resources<MacrosResponse> resource = await apiService!.getMacros();
    macrosList = [];
    if (resource.status == Status.SUCCESS) {
      if (resource.data != null &&
          resource.data!.macros != null &&
          resource.data!.macros!.data != null) {
        macrosList = resource.data!.macros!.data!;
      }
      _sinkMacorsStream(
          streamControllerMacros, Resources(Status.SUCCESS, "", macrosList));
    } else {
      _sinkMacorsStream(
          streamControllerMacros, Resources(Status.SUCCESS, "", macrosList));
    }
  }

  Future<Resources<AddMacrosResponse>> doAddMacrosApiCall(
    Map<String, dynamic> param,
    bool isConnectedToInternet,
  ) async {
    if (isConnectedToInternet) {
      final Resources<AddMacrosResponse> resource =
          await apiService!.doAddMacrosApiCall(param);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.addMacros != null) {
          if (resource.data!.addMacros!.error == null) {
            return Resources(Status.SUCCESS, "", resource.data);
          } else {
            return Resources(
                Status.ERROR, resource.data!.addMacros!.error!.message, null);
          }
        } else {
          return Resources(Status.ERROR, Utils.getString("serverError"), null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  Future<Resources<RemoveMacros>> removeMacros(
    Map<String, dynamic> param,
    bool isConnectedToInternet,
  ) async {
    if (isConnectedToInternet) {
      final Resources<RemoveMacros> resource =
          await apiService!.doRemoveMacros(param);
      if (resource.status == Status.SUCCESS) {
        if (resource.data!.removeMacros!.error == null) {
          return Resources(Status.SUCCESS, "", resource.data);
        } else {
          return Resources(
              Status.ERROR, resource.data!.removeMacros!.error!.message, null);
        }
      } else {
        return Resources(Status.ERROR, Utils.getString("serverError"), null);
      }
    } else {
      return Resources(Status.ERROR, Utils.getString("noInternet"), null);
    }
  }

  void searchMacros(String query,
      StreamController<Resources<List<Macro>>> streamControllerMacros) {
    print(query);
    try {
      _sinkMacorsStream(
          streamControllerMacros,
          Resources(
              Status.SUCCESS,
              "",
              macrosList
                  .where((e) =>
                      e.title!.toLowerCase().contains(query.toLowerCase()) ||
                      e.message!.toLowerCase().contains(query.toLowerCase()))
                  .toList()));
    } catch (e) {
      print(e);
    }
  }

  void _sinkMacorsStream(
      StreamController<Resources<List<Macro>>> streamControllerMacros,
      Resources<List<Macro>> resources) {
    if (!streamControllerMacros.isClosed) {
      streamControllerMacros.sink.add(resources);
    }
  }
}
