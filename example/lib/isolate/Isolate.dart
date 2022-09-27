import "dart:isolate";
import "dart:ui";

///Isolate background
class IsolateManagerCallCancelled {
  static const FOREGROUND_PORT_NAME = "foreground_port_call_cancelled";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerCallInvite {
  static const FOREGROUND_PORT_NAME = "foreground_port_call_invite";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

///Isolate Outgoing background
class IsolateManagerOutgoingCallRinging {
  static const FOREGROUND_PORT_NAME = "foreground_port_outgoing_call_ringing";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallConnected {
  static const FOREGROUND_PORT_NAME = "foreground_port_outgoing_call_connected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallDisconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_disconnected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallConnectionFailure {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_connection_failure";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallQualityWarningsChanged {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_quality_warnings_changed";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallReconnecting {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_reconnecting";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerOutgoingCallReconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_outgoing_call_reconnected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

///Isolate Background Incoming
class IsolateManagerIncomingCallRinging {
  static const FOREGROUND_PORT_NAME = "foreground_port_incoming_call_ringing";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallConnected {
  static const FOREGROUND_PORT_NAME = "foreground_port_incoming_call_connected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallDisconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_disconnected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallConnectionFailure {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_connection_failure";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallQualityWarningsChanged {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_quality_warnings_changed";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallReconnecting {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_reconnecting";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}

class IsolateManagerIncomingCallReconnected {
  static const FOREGROUND_PORT_NAME =
      "foreground_port_incoming_call_reconnected";

  static SendPort? lookupPortByName() {
    return IsolateNameServer.lookupPortByName(FOREGROUND_PORT_NAME);
  }

  static bool registerPortWithName(SendPort port) {
    removePortNameMapping(FOREGROUND_PORT_NAME);
    return IsolateNameServer.registerPortWithName(port, FOREGROUND_PORT_NAME);
  }

  static bool removePortNameMapping(String name) {
    return IsolateNameServer.removePortNameMapping(name);
  }
}
