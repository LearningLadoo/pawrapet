import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedProvider extends ChangeNotifier {
  List<DocumentSnapshot>? _posts; // null means not fetched, [] means not found
  bool _isFetching = false;

  List<DocumentSnapshot>? get posts => _posts;

  bool get isFetching => _isFetching;

  void addPosts(List<DocumentSnapshot> newPosts) {
    _posts = [..._posts ?? [], ...newPosts];
    notifyListeners();
  }
  void resetPosts(){
    _posts = null;
  }

  void updateIsFetching(bool isFetching, {bool notify = true}) {
    _isFetching = isFetching;
    if (notify) notifyListeners();
  }
}
