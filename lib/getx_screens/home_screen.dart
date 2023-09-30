import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frc_scouting/helpers/shared_preferences_helper.dart';
import 'package:frc_scouting/models/alliance_color.dart';
import 'package:get/get.dart';

import '../models/settings_screen_variables.dart';
import 'game_screen.dart';
import 'service_status_screen.dart';
import 'settings_screen.dart';
import '../helpers/match_schedule_helper.dart';
import '../helpers/scouters_helper.dart';
import '../helpers/scouters_schedule_helper.dart';
import '../models/match_event.dart';
import '../models/match_key.dart';
import '../services/getx_business_logic.dart';

import '../models/match_type.dart';
import 'previous_matches_screen.dart';

class HomeScreen extends StatelessWidget {
  late BusinessLogicController controller;
  final SettingsScreenVariables variables = Get.put(SettingsScreenVariables());

  var isCustomMatchSelected = false.obs;

  var matchNumberTxtController = TextEditingController();
  var teamNumberTxtController = TextEditingController();

  var alliance = Alliance.blue;

  HomeScreen() {
    matchNumberTxtController.removeListener(() {});
    teamNumberTxtController.removeListener(() {});

    matchNumberTxtController.addListener(() {
      final newMatchNumber = int.parse(matchNumberTxtController.text.isEmpty
          ? "0"
          : matchNumberTxtController.text);

      if (newMatchNumber.toString() != "") {
        controller.matchData.matchKey.value.ordinalMatchNumber = newMatchNumber;
      }
    });

    teamNumberTxtController.addListener(() {
      controller.matchData.teamNumber.value = int.parse(
          teamNumberTxtController.text.isEmpty
              ? "0"
              : teamNumberTxtController.text);
    });

    controller = Get.put(BusinessLogicController());
  }

