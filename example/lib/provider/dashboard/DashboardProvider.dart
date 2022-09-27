import "dart:async";

import "package:flutter/cupertino.dart";
import "package:graphql/client.dart";
import "package:mvp/constant/Constants.dart";
import "package:mvp/db/common/ps_shared_preferences.dart";
import "package:mvp/ui/dashboard/DashboardView.dart";
import "package:mvp/utils/Utils.dart";
import "package:mvp/viewObject/model/country/CountryCode.dart";
import "package:mvp/viewObject/model/notification/NotificationMessage.dart";

class DashboardProvider extends ChangeNotifier {
  String _conversationId = "";
  String _conversationSid = "";

  bool _isTransfer = false;
  bool _afterTransfer = false;
  String _channelId = "";
  bool _autoRecord = false;
  String _channelNumber = "";
  String _channelName = "";
  String _outgoingNumber = "";
  String _outgoingName = "";
  String _outgoingId = "";
  String _outgoingProfilePicture = "";
  bool _incomingIsCallConnected = false;
  bool _outgoingIsCallConnected = false;
  bool _isRecord = false;
  StreamSubscription<QueryResult>? _subscription;
  CountryCode? _selectedCountryCode;

  int _secondsPassedOutgoing = 0;
  int _secondsOutgoing = 0;
  int _minutesOutgoing = 0;
  Timer? _timerOutgoing;
  final Duration _duration = const Duration(seconds: 1);

  int _secondsPassedOutgoingRecord = 0;
  int _secondsOutgoingRecord = 0;
  int _minutesOutgoingRecord = 0;

  Timer? _timerOutgoingRecord;

  int _secondsPassedIncomingRecord = 0;
  int _secondsIncomingRecord = 0;
  int _minutesIncomingRecord = 0;

  Timer? _timerIncomingRecord;

  int _secondsPassedIncoming = 0;
  int _secondsIncoming = 0;
  int _minutesIncoming = 0;

  Timer? _timerIncoming;

  bool _outgoingIsSpeakerOn = false;
  bool _outgoingIsMuted = false;
  String _outgoingDigits = "";
  bool _outgoingIsOnHold = false;

  bool _incomingIsSpeakerOn = false;
  bool _incomingIsMuted = false;
  String _incomingDigits = "";
  bool _incomingIsOnHold = false;
  Map<String, dynamic> _areaCode = {};

  NotificationMessage _notificationMessage = NotificationMessage();

  /// Incoming notificationMessage getter setter
  NotificationMessage get notificationMessage => _notificationMessage;

  set notificationMessage(NotificationMessage data) {
    _notificationMessage = data;
    notifyListeners();
  }

  //Area code
  Map<String, dynamic> get areaCode => _areaCode;

  set areaCode(Map<String, dynamic> data) {
    _areaCode = data;
    notifyListeners();
  }

  /// outgoing is on hold getter setter
  int get secondsPassedOutgoing => _secondsPassedOutgoing;

  set secondsPassedOutgoing(int data) {
    _secondsPassedOutgoing = data;
    notifyListeners();
  }

  /// selected country code
  CountryCode? get selectedCountryCode => _selectedCountryCode;

  set selectedCountryCode(CountryCode? data) {
    _selectedCountryCode = data;
    notifyListeners();
  }

  /// Incoming is muted getter setter
  bool get incomingIsSpeakerOn => _incomingIsSpeakerOn;

  set incomingIsSpeakerOn(bool data) {
    _incomingIsSpeakerOn = data;
    notifyListeners();
  }

  /// Incoming is muted getter setter
  bool get incomingIsMuted => _incomingIsMuted;

  set incomingIsMuted(bool data) {
    _incomingIsMuted = data;
    notifyListeners();
  }

  /// Incoming digits getter setter
  String get incomingDigits => _incomingDigits;

  set incomingDigits(String data) {
    _incomingDigits = data;
    notifyListeners();
  }

  /// Incoming is on hold getter setter
  bool get incomingIsOnHold => _incomingIsOnHold;

  set incomingIsOnHold(bool data) {
    _incomingIsOnHold = data;
    notifyListeners();
  }

  /// outgoing is on hold getter setter
  bool get outgoingIsOnHold => _outgoingIsOnHold;

