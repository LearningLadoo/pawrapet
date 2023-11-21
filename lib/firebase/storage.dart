import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../utils/extensions/map.dart';
import '../utils/functions/common.dart';
import '../utils/functions/paths.dart';

class FirebaseCloudStorage {
  // variables
  late FirebaseStorage db;
  String _firebaseStoragePath = "https://firebasestorage.googleapis.com/v0/b/pawrapets.appspot.com/o";

  FirebaseCloudFirestore() {
    db = FirebaseStorage.instance;
  }

  /// add to profile update logs then on create cloud function will trigger and save details
  ///  returns assets Map with final values
  ///  if url == [delete] then delete the image from cloud,
  ///  if url == [add] then add to the cloud and return a new url
  ///  else if url != null then do nothing
  ///  make sure the images are already saved in local storage
  ///  the urls are fetched so that they can be used in publishing the profile details
  Future<Map?> addProfileImages(String uidPN, Map<String, dynamic> assets) async {
    List<Future<String?>> promises = [];
    Map tempMap = assets.deepClone();
    try {
      // add the promises for whatever the operation is
      assets.keys.map((i) {
        String relFilePathInBucket = "users/$uidPN/$i.${assets[i]['ext']}";
        String localFilePath = getProfileImagesPath(profileNo: int.parse(uidPN.split("_")[1]), type: i.split("_")[0], index: int.parse(i.split("_")[1]), ext: assets[i]['ext']);
        switch (assets[i]['url']) {
          case 'remove':
            promises.add(removeAsset(relFilePathInBucket));
            break;
          case 'add':
            promises.add(addAsset(relFilePathInBucket, File(localFilePath)));
            break;
          default:
            promises.add(Future<String?>.value(null));
        }
      });
      List<String?> outputs = await Future.wait(promises);
      // assign in the cloned map
      int j = 0;
      assets.keys.map((i){
        switch (assets[i]['url']) {
          case 'add':
            tempMap[i]['url'] = outputs[j];
            break;
          case 'remove':
          default:
          tempMap[i]['url'] = null;
        }
        j++;
      });
      return tempMap;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudStorage/addProfileImages');
      return null;
    }
  }

  /// relative path example -
  /// users/000<uidPN>/profile/icon_0.jpg
  Future<String?> removeAsset(String relativePath) async {
    try {
      await db.ref().child(relativePath).delete();
      return "success";
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudStorage/removeAsset');
      return null;
    }
  }

  /// relative path example -
  /// users/000<uidPN>/profile/icon_0.jpg
  /// return the url
  Future<String?> addAsset(String relativePath, File file) async {
    try {
      await db.ref().child(relativePath).putFile(file);
      return await db.ref().child(relativePath).getDownloadURL();
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudStorage/addAsset');
      return null;
    }
  }
}
