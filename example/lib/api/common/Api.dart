import "dart:async";
import "dart:convert";

import "package:graphql/client.dart";
import "package:mvp/PSApp.dart";
import "package:mvp/RollbarConstant.dart";
import "package:mvp/api/common/Resources.dart";
import "package:mvp/api/common/Status.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/graph_ql/GraphQLConfiguration.dart";
import "package:mvp/provider/user/UserProvider.dart";
import "package:mvp/repository/UserRepository.dart";
import "package:mvp/utils/PsProgressDialog.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/common/Object.dart";
import "package:mvp/viewObject/common/ValueHolder.dart";

abstract class Api {
  Future<Resources<R>>
      doServerCallQueryWithoutAuth<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQuery();
    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
    });

    Utils.cPrint("doServerCallQueryWithoutAuth result${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>> doServerCallQueryWithAuth<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQueryWithToken(
        PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_API_TOKEN)!);

    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
    });

    print("Result ${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        Utils.cPrint(hashMap.toString());
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });

          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallQueryWithCallAccessTokenParam<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String accessToken,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQueryWithToken(
      accessToken,
    );

    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
    });

    print("Result ${result.data}");

    if (!result.hasException) {
      if (result.data != null) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallQueryWithCallAccessToken<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQueryWithToken(
      PsSharedPreferences.instance!.shared!
          .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!,
    );

    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
      // throw Exception;
    });

    print("Result ${result.data}");

    if (!result.hasException) {
      if (result.data != null) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallQueryWithCallAccessToken2<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String callAccessToken,
    String queryKey,
  ) async {
    final GraphQLClient client =
        GraphQLConfiguration().clientToQueryWithToken(callAccessToken);

    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
      // throw Exception;
    });

    Utils.cPrint("doServerCallQueryWithCallAccessToken2 result${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallQueryWithAuthQueryAndVariable<T extends Object<dynamic>, R>(
    T obj,
    String document,
    Map<String, dynamic> variable,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQueryWithToken(
        PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!);
    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        variables: variable,
        pollInterval: const Duration(seconds: 5),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.uploadTimeOut), onTimeout: () {
      return timeoutError(document, variable, queryKey);
    });

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
            variable: variable,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          variable: variable,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallMutationWithoutAuth<T extends Object<dynamic>, R>(
    T obj,
    Map<String, dynamic> variable,
    String document,
    String queryKey,
  ) async {
    final QueryResult result = await GraphQLConfiguration()
        .clientToQuery()
        .mutate(
          MutationOptions(
            document: gql(document),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
          ),
        )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, variable, queryKey);
      // throw Exception;
    });

    Utils.cPrint("doServerCallMutationWithoutAuth result${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
            variable: variable,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          variable: variable,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallMutationWithoutPlatformType<T extends Object<dynamic>, R>(
    T obj,
    Map<String, dynamic> variable,
    String document,
    String type,
    String queryKey,
  ) async {
    final QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithPlatformType(type)
        .mutate(
          MutationOptions(
            document: gql(document),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
          ),
        )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, variable, queryKey);
      // throw Exception;
    });

    Utils.cPrint(
        "doServerCallMutationWithoutPlatformType result${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
            variable: variable,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          variable: variable,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallMutationWithApiAuth<T extends Object<dynamic>, R>(
    T obj,
    Map<String, dynamic> variable,
    String document,
    String queryKey,
  ) async {
    final QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_API_TOKEN)!)
        .mutate(
          MutationOptions(
            document: gql(document),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
          ),
        )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, variable, queryKey);
      // throw Exception;
    });

    Utils.cPrint("doServerCallMutationWithApiAuth param $variable");
    Utils.cPrint("doServerCallMutationWithApiAuth result ${result.toString()}");
    Utils.cPrint("doServerCallMutationWithApiAuth result ${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
            variable: variable,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          variable: variable,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources<R>>
      doServerCallMutationWithAuth<T extends Object<dynamic>, R>(
    T obj,
    Map<String, dynamic> variable,
    String document,
    String queryKey,
  ) async {
    Utils.cPrint(variable.toString());
    final QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .mutate(
          MutationOptions(
            document: gql(document),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
          ),
        )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, variable, queryKey);
    });

    Utils.cPrint(result.data.toString());
    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
            variable: variable,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          variable: variable,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Resources> mServerCallMutationWithAuth(
    Map<String, dynamic> variable,
    String document,
    String queryKey,
  ) async {
    final QueryResult result = await GraphQLConfiguration()
        .clientToQueryWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .mutate(MutationOptions(
          document: gql(document),
          variables: variable,
          fetchPolicy: FetchPolicy.networkOnly,
          errorPolicy: ErrorPolicy.all,
        ))
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, variable, queryKey);
      // throw Exception;
    });

    Utils.cPrint("mServerCallMutationWithAuth result${result.data}");

    if (result.data != null) {
      final dynamic hashMap = result.data;
      if (hashMap[queryKey]["error"] != null &&
          hashMap[queryKey]["error"].toString().isNotEmpty) {
        await errorHandlingForNormalResponse(
          document,
          result,
          queryKey: queryKey,
          variable: variable,
        );
      }
      return Resources(Status.SUCCESS, "", result.data);
    } else {
      return errorHandling(
        document,
        result,
        variable: variable,
        queryKey: queryKey,
      );
    }
  }

  Future<Stream<QueryResult>>
      doSubscriptionCallLogsApiCall<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> variable, String subscription) async {
    return GraphQLConfiguration()
        .clientToSubscriptionWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Stream<QueryResult>>
      doSubscriptionConversationChatApiCall<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> variable, String subscription) async {
    return GraphQLConfiguration()
        .subscribeConversationChat(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Stream<QueryResult>>
      doSubscriptionOnlineMemberStatusApiCall<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> variable, String subscription) async {
    return GraphQLConfiguration()
        .clientToSubscriptionWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Stream<QueryResult>>
      doSubscriptionUserProfileApiCall<T extends Object<dynamic>, R>(
          T obj, Map<String, dynamic> variable, String subscription) async {
    return GraphQLConfiguration()
        .clientToSubscriptionWithToken(PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!)
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            variables: variable,
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.all,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Stream<QueryResult>>
      doSubscriptionWorkspaceChatApiCall<T extends Object<dynamic>, R>(
          T obj, String subscription) async {
    return GraphQLConfiguration()
        .subscribeMemberChat(
          PsSharedPreferences.instance!.shared!
              .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!,
        )
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.none,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Stream<QueryResult>>
      doSubscriptionWorkspaceChatDetailApiCall<T extends Object<dynamic>, R>(
          T obj, String subscription) async {
    return GraphQLConfiguration()
        .subscribeMemberChatDetail(
          PsSharedPreferences.instance!.shared!
              .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!,
        )
        .subscribe(
          SubscriptionOptions(
            document: gql(subscription),
            fetchPolicy: FetchPolicy.networkOnly,
            errorPolicy: ErrorPolicy.none,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ),
        );
  }

  Future<Resources<R>>
      doServerCallQueryWithRefreshToken<T extends Object<dynamic>, R>(
    T obj,
    String document,
    String queryKey,
  ) async {
    final GraphQLClient client = GraphQLConfiguration().clientToQueryWithToken(
        PsSharedPreferences.instance!.shared!
            .getString(Const.VALUE_HOLDER_REFRESH_TOKEN)!);

    final QueryResult result = await client
        .query(
      QueryOptions(
        document: gql(document),
        pollInterval: const Duration(milliseconds: 1),
        fetchPolicy: FetchPolicy.networkOnly,
        errorPolicy: ErrorPolicy.all,
      ),
    )
        .timeout(const Duration(seconds: Const.apiTimeout), onTimeout: () {
      return timeoutError(document, {}, queryKey);
      // throw Exception;
    });

    print("Result ${result.toString()}");
    print("Result ${result.data}");

    if (result.data != null) {
      if (!result.hasException) {
        final dynamic hashMap = result.data;
        if (hashMap[queryKey]["error"] != null &&
            hashMap[queryKey]["error"].toString().isNotEmpty) {
          await errorHandlingForNormalResponse(
            document,
            result,
            queryKey: queryKey,
          );
        }
        if (hashMap is! Map) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic) as T);
          });
          return Resources<R>(Status.SUCCESS, "", tList as R);
        } else {
          return Resources<R>(Status.SUCCESS, "", obj.fromMap(hashMap) as R);
        }
      } else {
        return errorHandling(
          document,
          result,
          queryKey: queryKey,
        );
      }
    } else {
      return errorHandling(
        document,
        result,
        queryKey: queryKey,
      );
    }
  }
}