  set outgoingIsOnHold(bool data) {
    _outgoingIsOnHold = data;
    notifyListeners();
  }

  /// outgoing is muted getter setter
  bool get outgoingIsMuted => _outgoingIsMuted;

  set outgoingIsMuted(bool data) {
    _outgoingIsMuted = data;
    notifyListeners();
  }

  /// Speaker getter setter

  bool get outgoingSpeaker => _outgoingIsSpeakerOn;

  set outgoingSpeaker(bool data) {
    _outgoingIsSpeakerOn = data;
    notifyListeners();
  }

  /// Speaker getter setter

  String get outgoingDigits => _outgoingDigits;

  set outgoingDigits(String data) {
    _outgoingDigits = data;
    notifyListeners();
  }

  /////////////////ConversationId////////////////

  String get conversationId => _conversationId;

  set conversationId(String data) {
    _conversationId = data;
    notifyListeners();
  }

  /////////////////ConversationSid////////////////

  String get conversationSid => _conversationSid;

  set conversationSid(String data) {
    _conversationSid = data;
    notifyListeners();
  }

  //////////////////ChannelId/////////////////

  String get channelId => _channelId;

  set channelId(String data) {
    _channelId = data;
    notifyListeners();
  }

  //////////////////isTransfer/////////////////

  bool get isTransfer => _isTransfer;

  set isTransfer(bool data) {
    _isTransfer = data;
    // notifyListeners();
  }

  //////////////////afterTransfer/////////////////

  bool get afterTransfer => _afterTransfer;

  set afterTransfer(bool data) {
    _afterTransfer = data;
    // notifyListeners();
  }

  //////////////////autoRecord/////////////////

  bool get autoRecord => _autoRecord;

  set autoRecord(bool data) {
    _autoRecord = data;
    notifyListeners();
  }

  //////////////////isRecord/////////////////

  bool get isRecord => _isRecord;

  set isRecord(bool data) {
    _isRecord = data;
    notifyListeners();
  }

  //////////////////channelNumber/////////////////

  String get channelNumber => _channelNumber;

  set channelNumber(String data) {
    _channelNumber = data;
  }

  //////////////////channelNumber/////////////////

  String get channelName => _channelName;

  set channelName(String data) {
    _channelName = data;
  }

  //////////////////outgoingNumber/////////////////

  String get outgoingNumber => _outgoingNumber;

  set outgoingNumber(String data) {
    _outgoingNumber = data;
  }

  //////////////////_outgoingName/////////////////

  String get outgoingName => _outgoingName;

  set outgoingName(String data) {
    _outgoingName = data;
  }

  //////////////////outgoingId/////////////////

  String get outgoingId => _outgoingId;

  set outgoingId(String data) {
    _outgoingId = data;
  }

  //////////////////outgoingProfilePicture/////////////////

  String get outgoingProfilePicture => _outgoingProfilePicture;

  set outgoingProfilePicture(String data) {
    _outgoingProfilePicture = data;
  }

  //////////////////incomingIsCallConnected/////////////////

  bool get incomingIsCallConnected => _incomingIsCallConnected;

  set incomingIsCallConnected(bool data) {
    _incomingIsCallConnected = data;
  }

  //////////////////OutIsCallConnected/////////////////

  bool get outgoingIsCallConnected => _outgoingIsCallConnected;

  set outgoingIsCallConnected(bool data) {
    _outgoingIsCallConnected = data;
    notifyListeners();
  }

  //////////////////incomingIsCallConnected/////////////////

  StreamSubscription<QueryResult> get subscription => _subscription!;

  set subscription(StreamSubscription<QueryResult> data) {
    _subscription = data;
    notifyListeners();
  }

  void closeSubscription() {
    _subscription!.cancel();
  }

  void setDefault() {
    _conversationId = "";
    _conversationSid = "";
    _isTransfer = false;
    _afterTransfer = false;
    _channelId = "";
    _autoRecord = false;
    _channelNumber = "";
    _channelName = "";
    _outgoingNumber = "";
    _outgoingName = "";
    _outgoingId = "";
    _outgoingProfilePicture = "";
    _incomingIsCallConnected = false;
    _outgoingIsCallConnected = false;
    _isRecord = false;
    // _subscription.cancel();
  }

