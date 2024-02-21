import 'package:cloud_firestore/cloud_firestore.dart';
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
      await collectionUID.doc(uid).collection("devices").doc(deviceId).update({
        "notificationId": token,
      });
      return true;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/updateNotificationId');
      return false;
    }
  }

  /// add to profile update logs then on create cloud function will trigger and save details
  Future<bool> updateProfile(String uidPN, Map<String, dynamic> profileMap) async {
    try {
      await collectionUser.doc(uidPN).collection('profileUpdateLogs').doc(DateTime.now().millisecondsSinceEpoch.toString()).set(profileMap);
      return true;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/updateProfile');
      return false;
    }
  }

  // fetch the profile details
  Future<Map<String, dynamic>?> getProfileDetails(String uidPN) async {
    try {
      final userDoc = await collectionUser.doc(uidPN).get();
      return (userDoc.exists ? userDoc.data() : null);
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/getProfileDetails');
      return null;
    }
  }

  // update the mating request
  Future<bool> updateMatingReq(
      {required bool req,
      required String myUidPN,
      required String frndsUidPN,
      required String myName,
      required String frndsName,
      required String myIcon,
      required String frndsIcon,
      required String myUsername,
      required String frndsUsername}) async {
    try {
      await collectionUser.doc(myUidPN).collection('matingRequests').doc(frndsUidPN).set({
        "request": req,
        'myUidPN': myUidPN,
        'frndsUidPN': frndsUidPN,
        'myName': myName,
        'frndsName': frndsName,
        'myUsername': myUsername,
        'frndsUsername': frndsUsername,
        'myIcon': myIcon,
        'frndsIcon': frndsIcon,
      });
      return true;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/updateMatingReq');
      return false;
    }
  }

  Future<List<DocumentSnapshot>> getInitialMatingProfiles(Map? filters) async {
    try {
      xPrint("initialised", header: "getInitialMatingProfiles");

      // if the filters are null then fetch all the possible profiles
      Query query = getQueryFromFilterMap(filters);
      query = query.where("isFindingMate", isEqualTo: true);
      // todo need to order by amount because of restriction of firebase
      // todo this doesn't work because next order by works only on profiles with same amount
      // todo you have 2 solutions, either fetch all the profiles or leave the amount filter.
      // todo decided to fetch all the profiles
      // query.orderBy("amount").orderBy("lastProfileUpdated");
      return (await query.limit(1000).get()).docs;
    } catch (e) {
      xPrint(e.toString(), header: "getInitialMatingProfiles");
      return [];
    }
  }

  Future<List<DocumentSnapshot>?> getMatingProfiles(Map? filters, List<DocumentSnapshot> prePosts) async {
    try {
      xPrint("get Mating Profiles ran", header: "getMatingProfiles");
      await Future.delayed(Duration(seconds: 10));
      // if(prePosts.length==9) throw "fake error";
      // create the query
      // Query query = getQueryFromFilterMap(filters);
      // query = query.where("isFindingMate", isEqualTo: true);
      Query query = collectionUser;
      // if prePosts is empty then fetch initial posts else the next posts
      return (await (prePosts.isEmpty ? query.limit(4).get() : query.limit(4).startAfterDocument(prePosts.last).get())).docs;
    } catch (e) {
      xPrint(e.toString(), header: "getMatingProfiles");
    }
  }

  Query getQueryFromFilterMap(Map? filters) {
    Query query = collectionUser;
    if (filters != null) {
      if (filters["centerCodes"] != null) {
        query = query.where("centerCodes", whereIn: filters["centerCodes"]);
      }
      if (filters["amountRange"] != null) {
        double chargesRangeStart = filters["amountRange"][0];
        double chargesRangeEnd = filters["amountRange"][1];
        // handling end
        if (chargesRangeEnd == 0) {
          // amount == null or 0
          query = query.where(Filter.or(Filter("amount", isNull: true), Filter("amount", isEqualTo: 0)));
        } else if (chargesRangeEnd == 51) {
          // no upper limit
        } else {
          // amount <= n*1000
          query = query.where("amount", isLessThanOrEqualTo: chargesRangeEnd * 1000);
        }
        // handling start
        if (chargesRangeStart == 51) {
          // amount > 50*1000
          query = query.where("amount", isGreaterThan: 50 * 1000);
        } else if (chargesRangeStart == 0) {
          // amount can be null or 0
          query = query.where(Filter.or(Filter("amount", isNull: true), Filter("amount", isEqualTo: 0)));
        } else {
          // amount >= n*1000
          query = query.where("amount", isGreaterThanOrEqualTo: chargesRangeStart * 1000);
        }
      }
      if (filters["breed"] != null) {
        query = query.where("breed", whereIn: filters["breed"]);
      }
      if (filters["colors"] != null) {
        query = query.where("colors", whereIn: filters["colors"]);
      }
      if (filters["genders"] != null) {
        query = query.where("genders", whereIn: filters["genders"]);
      }
    }
    return query;
  }
}
