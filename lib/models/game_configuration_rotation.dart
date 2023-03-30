enum GameConfigurationRotation { standard, inversed }

extension RotationExtension on GameConfigurationRotation {
  String get localizedDescription {
    switch (this) {
      case GameConfigurationRotation.standard:
        return "Auspicious";
      case GameConfigurationRotation.inversed:
        return "Sinister";
    }
  }

  GameConfigurationRotation getToggledValue() {
    switch (this) {
      case GameConfigurationRotation.standard:
        return GameConfigurationRotation.inversed;
      case GameConfigurationRotation.inversed:
        return GameConfigurationRotation.standard;
    }
  }
}
