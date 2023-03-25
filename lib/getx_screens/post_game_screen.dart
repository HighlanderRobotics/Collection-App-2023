import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:frc_scouting/getx_screens/view_qrcode_screen.dart';
import 'package:frc_scouting/models/climbing_challenge.dart';
import 'package:frc_scouting/models/robot_roles.dart';
import 'package:get/get.dart';

import '../models/driver_ability.dart';
import '../services/getx_business_logic.dart';

class PostGameScreen extends StatelessWidget {
  final notesController = TextEditingController();

  final controller = Get.find<BusinessLogicController>();

  PostGameScreen() {
    controller.resetOrientation();
    controller.setPortraitOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.setLandscapeOrientation();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post Game"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Obx(
              (() => Column(
                    children: [
                      autonClimbingChallengeDropdown(context),
                      const SizedBox(height: 15),
                      climbingChallengeDropdown(context),
                      const SizedBox(height: 15),
                      robotRoleDropdown(context),
                      const SizedBox(height: 15),
                      driverAbilityDropdown(context),
                      const SizedBox(height: 15),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: "Notes",
                          filled: true,
                        ),
                        controller: notesController,
                        onChanged: (text) =>
                            controller.matchData.notes.value = text,
                        maxLines: null,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: showQrCodeButton(context),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  DropdownSearch<ClimbingChallenge> climbingChallengeDropdown(
      BuildContext context) {
    return DropdownSearch<ClimbingChallenge>(
      items: ClimbingChallenge.values,
      itemAsString: (climbingChallenge) =>
          climbingChallenge.localizedDescription,
      selectedItem: controller.matchData.challengeResult.value,
      onChanged: (climbingChallenge) {
        if (climbingChallenge != null) {
          controller.matchData.challengeResult.value = climbingChallenge;
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Climbing Challenge",
          filled: true,
        ),
      ),
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                item.localizedDescription,
              ),
              subtitle: Text(item.longLocalizedDescription),
            ),
          );
        },
        modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }

  DropdownSearch<ClimbingChallenge> autonClimbingChallengeDropdown(
      BuildContext context) {
    return DropdownSearch<ClimbingChallenge>(
      items: ClimbingChallenge.values,
      itemAsString: (climbingChallenge) =>
          climbingChallenge.localizedDescription,
      selectedItem: controller.matchData.autoChallengeResult.value,
      onChanged: (climbingChallenge) {
        if (climbingChallenge != null) {
          controller.matchData.autoChallengeResult.value = climbingChallenge;
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Auton Climbing Challenge",
          filled: true,
        ),
      ),
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                item.localizedDescription,
              ),
              subtitle: Text(item.longLocalizedDescription),
            ),
          );
        },
        modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ),
    );
  }

  DropdownSearch<RobotRole> robotRoleDropdown(BuildContext context) {
    return DropdownSearch<RobotRole>(
      items: RobotRole.values,
      itemAsString: (robotRole) => robotRole.localizedDescription,
      selectedItem: controller.matchData.robotRole.value,
      onChanged: (robotRole) {
        if (robotRole != null) {
          controller.matchData.robotRole.value = robotRole;
        }
      },
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(item.localizedDescription),
              subtitle: Text(item.longLocalizedDescription),
              selected: isSelected,
            ),
          );
        },
        modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Robot Role",
          filled: true,
        ),
      ),
    );
  }

  DropdownSearch<DriverAbility> driverAbilityDropdown(BuildContext context) {
    return DropdownSearch<DriverAbility>(
      items: DriverAbility.values,
      itemAsString: (driverAbility) => driverAbility.localizedDescription,
      selectedItem: controller.matchData.driverAbility.value,
      onChanged: (driverAbility) {
        if (driverAbility != null) {
          controller.matchData.driverAbility.value = driverAbility;
        }
      },
      popupProps: PopupProps.modalBottomSheet(
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
            child: ListTile(
              title: Text(
                item.localizedDescription,
                style: TextStyle(color: item.color),
              ),
              subtitle: Text(item.longLocalizedDescription),
              selected: isSelected,
            ),
          );
        },
        modalBottomSheetProps: ModalBottomSheetProps(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      ),
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Driver Ability",
          filled: true,
        ),
      ),
    );
  }

  ElevatedButton showQrCodeButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.documentsHelper
            .saveAndUploadMatchData(controller.matchData)
            .then((uploadResult) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Upload ${uploadResult ? "Successful" : "Failed"}"),
            behavior: SnackBarBehavior.floating,
          ));
        });

        Get.to(
          () => QrCodeScreen(
              matchQrCodes: controller.separateEventsToQrCodes(
                matchData: controller.matchData,
              ),
              canPopScope: false),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.qr_code),
            SizedBox(width: 10),
            Text("Show QR Code"),
          ],
        ),
      ),
    );
  }
}
