enum CallType {
  Missed,
  All,
}

extension CallTypeExt on CallType {
  static const Map<CallType, String> keys = {
    CallType.Missed: "Missed",
    CallType.All: "All",
  };

  static const Map<CallType, String> values = {
    CallType.Missed: "Missed",
    CallType.All: "All",
  };

  String get key => keys[this]!;
  String get value => values[this]!;

  // NEW
  static CallType? fromRaw(String raw) =>
      keys.entries.firstWhere((e) => e.value == raw, orElse: () => null!).key;
}
