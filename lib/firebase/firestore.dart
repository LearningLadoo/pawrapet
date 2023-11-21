import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../utils/functions/common.dart';

class FirebaseCloudFirestore {
  // variables
  late FirebaseFirestore db;
  late CollectionReference<Map<String, dynamic>> collectionUID;
  late CollectionReference<Map<String, dynamic>> collectionUser;

  //constructor
  FirebaseCloudFirestore() {
    db = FirebaseFirestore.instance;
    collectionUID = db.collection("UIDs");
    collectionUser = db.collection("users");
  }

  // get user details from UID
  Future<Map?> getUserDetailsFromUID(String uid) async {
    final docSnapshot = await collectionUID.doc(uid).get();
    if (docSnapshot.exists) {
      // get user Map
      return docSnapshot.data();
    } else {
      return null;
    }
  }

  // to update if the FCM token changes
  Future<bool> updateNotificationId(String uid, String deviceId, String token) async {
    try {
      await collectionUID.doc(uid).update({
        "devices.$deviceId.notificationId": token,
      });
      return true;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/updateNotificationId');
      return false;
    }
  }

  /// add to profile update logs then on create cloud function will trigger and save details
  Future<bool> addNewProfile(String uidPN, Map<String, dynamic> profileMap) async {
    try {
      await collectionUser.doc(uidPN).collection('profileUpdateLogs').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(profileMap);
      return true;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/addNewProfile');
      return false;
    }
  }
}
