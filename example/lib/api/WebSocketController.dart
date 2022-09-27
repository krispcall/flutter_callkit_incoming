import "dart:async";
import "dart:convert";

import "package:mvp/PSApp.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:web_socket_channel/io.dart";

class WebSocketController {
  static final WebSocketController _singleton = WebSocketController._internal();

  StreamController<String>? streamController =
      StreamController.broadcast(sync: true);

  String? wsUrl = PSApp.config!.appSubscriptionEndpoint;
  String? token = "";

  IOWebSocketChannel? channel;
  Timer? timer;
  Timer? timerMemberSocket;

  factory WebSocketController() {
    return _singleton;
  }

  WebSocketController._internal() {
    initWebSocketConnection();
  }

  Future<void> initWebSocketConnection() async {
    token = PsSharedPreferences.instance!.shared!
        .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN);
    if (token != null) {
      if (token!.isNotEmpty) {
        channel = await connectWs() as IOWebSocketChannel;
        initDataSend();
        broadcastNotifications();
      }
    }
  }

  void broadcastNotifications() {
    channel!.stream.listen((streamData) {
      streamController!.add(streamData as String);
    }, onDone: () {
      timerMemberSocket?.cancel();
      // initWebSocketConnection();
    }, onError: (e) {
      initWebSocketConnection();
    });
  }

  void send({String? sendScreen}) {
    try {
      token = PsSharedPreferences.instance!.shared!
          .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!;
      final bool onlineConnection = PsSharedPreferences.instance!.shared!
          .getBool(Const.VALUE_HOLDER_MEMBER_ONLINE_STATUS)!;
      final bool stayOnline = PsSharedPreferences.instance!.shared!
          .getBool(Const.VALUE_HOLDER_USER_ONLINE_STATUS)!;
      // if (onlineConnection != false && stayOnline != false) {
      if (stayOnline) {
        final Map pingData = {
          "id": "_id",
          "type": "ping",
          "payload": {
            "source": "mobile",
            "timestamp": "${DateTime.now().millisecondsSinceEpoch}",
            "stayOnline": stayOnline,
            "onlineConnection": onlineConnection,
            "accessToken":
                onlineConnection ? "" : token
          }
        };

        channel!.sink.add(json.encode(pingData));
      }
      // }
    } catch (e) {}
  }

  Future<void> initDataSend() async {
    token = PsSharedPreferences.instance!.shared!
        .getString(Const.VALUE_HOLDER_CALL_ACCESS_TOKEN)!;
    final Map initConnection = {
      "type": "connection_init",
      "payload": {
        "accessToken": token,
      }
    };
    channel!.sink.add(json.encode(initConnection));
  }

  void sendData(String sendScreen) {
    timerMemberSocket = Timer.periodic(const Duration(seconds: 20), (timer) {
      send(sendScreen: sendScreen);
    });
  }

  void onClose() {
    timerMemberSocket?.cancel();
    timer?.cancel();
    channel?.sink.close();
  }

  Future connectWs() async {
    try {
      return IOWebSocketChannel.connect(wsUrl!);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 20000));
      return connectWs();
    }
  }
}
