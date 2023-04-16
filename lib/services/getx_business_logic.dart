import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/helpers/match_schedule_helper.dart';
import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';
import 'package:frc_scouting/models/robot_action.dart';
import 'package:frc_scouting/models/service.dart';
import 'package:frc_scouting/models/tournament.dart';
import 'package:get/get.dart';

import '../getx_screens/home_screen.dart';
import '../helpers/shared_preferences_helper.dart';
import '../helpers/tournaments_helper.dart';
import '../models/constants.dart';
import '../persistence/files_helper.dart';
import '../models/event.dart';
import '../models/match_data.dart';
import '../helpers/scouters_helper.dart';

enum MatchFilterType { date, hasNotUploaded }

extension MatchFilterTypeExtension on MatchFilterType {
  String get localizedDescription {
    switch (this) {
      case MatchFilterType.date:
        return "Date";
      case MatchFilterType.hasNotUploaded:
        return "Not Uploaded";
      default:
        return "Unknown";
    }
  }
}

class BusinessLogicController extends GetxController {
  late MatchData matchData;
  final documentsHelper = FilesHelper();
  var matchFilterType = MatchFilterType.date.obs;
  final serviceHelper = ServiceHelper();

  @override
  void onInit() async {
    matchData = MatchData();

    matchData.scouterName.value = await SharedPreferencesHelper.shared
            .getString(SharedPreferenceKeys.scouterName.toShortString()) ??
        "";

    matchData.tournament = Tournament.fromJson(jsonDecode(
        await SharedPreferencesHelper.shared.getString(
                SharedPreferenceKeys.selectedTournamentKey.toShortString()) ??
            jsonEncode(Constants.shared.tournamentKeys.first.toJson())));

    try {
      MatchScheduleHelper.shared.getMatchSchedule(networkRefresh: false);
      ScoutersHelper.shared.getAllScouters(networkRefresh: false);
      ScoutersScheduleHelper.shared.getScoutersSchedule(networkRefresh: false);
      TournamentsHelper.shared.getTournaments(networkRefresh: false);
    } catch (e) {}

    try {
      MatchScheduleHelper.shared.getMatchSchedule(networkRefresh: true);
    } catch (e) {
      print("Error getting event schedule: $e");
    }

    try {
      ScoutersHelper.shared.getAllScouters(networkRefresh: true);
    } catch (e) {
      print("Error getting scouters: $e");
    }

    try {
      ScoutersScheduleHelper.shared.getScoutersSchedule(networkRefresh: true);
    } catch (e) {
      print("Error getting scouters schedule: $e");
    }

    try {
      TournamentsHelper.shared.getTournaments(networkRefresh: true);
    } catch (e) {
      print("Error getting tournaments: $e");
    }

    resetOrientation();
    setPortraitOrientation();

    super.onInit();
  }

  Orientation get currentOrientation => Get.mediaQuery.orientation;

  Future setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  Future setLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
  }

  Future resetOrientation() async {
    await Future.wait([
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      ),
      SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      ),
    ]);
  }

  void addEventToTimeline(
      {required RobotAction robotAction, required int position}) {
    final event = Event(
      timeSince: Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch -
              matchData.startTime.millisecondsSinceEpoch),
      action: robotAction,
      position: position,
    );

    matchData.events.add(event);
    event.debugLogDescription();
  }

  List<String> separateEventsToQrCodes({required MatchData matchData}) {
    List<String> qrCodes = [];
    var jsonString = jsonEncode(
        matchData.toJson(includeUploadStatus: false, usesTBAKey: true));
    const qrCodeLimit = 1000;
    final scouterPlacement = ScoutersScheduleHelper
        .shared.matchSchedule.value.shifts
        .firstWhere((shift) => shift.matchShiftDuration.range
            .contains(matchData.matchKey.value.ordinalMatchNumber))
        .scouterPlacement(
          matchData.scouterName.value,
        );
    final totalPages = (jsonString.length / qrCodeLimit).ceil();

    print("jsonString length: ${jsonString.length}");

    var currentPage = 0;

    while (jsonString.length > qrCodeLimit) {
      final jsonPage = jsonEncode({
        "uuid": matchData.uuid,
        "scouterId": scouterPlacement,
        "currentPage": currentPage,
        "totalPages": totalPages,
        "data": jsonString.substring(0, qrCodeLimit)
      });

      currentPage++;

      qrCodes.add(jsonPage);
      jsonString = jsonString.replaceRange(0, qrCodeLimit, "");
    }

    final jsonPage = jsonEncode({
      "uuid": matchData.uuid,
      "scouterId": scouterPlacement,
      "currentPage": currentPage,
      "totalPages": totalPages,
      "data": jsonString
    });

    qrCodes.add(jsonPage);

    print("# of QrCodes: ${qrCodes.length}");

    return qrCodes;
  }

  void reset() {
    matchData = MatchData();
    // Get.offAll(() => HomeScreen());
    Navigator.pushAndRemoveUntil(
        Get.context!,
        MaterialPageRoute<dynamic>(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }
}
