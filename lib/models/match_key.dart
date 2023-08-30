import 'dart:core';

import 'package:frc_scouting/models/constants.dart';
import 'package:get/get.dart';

import '../getx_screens/settings_screen.dart';
import 'match_type.dart';
import 'tournament.dart';

class MatchKey {
  late MatchType matchType;
  late int ordinalMatchNumber;
  late String rawShortMatchKey;

  MatchKey(
      {required this.matchType,
      required this.ordinalMatchNumber,
      required this.rawShortMatchKey});

  // like 'qf1'
  MatchKey.fromJsonUsingShortKeyForm(String jsonString) {
    try {
      matchType = MatchTypeExtension.fromShortName(jsonString.substring(0, 2));
      ordinalMatchNumber = int.parse(jsonString.substring(2));
      rawShortMatchKey = jsonString;
    } catch (e) {
      throw Exception("Failed to parse short form match key.");
    }
  }

  MatchKey.fromJsonUsingLongKeyForm(String jsonString) {
    try {
      final matchKey =
          MatchKey.fromJsonUsingShortKeyForm(jsonString.split("_")[1]);
      matchType = matchKey.matchType;
      ordinalMatchNumber = matchKey.ordinalMatchNumber;
      rawShortMatchKey = matchKey.rawShortMatchKey;
    } catch (e) {
      throw Exception("Failed to parse long form match key.");
    }
  }

  String get localizedDescription =>
      "${matchType.localizedDescription} ${RegExp("(?<=[a-z]+)\\d{1,3}").firstMatch(rawShortMatchKey)?[0]}";

  String get shortMatchKey => "${matchType.shortName}$ordinalMatchNumber";

  String longMatchKeyForTournament(Tournament tournamentKey) =>
      "${tournamentKey.key}_$shortMatchKey";

  // String get longMatchKey =>
  //     "${Get.find<SettingsScreenVariables>().selectedTournamentKey.value.key}_$shortMatchKey";

  bool get isBlank => ordinalMatchNumber == 0;
}