Future<Resources<R>> errorHandling<T extends Object<dynamic>, R>(
  String document,
  QueryResult? result, {
  Map<String, dynamic>? variable,
  String? queryKey,
}) async {
  Resources<R> data =
      Resources<R>(Status.ERROR, Utils.getString("serverError"), null);

  if (queryKey == "login" || queryKey == "checkDuplicateLogin") {
    variable!["data"]["details"]["password"] = utf8
        .fuse(base64)
        .encode(variable["data"]["details"]["password"].toString());
  }

  String title = "Graphql Error";
  try {
    if (result!.hasException) {
      print(
          "Ex 1 ${(result.exception!.linkException! is HttpLinkServerException).toString()} 2 ${(result.exception!.linkException! is NetworkException).toString()} 3 ${(result.exception!.linkException! is ServerException).toString()} Ex 4 ${(result.exception!.linkException! is FormatException).toString()}");

      print(
          "Ex 5 ${(result.exception!.linkException! is HttpLinkParserException).toString()}");
      print(
          "Ex 6 ${(result.exception!.linkException! is TimeoutException).toString()}");
      print(
          "Ex 7 ${(result.exception!.linkException! is PartialDataException).toString()}");
      print(
          "Ex 8 ${(result.exception!.linkException! is ResponseFormatException).toString()}");

      print(
          "Ex 9 ${(result.exception!.linkException! is UnknownException).toString()}");
      print(
          "Ex 10 ${(result.exception!.linkException! is OperationException).toString()}");
      if (result.exception!.linkException != null &&
          result.exception!.linkException is HttpLinkServerException) {
        final dynamic hashMap = result.exception!.linkException;
        final HttpLinkServerException ex = hashMap as HttpLinkServerException;
        final String status = ex.parsedResponse!.response["status"].toString();
        final String errorKey =
            ex.parsedResponse!.response["error"]["error_key"].toString();
        final String errorMessage =
            ex.parsedResponse!.response["error"]["message"].toString();
        if (status.isNotEmpty &&
            status == "401" &&
            ((errorKey.isNotEmpty &&
                    errorKey.toLowerCase() == "token_expired") ||
                (errorMessage.isNotEmpty &&
                    errorMessage.toLowerCase() == "token expired"))) {
          data = Resources<R>(Status.ERROR, errorMessage, null);

          final UserProvider up = UserProvider(
              userRepository: UserRepository(), valueHolder: ValueHolder());

          voiceClient.disConnect();
          PsProgressDialog.dismissDialog();
          Utils.showToastMessage("Session Expired. Please login to continue");
          await up.onLogout(isTokenError: true);
        }
      } else if (result.exception!.linkException != null &&
          result.exception!.linkException is NetworkException) {
        title = "Network Error";
        data = Resources<R>(Status.ERROR, Utils.getString("serverError"), null);
      } else if (result.exception!.linkException != null &&
          result.exception!.linkException is ServerException) {
        title = "ServerException";
        data = Resources<R>(
            Status.SERVER_EXCEPTION, Utils.getString("serverError"), null);
      } else {
        data = Resources<R>(Status.ERROR, "", null);
      }
    } else {
      data = Resources<R>(Status.ERROR, Utils.getString("serverError"), null);
    }
  } catch (e) {
    data = Resources<R>(Status.ERROR, Utils.getString("serverError"), null);
  }

  try {
    if (result!.exception!.linkException!.originalException
            .toString()
            .toLowerCase() ==
        "Timeout".toLowerCase()) {
      data = Resources<R>(Status.TIMEOUT, "", null);
    }
  } catch (e) {
    data = Resources<R>(Status.SERVER_EXCEPTION, "Not Found", null);
  }

  try {
    if (variable!.isNotEmpty) {
      Utils.logRollBar(RollbarConstant.ERROR,
          "$title: $result \n\nVariable: \n$variable \n\nMutation: \n$document");
    } else {
      Utils.logRollBar(
          RollbarConstant.ERROR, "$title: $result \n\nMutation: \n$document");
    }
  } catch (e) {
    Utils.logRollBar(
        RollbarConstant.ERROR, "$title: $result \n\nMutation: \n$document");
  }
  return data;
}

