# 8033 FRC Collection App 2023

To build, open folder in VSCode or Android Studio. Make sure to build using dart and flutter dev tools (Use flutter doctor to check status of flutter). 

# ScoutReport Objects

## Climbing Result
```dart
0 = No Climb
1 = Supported
2 = Charged
3 = Failed
4 = In Community
```

## Robot Actions
```dart
0 = Picked up Cube
1 = Picked up Cone
2 = Placed Object
3 = Dropped Object
4 = Delivered to Team
5 = Start Defense
6 = End Defense
7 = Crossed Community Line
8 = Starting Position
```

## Positions
```dart
7, 8, 9
4, 5, 6
1, 2, 3
```

#### Auto-Specific Positions
```dart
10 = Crossed Cable
11 = Crossed Charge Pad
12 = Crossed Near Barrier
```

#### Middle Cargo
```dart
13 |
14 |
15 |
16 |
```

#### Field Starting Positions
```dart
17 = tag id 3
18 = tag id 2
19 = tag id 1
```

## Field Orientation Direction
```dart
0 = left
1 = right
```

## Robot Role
```dart
0 = Offense
1 = Defense
2 = Feeder
```
