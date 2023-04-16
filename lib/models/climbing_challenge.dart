enum TeleopClimbingChallenge { noClimb, docked, engaged, failed, inCommunity }

extension ClimbingChallengeExtension on TeleopClimbingChallenge {
  String get localizedDescription {
    switch (this) {
      case TeleopClimbingChallenge.noClimb:
        return "No Climb";
      case TeleopClimbingChallenge.docked:
        return "Docked";
      case TeleopClimbingChallenge.engaged:
        return "Engaged";
      case TeleopClimbingChallenge.failed:
        return "Failed";
      case TeleopClimbingChallenge.inCommunity:
        return "In Community";
      default:
        return "Unknown";
    }
  }

  String get longLocalizedDescription {
    switch (this) {
      case TeleopClimbingChallenge.noClimb:
        return "Did not attempt to climb";
      case TeleopClimbingChallenge.docked:
        return "The charge station is tipped, but the robots are fully supported by the charge station and not touching the ground";
      case TeleopClimbingChallenge.engaged:
        return "The charge station is balanced and signaled by the LEDs being lit";
      case TeleopClimbingChallenge.failed:
        return "The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful";
      case TeleopClimbingChallenge.inCommunity:
        return "The robot did not attempt to climb, but still was in the community";
      default:
        return "Unknown";
    }
  }
}

enum AutonClimbingChallenge { noClimb, docked, engaged, failed, mobility }

extension AutonChallengeExtension on AutonClimbingChallenge {
  String get localizedDescription {
    switch (this) {
      case AutonClimbingChallenge.noClimb:
        return "No Climb";
      case AutonClimbingChallenge.docked:
        return "Docked";
      case AutonClimbingChallenge.engaged:
        return "Engaged";
      case AutonClimbingChallenge.failed:
        return "Failed";
      case AutonClimbingChallenge.mobility:
        return " Mobility";
      default:
        return "Unknown";
    }
  }

  String get longLocalizedDescription {
    switch (this) {
      case AutonClimbingChallenge.noClimb:
        return "Did not attempt to climb";
      case AutonClimbingChallenge.docked:
        return "The charge station is tipped, but the robots are fully supported by the charge station and not touching the ground";
      case AutonClimbingChallenge.engaged:
        return "The charge station is balanced and signaled by the LEDs being lit";
      case AutonClimbingChallenge.failed:
        return "The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful";
      case AutonClimbingChallenge.mobility:
        return "The robot left the community during auto";
      default:
        return "Unknown";
    }
  }
}
