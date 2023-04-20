import 'package:frc_scouting/models/tournament.dart';
import 'package:flutter/foundation.dart';

class Constants {
  static Constants shared = Constants();

  final tournamentKeys = [
    Tournament(name: "Monterey", key: "2023camb"),
    Tournament(name: "Fresno", key: "2023cafr"),
    Tournament(name: "2023 Week 0", key: "2023week0"),
    Tournament(name: "2023 PNW District SunDome", key: "2023wayak"),
    Tournament(name: "2023 PNW District Glacier Peak", key: "2023wasno"),
    Tournament(name: "Finger Lakes Regional 2023", key: "2023nyro"),
    Tournament(name: "New York Tech Valley Regional 2023", key: "2023nytr"),
    if (kDebugMode) Tournament(name: "Chezy 2022 (debug)", key: "2022cc"),
  ];

  final serverAuthorityRegex = RegExp(
      "^((((?!-))(xn--)?[a-zA-Z0-9][a-zA-Z0-9-_]{0,61}[a-zA-Z0-9]{0,1}\\.(xn--)?([a-zA-Z0-9\\-]{1,61}|[a-zA-Z0-9-]{1,30}\\.[a-zA-Z]{2,}))|(localhost)|((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4})(:\\d+)?\$");
}
