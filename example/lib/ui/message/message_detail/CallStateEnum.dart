enum CallStateIndex {
  Incoming,
  Outgoing,
  Message,
  Call,
  PENDING,
  SENT,
  NOTSENT,
  FAILED,
  DELIVERED,
  NOANSWER,
  BUSY,
  COMPLETED,
  CANCELED,

  ///TODO NO longer triggered
  ATTEMPTED,
  INPROGRESS,
  RINGING,
  CALLING,
  REJECTED,
  OnHOLD,
  TRANSFERRING,
  TRANSFERRED,
}

extension StatusExt on CallStateIndex {
  static const Map<CallStateIndex, String> keys = {
    CallStateIndex.Incoming: "Incoming",
    CallStateIndex.Outgoing: "Outgoing",
    CallStateIndex.Message: "Message",
    CallStateIndex.Call: "Call",
    CallStateIndex.PENDING: "PENDING",
    CallStateIndex.SENT: "SENT",
    CallStateIndex.NOTSENT: "NOTSENT",
    CallStateIndex.FAILED: "FAILED",
    CallStateIndex.DELIVERED: "DELIVERED",
    CallStateIndex.NOANSWER: "NOANSWER",
    CallStateIndex.BUSY: "BUSY",
    CallStateIndex.COMPLETED: "COMPLETED",
    CallStateIndex.CANCELED: "CANCELED",

    ///TODO NO longer triggered
    CallStateIndex.ATTEMPTED: "ATTEMPTED",
    CallStateIndex.INPROGRESS: "INPROGRESS",
    CallStateIndex.RINGING: "RINGING",
    CallStateIndex.CALLING: "CALLING",
    CallStateIndex.REJECTED: "REJECTED",
    CallStateIndex.OnHOLD: "ONHOLD",
    CallStateIndex.TRANSFERRING: "TRANSFERING",
    CallStateIndex.TRANSFERRED: "TRANSFERRED",
  };

  // export const conversationStatusValues = {
  //   pending: 'PENDING',
  //   sent: 'SENT',
  //   failed: 'FAILED',
  //   delivered: 'DELIVERED',
  //   noAnswer: 'NOANSWER',
  //   busy: 'BUSY',
  //   completed: 'COMPLETED',
  //   cancelled: 'CANCELED',
  //   attempted: 'ATTEMPTED',
  //   callInProgress: 'INPROGRESS',
  //   ringing: 'RINGING',
  //   rejected: 'REJECTED',
  // };

  static const Map<CallStateIndex, String> values = {
    CallStateIndex.Incoming: "Incoming",
    CallStateIndex.Outgoing: "Outgoing",
    CallStateIndex.Message: "Message",
    CallStateIndex.Call: "Call",
    CallStateIndex.PENDING: "PENDING",
    CallStateIndex.SENT: "SENT",
    CallStateIndex.NOTSENT: "NOTSENT",
    CallStateIndex.FAILED: "FAILED",
    CallStateIndex.DELIVERED: "DELIVERED",
    CallStateIndex.NOANSWER: "NOANSWER",
    CallStateIndex.BUSY: "BUSY",
    CallStateIndex.COMPLETED: "COMPLETED",
    CallStateIndex.CANCELED: "CANCELED",

    ///TODO NO longer triggered
    CallStateIndex.ATTEMPTED: "ATTEMPTED",
    CallStateIndex.INPROGRESS: "INPROGRESS",
    CallStateIndex.RINGING: "RINGING",
    CallStateIndex.CALLING: "CALLING",
    CallStateIndex.REJECTED: "REJECTED",
    CallStateIndex.OnHOLD: "ONHOLD",
    CallStateIndex.TRANSFERRING: "TRANSFERING",
    CallStateIndex.TRANSFERRED: "TRANSFERRED",
  };

  String get key => keys[this]!;

  String get value => values[this]!;

  static CallStateIndex? fromRaw(String raw) => keys.entries
      .firstWhere(
        (e) => e.value == raw,
      )
      .key;
}

enum CallStateOutput {
  EMPTY,
  Incoming_Message,
  Incoming_NOANSWER,
  Incoming_BUSY,
  Incoming_COMPLETED,
  Incoming_CANCELED,
  Incoming_INPROGRESS,
  Incoming_RINGING,
  Incoming_REJECTED,
  Incoming_VOICEMAIL,
  Incoming_RECORDING,
  Outgoing_Pending,
  Outgoing_NOTSENT,
  Outgoing_FAILED,
  Outgoing_NOANSWER,
  Outgoing_BUSY,
  Outgoing_CANCELED,

  ///TODO NO longer triggered
  Outgoing_ATTEMPTED,
  Outgoing_INPROGRESS,
  Outgoing_RINGING,
  Outgoing_CALLING,
  OutGoing_CallView,
  OutGoing_MessageView,
  Outgoing_REJECTED,
  Outgoing_RECORDING,
  OnHOLD,
  TRANSFERRING,
  TRANSFERRED,
}
