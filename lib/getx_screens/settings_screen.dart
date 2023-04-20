import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frc_scouting/getx_screens/game_configuration_screen.dart';
import 'package:frc_scouting/getx_screens/scan_qrcode_screen.dart';
import 'package:frc_scouting/helpers/scouters_schedule_helper.dart';
import 'package:frc_scouting/helpers/tournaments_helper.dart';
import 'package:frc_scouting/models/constants.dart';
import 'package:frc_scouting/models/scout_schedule.dart';
import 'package:frc_scouting/models/tournament.dart';
import 'package:get/get.dart';

import '../helpers/shared_preferences_helper.dart';
import '../models/settings_screen_variables.dart';
import '../services/getx_business_logic.dart';
import 'server_authority_setup_screen.dart';

class SettingsScreen extends StatelessWidget {
  final BusinessLogicController controller = Get.find();
  final SettingsScreenVariables variables = Get.find();

  bool get isDataValid => hasValidServerAuthority();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
            child: saveConfigurationButton(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => DropdownSearch<Tournament>(
                    items: [
                      ...Constants.shared.tournamentKeys,
                      ...TournamentsHelper.shared.tournaments.toList()
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        variables.selectedTournamentKey.value = value;
                      }
                    },
                    dropdownBuilder: (context, selectedItem) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(selectedItem?.name ?? ""),
                          Text(
                            selectedItem?.key ?? "",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 14),
                          ),
                        ],
                      );
                    },
                    compareFn: (item1, item2) => item1.key == item2.key,
                    selectedItem: variables.selectedTournamentKey.value,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Tournament",
                        filled: true,
                      ),
                    ),
                    itemAsString: (item) => "${item.name}${item.key}",
                    popupProps: PopupProps.modalBottomSheet(
                      errorBuilder: (context, searchEntry, exception) {
                        Navigator.of(context).pop();

                        Fluttertoast.cancel();

                        Fluttertoast.showToast(
                          msg: "Failed to fetch server tournaments: $exception",
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 5,
                          backgroundColor:
                              Theme.of(context).colorScheme.outline,
                          fontSize: 15.0,
                        );
                        return Container();
                      },
                      loadingBuilder: (context, searchEntry) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      itemBuilder: (context, item, isSelected) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            item.key,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        );
                      },
                      searchDelay: 0.seconds,
                      emptyBuilder: (context, searchEntry) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              "No Tournaments found. Please check your search query or internet connection."),
                        );
                      },
                      modalBottomSheetProps: ModalBottomSheetProps(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor),
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
                          labelText: "Search Tournaments",
                          filled: true,
                        ),
                        autofocus: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ServerAuthoritySetupScreen(),
                ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final qrCodeResult = await Get.to(ScanQrCodeScreen());
                      if (qrCodeResult is String && qrCodeResult.isNotEmpty) {
                        // decode qr code string
                        try {
                          ScoutersScheduleHelper.shared.matchSchedule.value =
                              ScoutersSchedule.fromCompressedJSON(qrCodeResult);

                          ScoutersScheduleHelper.saveParsedLocalStorageSchedule(
                              ScoutersScheduleHelper
                                  .shared.matchSchedule.value);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Successfully updated Scouters Schedule \nVersion ${ScoutersScheduleHelper.shared.matchSchedule.value.version.value}"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Failed to update Scouters Schedule. \nError: ${e.toString()}"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    label: const Text("Scan Scouter Schedule QR Code")),
                ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      controller.setLandscapeOrientation();

                      Future.delayed(700.milliseconds, () {
                        Get.to(GameConfigurationScreen());
                      });
                    },
                    label: const Text("Edit Game Configuration")),
                const SizedBox(height: 10),
                const SizedBox(height: 30),
                deleteConfigurationButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deleteConfigurationButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete configuration?"),
            content: const Text(
                "If you continue, you will lose all your settings, and the app will be reset to factory settings."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.error),
                    foregroundColor: MaterialStateProperty.resolveWith(
                        (states) => Theme.of(context).colorScheme.onError),
                  ),
                  child: const Text("Delete"),
                  onPressed: () async {
                    final sharedPreferences =
                        await SharedPreferencesHelper.shared.sharedPreferences;
                    await sharedPreferences.clear();
                    await variables.resetValues();
                    controller.reset();

                    Future.delayed(500.milliseconds, () {
                      Get.to(() => SettingsScreen());
                    });
                  })
            ],
          ),
        );
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Theme.of(context).colorScheme.error),
        foregroundColor: MaterialStateProperty.resolveWith(
            (states) => Theme.of(context).colorScheme.onError),
      ),
      label: const Text("Delete Configuration"),
    );
  }

  Widget saveConfigurationButton(BuildContext context) {
    return Obx(
      () => IconButton(
        icon: Icon(
          Icons.check,
          color: Constants.shared.serverAuthorityRegex
                  .hasMatch(variables.serverAuthority.value)
              ? Colors.green
              : Colors.grey,
        ),
        onPressed: () async {
          if (hasValidServerAuthority()) {
            await variables.saveValues();

            controller.serviceHelper.refreshAll(networkRefresh: true);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Saved Configuration"),
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Invalid Configuration"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  bool hasValidServerAuthority() => Constants.shared.serverAuthorityRegex
      .hasMatch(variables.serverAuthority.value);
}
