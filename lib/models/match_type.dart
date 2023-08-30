enum MatchType {
  qualifierMatch,
  eliminationMatch,
}

extension MatchTypeExtension on MatchType {
  String get localizedDescription {
    switch (this) {
      case MatchType.qualifierMatch:
        return "Qualification";
      case MatchType.eliminationMatch:
        return "Elimination Match";
    }
  }

  String get shortName {
    switch (this) {
      case MatchType.qualifierMatch:
        return "qm";
      case MatchType.eliminationMatch:
        return "em";
    }
  }

  static MatchType fromShortName(String shortName) {
    try {
      return MatchType.values
          .firstWhere((element) => element.shortName == shortName);
    } catch (e) {
      throw Exception("Invalid match type");
    }
  }

  static MatchType fromLocalizedDescription(String matchType) {
    try {
      return MatchType.values
          .firstWhere((element) => element.localizedDescription == matchType);
    } catch (e) {
      throw Exception("Invalid match type");
    }
  }
}
