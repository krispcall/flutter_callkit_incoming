import "package:flutter/cupertino.dart";

class UserDetailProvider extends ChangeNotifier {
  String _defaultWorkspaceId = "";
  bool _changeWorkspace = false;

  String get defaultWorkspaceId => _defaultWorkspaceId;
  set defaultWorkspaceId(String data) {
    _defaultWorkspaceId = data;
  }

  bool get changeWorkspace => _changeWorkspace;
  set changeWorkspace(bool data) {
    _changeWorkspace = data;
  }

  notifyAll() {
    notifyListeners();
  }
}
