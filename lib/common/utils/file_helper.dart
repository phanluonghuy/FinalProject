import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FileHelper {
  Future<String> readFileContent(String path) async {
    try {
      File file = File(path);

      // Check if the file exists before attempting to read it
      if (!await file.exists()) {
        return ('File not found at path: $path');
      }

      // Read the file as a string
      String content = await file.readAsString();
      return content;
    } catch (e) {
      // Handle any exceptions that might occur
      return ('Error reading file at path: $path. Details: $e');
    }
  }

  Future<String?> pickFilePath() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path;
      } else {
        // User canceled the picker
        print('File picking was canceled');
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error picking file: $e');
      return null;
    }
  }
}
