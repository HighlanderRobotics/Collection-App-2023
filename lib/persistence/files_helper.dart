import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/match_data.dart';
import '../models/previous_matches_info.dart';
import '../networking/scouting_server_api.dart';

class FilesHelper {
  late Directory directory;

  FilesHelper() {
    getApplicationDocumentsDirectory().then((value) => directory = value);
  }

  Future<bool> saveAndUploadMatchData(MatchData matchData,
      {bool ignoreNetworkAddScoutReport = false}) async {
    try {
      if (!ignoreNetworkAddScoutReport) {
        await ScoutingServerAPI.shared.addScoutReport(matchData);
      }

      matchData.hasSavedToCloud.value = true;
      await deleteFile(matchData.uuid);
    } catch (e) {
      if (e.toString() == "HTTP 406 response") {
        print("Match data already exists on server");
        matchData.hasSavedToCloud.value = true;
        await deleteFile(matchData.uuid);
      } else {
        print("Error uploading match data: $e");
        matchData.hasSavedToCloud.value = false;
      }
    }

    await writeToFile(matchData);

    return matchData.hasSavedToCloud.value;
  }

  Future<void> writeToFile(MatchData matchData) async {
    String path = directory.path;

    var filePath = "$path/frc-${matchData.uuid}.json";
    print("Writing to file: $filePath");
    File file = File(filePath);
    file.writeAsString(jsonEncode(
        matchData.toJson(includeUploadStatus: true, usesTBAKey: false)));
    print("Successfully wrote to file: $filePath");
  }

  Future<List<FileSystemEntity>> getFilesInDirectoryMask() {
    return directory.list().toList();
  }

  bool _isFileValid(File file) {
    return file.uri.pathSegments.last.substring(0, 4).contains("frc-");
  }

  Future<PreviousMatchesInfo> getPreviousMatches() async {
    final List<FileSystemEntity> allFiles = await getFilesInDirectoryMask();
    final List<File> files = allFiles.whereType<File>().toList();
    var matches = PreviousMatchesInfo([], 0);

    for (var file in files) {
      if (_isFileValid(file)) {
        final String contents = await file.readAsString();
        try {
          final MatchData match = MatchData.fromJson(jsonDecode(contents));
          matches.validMatches.add(match);
        } catch (_) {
          print(
              "Error parsing file: ${file.uri.pathSegments.last} Invalid Format");
          matches.numberOfInvalidFiles++;
        }
      } else if (!file.uri.pathSegments.last.startsWith(".")) {
        matches.numberOfInvalidFiles++;
      }
    }

    return matches;
  }

  Future<void> deleteFile(String uuid) async {
    String path = directory.path;

    var filePath = "$path/frc-$uuid.json";

    try {
      final file = await File(filePath).delete();
      print("Successfully deleted file: ${file.path}");
    } catch (e) {
      print("Error deleting file: $filePath");
    }
  }
}