  @override
  Widget build(BuildContext context) {
    isCustomMatchSelected.listen((value) {
      print(value);
    });

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("Collection App 2023"),
          backgroundColor:
              ScoutersScheduleHelper.shared.matchSchedule.value.getVersionColor,
          foregroundColor: Colors.white,
          actions: [
            Obx(
              () => IconButton(
                icon: Icon(
                  Icons.bolt,
                  color: controller.serviceHelper.isAllUp
                      ? Colors.green
                      : Colors.red,
                  shadows: const [Shadow(blurRadius: 10)],
                ),
                onPressed: () => Get.to(() => ServiceStatusScreen()),
              ),
            ),
            IconButton(
                onPressed: () => Get.to(() => SettingsScreen()),
                icon: const Icon(Icons.settings,
                    shadows: [Shadow(blurRadius: 10)])),
          ],
        ),
        backgroundColor:
            (Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? HSLColor.fromColor(ScoutersScheduleHelper
                            .shared.matchSchedule.value.getVersionColor)
                        .withSaturation(0.5)
                        .withLightness(0.2)
                    : HSLColor.fromColor(ScoutersScheduleHelper
                            .shared.matchSchedule.value.getVersionColor)
                        .withSaturation(0.5)
                        .withLightness(0.8))
                .toColor(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Obx(() => scouterNameDropdown(context)),
                                const SizedBox(height: 20),
                                matchBuilderRow(context),
                                const SizedBox(height: 20),
                                Obx(
                                  () => isCustomMatchSelected.isFalse
                                      ? matchKeyDropdown(context)
                                      : Column(
                                          children: [
                                            matchTypeDropdown(),
                                            const SizedBox(height: 20),
                                            matchNumberTextField(),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 20),
                                teamNumberTextField(),
                                const SizedBox(height: 20),
                                Obx(
                                  () => isCustomMatchSelected.isTrue
                                      ? allianceDropdown()
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() => startButton()),
                    ElevatedButton(
                      child: const Text("Previous Matches"),
                      onPressed: () async {
                        final matches = await controller.documentsHelper
                            .getPreviousMatches();
                        Get.to(() => PreviousMatchesScreen(
                            previousMatchesInfo: matches));
                        if (matches.numberOfInvalidFiles > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Ignored ${matches.numberOfInvalidFiles} invalid file${matches.numberOfInvalidFiles != 1 ? "s" : ""}"),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row matchBuilderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Match Builder"),
              Text(
                "Use only when there is no upcoming matches available to choose from.",
                maxLines: 2,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.brightness ==
                          Brightness.dark
                      ? Colors.grey
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Switch(
              value: isCustomMatchSelected.value,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (bool switchState) {
                HapticFeedback.lightImpact();
                isCustomMatchSelected.value = switchState;

                if (!switchState) {
                  controller.matchData.matchKey = MatchKey(
                          matchType: MatchType.qualifierMatch,
                          ordinalMatchNumber: 0,
                          rawShortMatchKey: "")
                      .obs;
                }
              }),
        ),
      ],
    );
  }

  Widget startButton() {
    return ElevatedButton(
      onPressed: controller.matchData.isPreliminaryDataValid
          ? () async {
              await controller.setLandscapeOrientation();
              controller.matchData.tournament =
                  variables.selectedTournamentKey.value;

              Future.delayed(700.milliseconds, () {
                Get.to(() => GameScreen(
                      isInteractive: true,
                      alliance: isCustomMatchSelected.isTrue
                          ? alliance
                          : MatchScheduleHelper.shared.matchSchedule
                                  .firstWhereOrNull((match) =>
                                      match.matchKey ==
                                      controller.matchData.matchKey.value)
                                  ?.allianceColor ??
                              Alliance.red,
                    ));
              });
            }
          : null,
      child: const Text("Start", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget matchKeyDropdown(BuildContext context) {
    return Obx(
      () => DropdownSearch<MatchKey>(
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: "Match",
            filled: true,
          ),
        ),
        popupProps: PopupProps.modalBottomSheet(
          searchDelay: 0.seconds,
          emptyBuilder: (context, searchEntry) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                  "No Matches Found for the selected Scouter. Try selecting your name first. \n\nIf you are using a Backup Scouter or internet is unavailable, try using Match Builder. \n\nTo refresh data, click the bolt icon and press Network Refresh All"),
            );
          },
          modalBottomSheetProps: ModalBottomSheetProps(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        ),
        items:
            matchesFromShifts.map((matchEvent) => matchEvent.matchKey).toList(),
        onChanged: (matchKey) {
          if (matchKey != null) {
            controller.matchData.matchKey = matchKey.obs;
            final matchScheduleAndMatchKey = MatchScheduleHelper
                .shared.matchSchedule
                .firstWhereOrNull((match) => match.matchKey == matchKey);

            if (matchScheduleAndMatchKey != null) {
              controller.matchData.matchKey.value = matchKey;
              controller.matchData.matchKey.value.ordinalMatchNumber =
                  matchKey.ordinalMatchNumber;
              teamNumberTxtController.text =
                  matchScheduleAndMatchKey.teamNumber.toString();
            }
          }
        },
        selectedItem: matchesFromShifts
                .map((matchEvent) => matchEvent.matchKey)
                .toList()
                .contains(controller.matchData.matchKey.value)
            ? controller.matchData.matchKey.value
            : null,
        itemAsString: (item) => item.localizedDescription,
      ),
    );
  }

  Widget matchTypeDropdown() {
    return DropdownSearch<MatchType>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Match Type",
          filled: true,
        ),
      ),
      // popupProps: const PopupProps.menu(
      //   showSelectedItems: true,
      // ),
      items: MatchType.values,
      onChanged: (matchType) {
        if (matchType != null) {
          controller.matchData.matchKey.value.matchType = matchType;
        }
      },
      itemAsString: (item) => item.localizedDescription,
      selectedItem: controller.matchData.matchKey.value.matchType,
    );

    // return DropdownButton<MatchType>(
    //   hint: const Text("Match Type"),
    //   items: [
    //     for (final matchType in MatchType.values)
    //       DropdownMenuItem(
    //           value: matchType, child: Text(matchType.localizedDescription))
    //   ],
    //   onChanged: (value) {
    //     if (value != null) {}
    //   },
    //   value: null,
    // );
  }

  Widget matchNumberTextField() {
    return TextField(
      controller: matchNumberTxtController,
      decoration: const InputDecoration(
        labelText: "Match Number",
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String matchNumberString) => controller.matchData.matchKey
          .value.ordinalMatchNumber = int.tryParse(matchNumberString) ?? 0,
    );
  }

  TextField teamNumberTextField() {
    return TextField(
      controller: teamNumberTxtController,
      decoration: const InputDecoration(
        labelText: "Team Number",
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String teamNumber) =>
          controller.matchData.teamNumber.value = int.tryParse(teamNumber) ?? 0,
    );
  }

  Widget allianceDropdown() {
    return DropdownSearch<Alliance>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Alliance Color",
          filled: true,
        ),
      ),
      items: Alliance.values,
      onChanged: (alliance) {
        if (alliance != null) {
          this.alliance = alliance;
        }
      },
      itemAsString: (item) => item.localizedDescription,
      selectedItem: alliance,
    );
  }

  Widget scouterNameDropdown(BuildContext context) {
    return DropdownSearch<String>(
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Scouter Name",
          filled: true,
        ),
      ),
      popupProps: PopupProps.modalBottomSheet(
        searchDelay: 0.seconds,
        emptyBuilder: (context, searchEntry) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text("No Scouters Found"),
          );
        },
        modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        containerBuilder: (context, popupWidget) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(children: [
                Column(children: [
                  const SizedBox(height: 40),
                  Expanded(child: popupWidget),
                ]),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ]),
            ),
          );
        },
        fit: FlexFit.loose,
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          padding: EdgeInsets.all(20),
          decoration: InputDecoration(
            labelText: "Search Scouters",
            filled: true,
          ),
          autofocus: true,
        ),
      ),
      items: [
        ...ScoutersHelper.shared.scouters,
        "Backup Scouter 1",
        "Backup Scouter 2",
        "Backup Scouter 3",
        "Backup Scouter 4",
        "Backup Scouter 5",
        "Backup Scouter 6",
      ],
      selectedItem: controller.matchData.scouterName.value,
      onChanged: (value) {
        controller.matchData.scouterName.value = value ?? "";
        SharedPreferencesHelper.shared.setString("scouterName", value ?? "");
      },
    );
  }

  List<MatchEvent> get matchesFromShifts {
    return MatchScheduleHelper.shared.getMatchesFromShifts(
      shifts: ScoutersScheduleHelper.shared.matchSchedule.value
          .filterShiftsWithScouter(
        controller.matchData.scouterName.value,
      ),
      scouterName: controller.matchData.scouterName.value,
    );
  }
}

extension ListGetExtension<T> on List<T> {
  T? tryGet(int index) => index < 0 || index >= length ? null : this[index];
}