QueryResult timeoutError(
    String document, Map<String, dynamic> variable, String queryKey) {
  if (queryKey == "login" || queryKey == "checkDuplicateLogin") {
    variable["data"]["details"]["password"] = utf8
        .fuse(base64)
        .encode(variable["data"]["details"]["password"].toString());
  }

  Utils.cPrint("Time Out $document");
  Utils.showToastMessage("Request Timeout");
  Utils.logRollBar(RollbarConstant.ERROR,
      "Request Timeout:-\n $document \nRequestData:-\n $variable");

  return QueryResult(
    source: QueryResultSource.network,
    exception: OperationException(
      linkException: const ServerException(originalException: "Timeout"),
      graphqlErrors: [
        const GraphQLError(message: "Timeout"),
      ],
    ),
    options: MutationOptions(
      document: gql(document),
      fetchPolicy: FetchPolicy.networkOnly,
      errorPolicy: ErrorPolicy.all,
    ),
  );
}

Future<void> errorHandlingForNormalResponse<T extends Object<dynamic>, R>(
  String document,
  QueryResult? result, {
  Map<String, dynamic>? variable,
  String? queryKey,
}) async {
  /// Log Error other than 200 range but proper response

  if (variable != null && variable.isNotEmpty) {
    Utils.logRollBar(RollbarConstant.ERROR,
        "Graphql Error: $result \n\nVariable: \n$variable \n\nMutation: \n$document");
  } else {
    Utils.logRollBar(RollbarConstant.ERROR,
        "Graphql Error: $result \n\nMutation: \n$document ");
  }

  /// Log Error other than 200 range but proper response
  final String status = result!.data![queryKey]["status"].toString();
  final String errorKey =
      result.data![queryKey]["error"]["errorKey"].toString();
  final String errorMessage =
      result.data![queryKey]["error"]["message"].toString();
  if (status.isNotEmpty &&
      status == "401" &&
      ((errorKey.isNotEmpty && errorKey.toLowerCase() == "token_expired") ||
          (errorMessage.isNotEmpty &&
              errorMessage.toLowerCase() == "token expired"))) {
    final UserProvider up = UserProvider(
        userRepository: UserRepository(), valueHolder: ValueHolder());

    voiceClient.disConnect();
    PsProgressDialog.dismissDialog();
    Utils.showToastMessage("Session Expired. Please login to continue");
    await up.onLogout(isTokenError: true);
  }
}
