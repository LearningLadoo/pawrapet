import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/functions/common.dart';

int postFetchLimit = 10;

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

  /// merges the provided map with current map and then sends the request to update

  Future<bool> fetchMergeUpdateProfile(String uidPN, Map<String, dynamic> map) async {
    // fetch
    try {
      Map<String, dynamic> profileMap = (await getProfileDetails(uidPN))!;
      profileMap.addAll(map);
      xPrint("profileMap $profileMap", header: 'FirebaseCloudFirestore/fetchMergeUpdateProfile');
      bool temp = await updateProfile(uidPN, profileMap);
      xPrint("update profile bool $temp", header: 'FirebaseCloudFirestore/fetchMergeUpdateProfile');
      return temp;
    } catch (e) {
      xPrint(e.toString(), header: 'FirebaseCloudFirestore/fetchMergeUpdateProfile');
      return false;
    }
  }

  Future<bool> updateCenterCodes(String uidPN, List<String> centerCodes) async {
    return await fetchMergeUpdateProfile(uidPN, {"centerCodes": centerCodes});
  }

  Future<bool> updateIsFindingMate(String uidPN, bool isFindingMate) async {
    return await fetchMergeUpdateProfile(uidPN, {"isFindingMate": isFindingMate});
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
  // <this will be trigger with on create in mating requests>
  // send notifications to both that this user liked the other user
  // update the requestedUsersForMatch in the user details
  // check if the other user also liked then
  // send the notification that the match is created
  // create session id in the collection mating if not present
  // mating session sub collection
  Future<bool> updateMatingReq(
      {required bool req, // if this user has requested or not
      required String myUidPN,
      required String frndsUidPN,
      required String myName,
      required String frndsName,
      required String myIcon,

      /// icon url
      required String frndsIcon,

      /// icon url
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

  Future<List<DocumentSnapshot>?> getMatingProfiles(Map? filters, List<DocumentSnapshot> prePosts) async {
    try {
      xPrint("get Mating Profiles ran $prePosts", header: "getMatingProfiles");
      await Future.delayed(Duration(seconds: 4));
      // if(prePosts.length==9) throw "fake error";
      // create the query
      Query query = getQueryFromFilterMap(collectionUser, filters);
      xPrint("the query is ${query.parameters}", header: "getMatingProfiles");
      // Query query = collectionUser;
      // if prePosts is empty then fetch initial posts else the next posts
      final result = (await (prePosts.isEmpty ? query.limit(postFetchLimit).get() : query.limit(postFetchLimit).startAfterDocument(prePosts.last).get())).docs;
      xPrint(" result - > ${result}", header: "getMatingProfiles");
      return result;
    } catch (e) {
      xPrint(e.toString(), header: "getMatingProfiles");
      return null;
    }
  }
}

Query getQueryFromFilterMap(CollectionReference parentCollection, Map? filters) {
  Query query = parentCollection;
  if (filters != null) {
    xPrint("the filter is ${filters}", header: "getQueryFromFilterMap");
    // to fulfil the security rules
    query = query.where("isFindingMate", isEqualTo: true);
    // to not
    if (filters["centerCodes"] != null && filters["centerCodes"].isNotEmpty) {
      xPrint("adding centerCodes to query ${filters['centerCodes']}", header: "getQueryFromFilterMap");
      query = query.where("centerCodes", arrayContainsAny: List<String>.from(filters["centerCodes"]));
    }
    if (filters["amountRange"] != null && filters["amountRange"].isNotEmpty) {
      xPrint("adding amountRange to query ${filters['amountRange']}", header: "getQueryFromFilterMap");

      double chargesRangeStart = filters["amountRange"][0];
      double chargesRangeEnd = filters["amountRange"][1];
      // handling end
      if (chargesRangeEnd == 51) {
        // no upper limit
      } else {
        // amount <= n*1000
        query = query.where("amount", isLessThanOrEqualTo: chargesRangeEnd * 1000);
      }
      // handling start
      if (chargesRangeStart == 51) {
        // amount > 50*1000
        query = query.where("amount", isGreaterThan: 50 * 1000);
      } else {
        // amount >= n*1000
        query = query.where("amount", isGreaterThanOrEqualTo: chargesRangeStart * 1000);
      }
    }
    if (filters["breeds"] != null && filters["breeds"].isNotEmpty) {
      xPrint("adding breed to query ${filters['breeds']}", header: "getQueryFromFilterMap");

      query = query.where("breed", whereIn: filters["breeds"]);
    }
    // todo filters for colors and genders is not working; only one "where in" can be used
    Filter? colorFilter;
    if (filters["colors"] != null && filters['colors'].isNotEmpty) {
      xPrint("adding colors to query ${filters['colors']}", header: "getQueryFromFilterMap");
      if (filters['colors'].length == 1) {
        query = query.where("color", isEqualTo: filters["colors"][0]);
      }
      else if (filters['colors'].length <= 2) {
        // its just a workaround to not let the user feel any change
        colorFilter = Filter.or(
          Filter("color", isEqualTo: filters["colors"]?[0]),
          Filter("color", isEqualTo: filters["colors"]?[1]),
        );
        query = query.where(colorFilter);
      }else if (filters['colors'].length <= 3) {
        // its just a workaround to not let the user feel any change
        colorFilter = Filter.or(
          Filter("color", isEqualTo: filters["colors"]?[0]),
          Filter("color", isEqualTo: filters["colors"]?[1]),
          Filter("color", isEqualTo: filters["colors"]?[2]),
        );
        query = query.where(colorFilter);
      }else if (filters['colors'].length <= 4) {
        // its just a workaround to not let the user feel any change
        colorFilter = Filter.or(
          Filter("color", isEqualTo: filters["colors"]?[0]),
          Filter("color", isEqualTo: filters["colors"]?[1]),
          Filter("color", isEqualTo: filters["colors"]?[2]),
          Filter("color", isEqualTo: filters["colors"]?[3]),
        );
        query = query.where(colorFilter);
      }else if (filters['colors'].length <= 5) {
        // its just a workaround to not let the user feel any change
        colorFilter = Filter.or(
          Filter("color", isEqualTo: filters["colors"]?[0]),
          Filter("color", isEqualTo: filters["colors"]?[1]),
          Filter("color", isEqualTo: filters["colors"]?[2]),
          Filter("color", isEqualTo: filters["colors"]?[3]),
          Filter("color", isEqualTo: filters["colors"]?[4]),
        );
        query = query.where(colorFilter);
      }
    }
    if (filters["genders"] != null && filters['genders'].isNotEmpty) {
      xPrint("adding genders to query ${filters['genders']}", header: "getQueryFromFilterMap");
      if (filters["genders"].length == 1) {
        query = query.where("gender", isEqualTo: filters["genders"][0]);
      } else {
        Filter genderFilter = Filter.or(
          Filter("gender", isEqualTo: filters["genders"]?[0]),
          Filter("gender", isEqualTo: filters["genders"]?[1]),
        );
        if(colorFilter!=null){
          query = query.where(Filter.and(genderFilter, colorFilter));
        } else {
          // only one filter of or there
          query = query.where(genderFilter);
        }
      }
    }
  }
  return query;
}