  void startOutgoingTimer() {
    if (_timerOutgoing != null) {
      secondsPassedOutgoing = 0;
      _secondsOutgoing = 0;
      _minutesOutgoing = 0;
      _timerOutgoing!.cancel();
    }
    _timerOutgoing = Timer.periodic(_duration, (Timer t) {
      secondsPassedOutgoing = secondsPassedOutgoing + 1;
      _secondsOutgoing = secondsPassedOutgoing % 60;
      _minutesOutgoing = secondsPassedOutgoing ~/ 60 % 60;
      // _outgoingIsCallConnected = true;
      PsSharedPreferences.instance!.shared!
          .setBool(Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, true);
      DashboardView.outgoingEvent.fire({
        "outgoingEvent": "outGoingCallConnected",
        "channelName": "",
        "channelNumber": "",
        "channelFlagUrl": "",
        "outgoingName": "",
        "outgoingNumber": "",
        "outgoingFlagUrl": "",
        "clientId": "",
        "isSpeakerOn": _outgoingIsSpeakerOn,
        "isMicMuted": _outgoingIsMuted,
        "isOnHold": _outgoingIsOnHold,
        "digits": _outgoingDigits,
        "afterTransfer": _afterTransfer,
        "isRinging": false,
        "isConnected": true,
        "isTransfer": _isTransfer,
        "seconds": _secondsOutgoing,
        "minutes": _minutesOutgoing,
        "conversationId": "",
        "state": Utils.getString("connected"),
      });
      if (!outgoingIsCallConnected) {
        _timerOutgoing?.cancel();
      }
    });
  }

  void stopOutgoingTimer() {
    _timerOutgoing?.cancel();
    _secondsOutgoing = 0;
    _minutesOutgoing = 0;
    _outgoingIsCallConnected = false;
    _outgoingIsSpeakerOn = false;
    _outgoingIsMuted = false;
    _outgoingIsOnHold = false;
    _outgoingDigits = "";

    PsSharedPreferences.instance!.shared!
        .setBool(Const.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS, false);
  }

  void resetOutgoingSecondPassed() {
    _secondsPassedOutgoing = 0;
  }

  void startOutgoingRecordTimer() {
    if (_timerOutgoingRecord != null) {
      _secondsPassedOutgoingRecord = 0;
      _secondsOutgoingRecord = 0;
      _minutesOutgoingRecord = 0;
      _timerOutgoingRecord!.cancel();
    }
    _timerOutgoingRecord = Timer.periodic(_duration, (Timer t) {
      _secondsPassedOutgoingRecord = _secondsPassedOutgoingRecord + 1;
      _secondsOutgoingRecord = _secondsPassedOutgoingRecord % 60;
      _minutesOutgoingRecord = _secondsPassedOutgoingRecord ~/ 60 % 60;
      DashboardView.outgoingEventRecording.fire({
        "outgoingEvent": "outGoingCallRecording",
        "seconds": _secondsOutgoingRecord,
        "minutes": _minutesOutgoingRecord,
      });
    });

    if (!outgoingIsCallConnected && !_autoRecord) {
      _timerOutgoingRecord?.cancel();
    }
  }

  void resumeOutgoingRecordTimer() {
    _timerOutgoingRecord = Timer.periodic(_duration, (Timer t) {
      _secondsPassedOutgoingRecord = _secondsPassedOutgoingRecord + 1;
      _secondsOutgoingRecord = _secondsPassedOutgoingRecord % 60;
      _minutesOutgoingRecord = _secondsPassedOutgoingRecord ~/ 60 % 60;
      DashboardView.outgoingEventRecording.fire({
        "outgoingEvent": "outGoingCallRecording",
        "seconds": _secondsOutgoingRecord,
        "minutes": _minutesOutgoingRecord,
      });
    });

    if (!outgoingIsCallConnected && !_autoRecord) {
      _timerOutgoingRecord?.cancel();
    }
  }

  void stopOutgoingRecordTimer() {
    _timerOutgoingRecord?.cancel();
    _secondsPassedOutgoingRecord = 0;
    _secondsOutgoingRecord = 0;
    _minutesOutgoingRecord = 0;
  }

  void pauseOutgoingRecordTimer() {
    Utils.cPrint("Pause Outgoing Timer");
    _timerOutgoingRecord?.cancel();
  }

