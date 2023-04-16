import 'robot_action.dart';

class Event {
  Duration timeSince;
  RobotAction action;
  int position;

  Event({
    required this.timeSince,
    required this.action,
    required this.position,
  });

  factory Event.fromJson(List<dynamic> json) {
    return Event(
      timeSince: Duration(seconds: json[0]),
      action: RobotAction.values[json[1]],
      position: json[2],
    );
  }

  List<dynamic> toJson() => [
        timeSince.inSeconds,
        action.index,
        position,
      ];

  void debugLogDescription() {
    print("timeSince: $timeSince, action: ${action.name}, position: $position");
  }
}
