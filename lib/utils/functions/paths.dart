import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../constants.dart';

// local directory path
Future<void> gettingLocalPath() async {
  // getting location where all the data of app is stored
  final d = await getExternalStorageDirectory();
  /// use getExternal directory for debugging and application doc dir for deployment, idk why await Permission.storage.isGranted was given before accessing directory
  xLocalPath = d!.path;
}

// file structure
/// myPets
///   -> <username_of_pet>
///     -> records
///       -> <date>
///         -> reports_1.jpg
///         -> reports_2.jpg
///         -> docs_1.pdf
///         -> bills_1.jpg
///         -> other_1.pdf
///     -> profile
///       -> icon_0.jpg
///       -> main_0.jpg
///     -> posts
enum ProfileImageType { icon, main }

String getProfileImagesPath({required String username, required ProfileImageType type, int index = 0, String ext = "jpg"}) {
  String dir = "$xLocalPath/myPets/$username/profile";
  // creating directory if it doesn't exist
  if (!Directory(dir).existsSync()) {
    Directory(dir).createSync(recursive: true);
  }
  return "$dir/${type.name}_$index.$ext";
}
