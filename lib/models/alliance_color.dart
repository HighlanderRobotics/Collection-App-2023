enum Alliance { red, blue }

extension AllianceColorName on Alliance {
  String get localizedDescription {
    switch (this) {
      case Alliance.red:
        return 'Red';
      case Alliance.blue:
        return 'Blue';
    }
  }
}
