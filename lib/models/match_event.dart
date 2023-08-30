import 'package:frc_scouting/models/match_key.dart';

import 'match_type.dart';

class MatchEvent {
  // like 'qm1_4'
  String key;

  // like '2022cc'
  String gameKey;

  // like 1
  int teamNumber;

  // combination of matchType ('qm') and matchNumber (1)
  MatchKey matchKey;

  int ordinalNumber;

  MatchEvent({
    required this.key,
    required this.gameKey,
    required this.matchKey,
    required this.teamNumber,
    required this.ordinalNumber,
  });

  // like '{"key":"2022cc_qm1_4","team":"frc254", "ordinalNumber": 4}'
  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    try {
      final matchKey = MatchKey.fromJsonUsingLongKeyForm(json['key']);

      return MatchEvent(
          key: json['key'],
          gameKey: (json['key'] as String).split("_")[0],
          matchKey: matchKey,
          teamNumber: int.parse((json['team'] as String).substring(3)),
          ordinalNumber: json['ordinalNumber']);
    } catch (e) {
      throw Exception("Failed to parse match event.");
    }
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'team': "frc$teamNumber",
        'ordinalNumber': ordinalNumber,
      };
}
