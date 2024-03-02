import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../firebase/firestore.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/sizedBox.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/location.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/buttons.dart';
import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';
import 'preferences.dart';
import 'utils/widgets/feedWidgets.dart';

/// the feed input
/// {
/// profile details,
/// uidPN,
/// requestedUsersForMatch {(uidPN: true) or nothing}
/// }
class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool gettingLocation = false;
  List<DocumentSnapshot> posts = [];

  @override
  Widget build(BuildContext context) {
    xPrint("build called", header: 'Feed');

    // xSharedPrefs.setPositionInMatingFilters(null);
    // xSharedPrefs.setCenterCodesInMatingFilters(null);
    // redirect from here to setup preferences if mating centers are not selected
    return Column(
      children: [
        XAppBar(
          AppBarType.home,
        ),
        (xSharedPrefs.matingFilterMap?['position'] != null && xSharedPrefs.matingFilterMap?['centerCodes'] != null && xSharedPrefs.matingFilterMap?['centerCodes'].isNotEmpty)
            ? PostsListWidget()
            : PreferencesWithLocationHandler(
                displayPartnersProfile: false,
              )
      ],
    );
  }
}

class PostsListWidget extends StatefulWidget {
  PostsListWidget({super.key});

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  List<DocumentSnapshot>? _posts; // null means not fetched, [] means not found
  bool _isFetching = false;
  bool _noMoreNewPosts = false;

  @override
  Widget build(BuildContext context) {

    // fetch if not present
    if (_posts == null) {
      xPrint("posts == null called", header: "PostsListWidget");

      fetchInitialPosts();
      return Expanded(
        child: Center(
          child: dogWaitLoader("Fetching profiles..."),
        ),
      );
    } else if (_posts!.isEmpty) {
      xPrint("posts == empty called", header: "PostsListWidget");

      return FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(xSize / 2),
          child: xInfoText(
            context,
            "Sorry we couldn't find any mating posts. Please try updating your preferences.",
          ),
        ),
      );
    } else {
      xPrint("posts is not empty called", header: "PostsListWidget");

      return Expanded(
        child: RefreshIndicator(
          onRefresh: refreshPosts,
          child: ListView.builder(
            itemCount: _posts!.length + 1,
            // one more for recursion
            padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              xPrint("the widget ${index} ", header: "PostsListWidget");

              /// returns future loader if the index is last and fetching new
              if (index == _posts!.length) {
                fetchNextPosts(context);
                return (_isFetching && !_noMoreNewPosts) ? dogWaitLoader("Fetching more profiles...") : xInfoText(context, "No more posts found, please refresh ↻ ");
              } else {
                Map<String, dynamic> temp = _posts![index].data() as Map<String, dynamic>;
                // padding uidPN in the map
                temp.addAll({"uidPN": _posts![index].id});
                return Padding(
                  padding: EdgeInsets.only(bottom: xSize / 2),
                  child: FindingPartnerWidget(feedMap: temp),
                );
              }
            },
          ),
        ),
      );
    }
  }

  // fetch initial posts
  Future<void> fetchInitialPosts() async {
    await Future.delayed(Duration(seconds: 0));
    xPrint("fetch initial 1", header: "fetchInitialPosts");

    List<DocumentSnapshot>? newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, _posts ?? []);
    xPrint("fetch initial 2", header: "fetchInitialPosts");
    // make sure that there are no quick profiles
    List<DocumentSnapshot> temp = [];
    if (newPosts != null) {
      for (final i in newPosts) {
        if (i.data() != null && (i.data() as Map<String, dynamic>)["assets"]!["main_0"]["url"] != null) {
          temp.add(i);
        }
      }
    }
    newPosts = temp;
    _posts = _posts ?? [];
    _posts!.addAll(newPosts ?? []);
    xPrint("fetch initial 3 ${_posts?.length}", header: "fetchInitialPosts");
    setState(() {});
  }

  // refresh posts
  Future<void> refreshPosts() async {
    // resetting variables
    _noMoreNewPosts = false;
    _posts = [];
    // fetching posts
    final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, []);
    setState(() {
      _posts!.addAll(newPosts ?? []);
    });
  }

  // fetchNextPosts
  Future<void> fetchNextPosts(BuildContext context) async {
    try {
      if (_posts != null && _posts!.length < postFetchLimit) {
        _noMoreNewPosts = true;
      }
      if (!_isFetching && !_noMoreNewPosts) {
        xPrint("now we will fetch next posts", header: "fetchNextPosts");
        await Future.delayed(Duration(seconds: 0));
        xPrint("fetch 1", header: "fetchNextPosts");

        _isFetching = true;
        setState(() {});
        xPrint("fetch 2", header: "fetchNextPosts");

        final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, _posts ?? []);
        xPrint("fetch 3", header: "fetchNextPosts");

        if ((_posts != null && _posts!.isNotEmpty) && (newPosts == null || newPosts.isEmpty)) {
          xPrint("fetch 3.5", header: "fetchNextPosts");

          _noMoreNewPosts = true;
          _isFetching = false;
          setState(() {});

          return;
        }
        _isFetching = false;
        xPrint("fetch 4", header: "fetchNextPosts");

        _posts!.addAll(newPosts ?? []);
        setState(() {});
        xPrint("getting more posts", header: "fetchNextPosts");
      }
    } catch (e) {
      xPrint(e.toString(), header: "fetchNextPosts");
    }
  }
}
