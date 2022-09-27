import "package:graphql/client.dart";
import "package:http/http.dart" as http;
import "package:mvp/PSApp.dart";
import "package:mvp/api/LoggerHttpClient.dart";
import "package:mvp/utils/Utils.dart";

class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
    // Config.liveUrl,
    PSApp.config!.liveUrl!,
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        PSApp.config!.liveUrl!,
      ),
    );
  }

  GraphQLClient clientToQueryWithToken(String token) {
    Utils.cPrint("JWT $token");

    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        PSApp.config!.liveUrl!,
        defaultHeaders: <String, String>{
          "Authorization": "JWT $token",
        },
        httpClient: LoggerHttpClient(http.Client()),
      ),
    );
  }

  GraphQLClient clientToQueryWithPlatformType(String type) {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        PSApp.config!.liveUrl!,
        defaultHeaders: <String, String>{
          "platform-type": type,
        },
        httpClient: LoggerHttpClient(http.Client()),
      ),
    );
  }

  //Subscription
  GraphQLClient clientToSubscriptionWithToken(String token) {
    GraphQLClient graphQLClient;
    final WebSocketLink webSocketLink = WebSocketLink(
      PSApp.config!.appSubscriptionEndpoint!,
      config: SocketClientConfig(
        initialPayload: () {
          return {
            "accessToken": token,
          };
        },
        delayBetweenReconnectionAttempts: const Duration(seconds: 1),
        queryAndMutationTimeout: const Duration(hours: 24),
        inactivityTimeout: const Duration(hours: 24),
      ),
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        return token;
      },
      headerKey: "accessToken",
    );
    Link link = authLink.concat(httpLink);
    link =
        Link.split((request) => request.isSubscription, webSocketLink, link);
    graphQLClient = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
      alwaysRebroadcast: true,
      defaultPolicies: DefaultPolicies(
        subscribe: Policies(
          cacheReread: CacheRereadPolicy.mergeOptimistic,
          error: ErrorPolicy.all,
          fetch: FetchPolicy.cacheAndNetwork,
        ),
      ),
    );
    return graphQLClient;
  }

  ///Subscription Conversation Chat

  GraphQLClient subscribeConversationChat(String token) {
    GraphQLClient graphQLClient;
    final WebSocketLink webSocketLinkMemberChat = WebSocketLink(
      PSApp.config!.appSubscriptionEndpoint!,
      config: SocketClientConfig(
        initialPayload: () {
          return {
            "accessToken": token,
          };
        },
        delayBetweenReconnectionAttempts: const Duration(seconds: 4),
        queryAndMutationTimeout: const Duration(hours: 24),
        inactivityTimeout: const Duration(hours: 24),
      ),
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        return token;
      },
      headerKey: "accessToken",
    );
    Link link = authLink.concat(httpLink);
    link = Link.split(
        (request) => request.isSubscription, webSocketLinkMemberChat, link);
    graphQLClient = GraphQLClient(
      cache: GraphQLCache(
        partialDataPolicy: PartialDataCachePolicy.reject,
      ),
      link: link,
      defaultPolicies: DefaultPolicies(
        subscribe: Policies(
          cacheReread: CacheRereadPolicy.ignoreAll,
          error: ErrorPolicy.all,
          fetch: FetchPolicy.cacheAndNetwork,
        ),
      ),
    );
    return graphQLClient;
  }

  ///Subscription Member Chat

  GraphQLClient subscribeMemberChat(String token) {
    GraphQLClient graphQLClient;
    final WebSocketLink webSocketLinkMemberChat = WebSocketLink(
      PSApp.config!.appSubscriptionEndpoint!,
      config: SocketClientConfig(
        initialPayload: () {
          return {
            "accessToken": token,
          };
        },
        delayBetweenReconnectionAttempts: const Duration(seconds: 4),
        queryAndMutationTimeout: const Duration(hours: 24),
        inactivityTimeout: const Duration(hours: 24),
      ),
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        return token;
      },
      headerKey: "accessToken",
    );
    Link link = authLink.concat(httpLink);
    link = Link.split(
        (request) => request.isSubscription, webSocketLinkMemberChat, link);
    graphQLClient = GraphQLClient(
      cache: GraphQLCache(
        partialDataPolicy: PartialDataCachePolicy.reject,
      ),
      link: link,
      defaultPolicies: DefaultPolicies(
        subscribe: Policies(
          cacheReread: CacheRereadPolicy.ignoreAll,
          error: ErrorPolicy.all,
          fetch: FetchPolicy.cacheAndNetwork,
        ),
      ),
    );
    return graphQLClient;
  }

  ///Subscription Member Chat Detail
  ///
  GraphQLClient subscribeMemberChatDetail(String token) {
    GraphQLClient graphQLClient;
    final WebSocketLink webSocketLinkMemberChat = WebSocketLink(
      PSApp.config!.appSubscriptionEndpoint!,
      config: SocketClientConfig(
        initialPayload: () {
          return {
            "accessToken": token,
          };
        },
        delayBetweenReconnectionAttempts: const Duration(seconds: 4),
        queryAndMutationTimeout: const Duration(hours: 24),
        inactivityTimeout: const Duration(hours: 24),
      ),
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        return token;
      },
      headerKey: "accessToken",
    );
    Link link = authLink.concat(httpLink);
    link = Link.split(
        (request) => request.isSubscription, webSocketLinkMemberChat, link);
    graphQLClient = GraphQLClient(
      cache: GraphQLCache(
        partialDataPolicy: PartialDataCachePolicy.reject,
      ),
      link: link,
      defaultPolicies: DefaultPolicies(
        subscribe: Policies(
          cacheReread: CacheRereadPolicy.ignoreAll,
          error: ErrorPolicy.all,
          fetch: FetchPolicy.cacheAndNetwork,
        ),
      ),
    );
    return graphQLClient;
  }
}
