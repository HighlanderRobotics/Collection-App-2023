# 8033 FRC Collection App 2023

To build, open folder in VSCode or Android Studio. Make sure to build using dart and flutter dev tools (Use flutter doctor to check status of flutter). 

# ScoutReport Objects

## Auton Charge Station

| Index | Localized Description | Long Localized Description                                                                           |
|-------|-----------------------|------------------------------------------------------------------------------------------------------|
| 0     | No Climb              | Did not attempt to climb                                                                             |
| 1     | Docked                | The charge station is balanced and signaled by the LED's being lit |
| 2     | Engaged               | The charge station is tipped, but the robots are fully supported by the charge station and not touching the ground      |
| 3     | Failed                | The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful              |
| 4     | Mobility              | The robot left the community during auto                                                             |

## Teleop Charge Station

| Index | Localized Description | Long Localized Description                                                                           |
|-------|-----------------------|------------------------------------------------------------------------------------------------------|
| 0     | No Climb              | Did not attempt to climb                                                                             |
| 1     | Docked                | The charge station is balanced and signaled by the LED's being lit |
| 2     | Engaged               | The charge station is tipped, but the robots are fully supported by the charge station and not touching the ground      |
| 3     | Failed                | The robot was attempting to Dock or Engage with the Charge Station but was unsuccessful              |
| 4     | In Community          | The robot did not attempt to climb, but still was in the community                                   |


## Robot Actions

| Index | Localized Description  |
|-------|------------------------|
| 0     | Picked Up Cube         |
| 1     | Picked Up Cone         |
| 2     | Placed Object          |
| 3     | Dropped Object         |
| 4     | Delivered to Team      |
| 5     | Start Defense          |
| 6     | End Defense            |
| 7     | Crossed Community Line |
| 8     | Starting Position      |

## Positions

```dart
7, 8, 9
4, 5, 6
1, 2, 3
```

#### Auto-Specific Positions

| Index | Localized Description |
|-------|-----------------------|
| 10    | Crossed Cable         |
| 11    | Crossed Charge Pad    |
| 12    | Crossed Near Barrier  |

#### Middle Cargo
```dart
13 |
14 |
15 |
16 |
```

#### Field Starting Positions

| Index | Localized Description |
|-------|-----------------------|
| 17    | tag id 3              |
| 18    | tag id 2              |
| 19    | tag id 1              |

## Field Orientation Direction

| Index | Localized Description |
|-------|-----------------------|
| 0     | left                  |
| 1     | right                 |

## Robot Role

| Index | Localized Description |
|-------|-----------------------|
| 0     | Offense               |
| 1     | Defense               |
| 2     | Feeder                |
| 3     | Immobile              |

## Driver Ability
### Localized Description to Index to Long Localized Description

| Index | Localized Description | Long Localized Description                                                                                                |
|-------|-----------------------|---------------------------------------------------------------------------------------------------------------------------|
| 0     | Terrible              | This driver cannot control the robot at all. They are a danger to everyone around them.                                   |
| 1     | Poor                  | This driver struggles to keep the robot under control. They make many mistakes and are not very reliable.                 |
| 2     | Average               | This driver can operate the robot competently. However, they are not particularly skilled or exceptional.                 |
| 3     | Good                  | This driver can operate the robot with skill and precision. They are reliable and make few mistakes.                      |
| 4     | Great                 | This driver can operate the robot with mastery. They are highly skilled, precise, and efficient and they can think ahead. |

## Penalty Cards

| Index | Localized Description |
|-------|-----------------------|
| 0     | No Card               |
| 1     | Yellow Card           |
| 2     | Red Card              |