  void startIncomingTimer() {
    if (_timerIncoming != null) {
      _secondsPassedIncoming = 0;
      _secondsIncoming = 0;
      _minutesIncoming = 0;
      _timerIncoming?.cancel();
    }
    _timerIncoming = Timer.periodic(_duration, (Timer t) {
      Utils.getSharedPreference().then((psSharePref) async {
        await psSharePref.reload();
        _secondsPassedIncoming = _secondsPassedIncoming + 1;
        _secondsIncoming = _secondsPassedIncoming % 60;
        _minutesIncoming = _secondsPassedIncoming ~/ 60 % 60;
        // _incomingIsCallConnected = true;
        psSharePref.setBool(
            Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, true);
      });
      // Utils.cPrint("this is incoming connected ");
      DashboardView.incomingEvent.fire({
        "incomingEvent": "incomingConnected",
        "channelName": "",
        "channelNumber": "",
        "channelFlagUrl": "",
        "outgoingName": "",
        "outgoingNumber": "",
        "outgoingFlagUrl": "",
        "clientId": "",
        "isSpeakerOn": _incomingIsSpeakerOn,
        "digits": _incomingDigits,
        "isMicMuted": _incomingIsMuted,
        "isOnHold": _incomingIsOnHold,
        // "isSpeakerOn": incomingIsSpeakerOn,
        // "isMicMuted": incomingIsMuted,
        "afterTransfer": _afterTransfer,
        "isTransfer": _isTransfer,
        "isRinging": false,
        "isConnected": true,
        "seconds": _secondsIncoming,
        "minutes": _minutesIncoming,
        "conversationId": "",
        "state": Utils.getString("connected")
      });
      if (!incomingIsCallConnected) {
        _timerIncoming!.cancel();
      }
    });
  }

  void stopIncomingTimer() {
    _timerIncoming?.cancel();
    _secondsPassedIncoming = 0;
    _secondsIncoming = 0;
    _minutesIncoming = 0;
    _incomingIsCallConnected = false;
    _incomingIsOnHold = false;
    _incomingDigits = "";
    _incomingIsMuted = false;
    _incomingIsSpeakerOn = false;

    PsSharedPreferences.instance!.shared!
        .setBool(Const.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS, false);
  }

  void resetIncomingSecondPassed() {
    _secondsPassedIncoming = 0;
  }

  void startIncomingRecordTimer() {
    if (_timerIncomingRecord != null) {
      _secondsPassedIncomingRecord = 0;
      _secondsIncomingRecord = 0;
      _minutesIncomingRecord = 0;
      _timerIncomingRecord?.cancel();
    }
    _timerIncomingRecord = Timer.periodic(_duration, (Timer t) {
      _secondsPassedIncomingRecord = _secondsPassedIncomingRecord + 1;
      _secondsIncomingRecord = _secondsPassedIncomingRecord % 60;
      _minutesIncomingRecord = _secondsPassedIncomingRecord ~/ 60 % 60;
      DashboardView.incomingEventRecording.fire({
        "incomingEvent": "incomingCallRecording",
        "seconds": _secondsIncomingRecord,
        "minutes": _minutesIncomingRecord,
      });
    });

    if (!incomingIsCallConnected && !_autoRecord) {
      _timerIncomingRecord?.cancel();
    }
  }

  void resumeIncomingRecordTimer() {
    _timerIncomingRecord = Timer.periodic(_duration, (Timer t) {
      _secondsPassedIncomingRecord = _secondsPassedIncomingRecord + 1;
      _secondsIncomingRecord = _secondsPassedIncomingRecord % 60;
      _minutesIncomingRecord = _secondsPassedIncomingRecord ~/ 60 % 60;
      DashboardView.incomingEventRecording.fire({
        "incomingEvent": "incomingCallRecording",
        "seconds": _secondsIncomingRecord,
        "minutes": _minutesIncomingRecord,
      });
    });

    if (!incomingIsCallConnected && !_autoRecord) {
      _timerIncomingRecord?.cancel();
    }
  }

  void stopIncomingRecordTimer() {
    _timerIncomingRecord?.cancel();
    _secondsPassedIncomingRecord = 0;
    _secondsIncomingRecord = 0;
    _minutesIncomingRecord = 0;
  }

  void pauseIncomingRecordTimer() {
    _timerIncomingRecord?.cancel();
  }
}
