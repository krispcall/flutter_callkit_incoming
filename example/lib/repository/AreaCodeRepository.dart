import "package:flutter/cupertino.dart";
import "package:mvp/api/ApiService.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/db/StateCodeDao.dart";
import "package:mvp/repository/Common/Respository.dart";
import "package:mvp/viewObject/model/stateCode/StateCodeResponse.dart";

class AreaCodeRepository extends Repository {
  AreaCodeRepository(
      {@required ApiService? service, @required StateCodeDao? codeDao}) {
    apiService = service;
    stateCodeDao = codeDao;
  }

  ApiService? apiService;
  StateCodeDao? stateCodeDao;

  Future<Resources<AreaCode>> getAllAreaCodes(
      bool isConnectedToInternet, Status? isLoading) async {
    {
      if (isConnectedToInternet) {
        final Resources<AreaCode> resource =
            await apiService!.getAllAreaCodes();
        if (resource.status == Status.SUCCESS) {
          if (resource.data!.stateCodeResponse!.error == null) {
            await stateCodeDao!.deleteAll();
            await stateCodeDao!
                .insertAll("", resource.data!.stateCodeResponse!.stateCodes);
            return Resources(Status.SUCCESS, "", resource.data);
          } else {
            final Resources<List<StateCodes>> dump =
                await stateCodeDao!.getAll();
            return Resources(
              Status.SUCCESS,
              "",
              AreaCode(
                stateCodeResponse: StateCodeResponse(
                  status: 200,
                  stateCodes: dump.data,
                ),
              ),
            );
          }
        } else {
          final Resources<List<StateCodes>> dump = await stateCodeDao!.getAll();
          return Resources(
            Status.SUCCESS,
            "",
            AreaCode(
              stateCodeResponse: StateCodeResponse(
                status: 200,
                stateCodes: dump.data,
              ),
            ),
          );
        }
      } else {
        final Resources<List<StateCodes>> dump = await stateCodeDao!.getAll();
        return Resources(
          Status.SUCCESS,
          "",
          AreaCode(
            stateCodeResponse: StateCodeResponse(
              status: 200,
              stateCodes: dump.data,
            ),
          ),
        );
      }
    }
  }
}
