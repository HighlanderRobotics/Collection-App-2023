import 'package:flutter/material.dart';

enum PenaltyCard {
  none,
  yellow,
  red,
}

extension PenaltyCardName on PenaltyCard {
  String get localizedDescription {
    switch (this) {
      case PenaltyCard.none:
        return 'No Card';
      case PenaltyCard.yellow:
        return 'Yellow Card';
      case PenaltyCard.red:
        return 'Red Card';
    }
  }

  Color? get color {
    switch (this) {
      case PenaltyCard.none:
        return null;
      case PenaltyCard.yellow:
        return Colors.yellow;
      case PenaltyCard.red:
        return Colors.red;
    }
  }
}
