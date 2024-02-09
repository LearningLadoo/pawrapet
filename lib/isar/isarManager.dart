import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'notificationMessage/notificationMessage.dart';
import 'profile/profile.dart';

bool _inspect = true;

// initialize this variable in the startup
class IsarManager {
  late Isar _db;

  // initialize
  Future<void> initialize() async {
    _db = await openDB();
  }

  // getter
  Isar get db => _db;

  // open the collection
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [NotificationMessageSchema, ProfileSchema],
        inspector: _inspect,
        name: "v1",
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // delete all
  Future<void> clearAll() async {
    _db.close(deleteFromDisk: true);
  }
}
