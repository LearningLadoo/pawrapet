import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase/firestore.dart';
import '../../utils/constants.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/location.dart';
import '../../utils/widgets/appBar.dart';
import '../../utils/widgets/common.dart';
import '../../utils/widgets/displayText.dart';
import 'utils/widgets/feedWidgets.dart';

///
/// the feed or the post input
/// {
///   profile: {the profile details} // check [profileScreen.dart] page for more details
///   status: finding_partner, or something else
///   date: the date of posting
///   uidPN:
///   requestedUsersForMatch: {<user1>:true,<user2>:false} // list of all the active users that this user has liked and not confirmed the date for mating or removed. its more like current active likes.
///   v:1 // first version
/// }
class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool? isPositionAvailable;

  @override
  Widget build(BuildContext context) {
    isPositionAvailable = xSharedPrefs.matingFilterMap?['position'] != null;

    return Column(
      children: [
        AbsorbPointer(
          absorbing: isPositionAvailable != true,
          child: XAppBar(
            AppBarType.home,
          ),
        ),
        if (isPositionAvailable != true)
          getLocationPermissionWidget(() {
            setState(() {});
          }),
        if (isPositionAvailable == true) PostsListWidget(),
      ],
    );
  }
}

class PostsListWidget extends StatefulWidget {
  const PostsListWidget({super.key});

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  bool fetchingNew = false;
  List<DocumentSnapshot> posts = [];
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchInitialPosts(),
        builder: (context, snap) {
          // handle the process
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: dogWaitLoader("Fetching profiles..."));
          } else if (snap.hasError) {
            return xErrorText(context, "faced some error, please try again later.");
          } else {
            // handle no profile found
            if (posts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(xSize / 2),
                child: xInfoText(
                  context,
                  "Sorry we couldn't find any mating posts. Please try updating your filters.",
                ),
              );
            }
            // display profiles
            return Expanded(
              child: RefreshIndicator(
                onRefresh: fetchInitialPosts,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: posts.length + 1,
                  // one more for the loader
                  padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    /// returns loader if the index is last and fetching new
                    if (index == posts.length) {
                      if (fetchingNew) {
                        return dogWaitLoader("Fetching profiles...");
                      } else {
                        return const Center();
                      }
                    } else {
                      Map data = (posts[index].data() as Map);
                      xPrint("index = $index", header: "PostsListWidget");
                      return Padding(
                        padding: EdgeInsets.only(bottom: xSize / 2),
                        child: FindingPartnerWidget(postDetails: data),
                      );
                    }
                  },
                ),
              ),
            );
          }
        });
  }

  Future<void> fetchInitialPosts() async {
    posts = await FirebaseCloudFirestore().getInitialMatingProfiles(xSharedPrefs.matingFilterMap);
  }

  Future<void> fetchNextPosts() async {
    setState(() {
      fetchingNew = true;
    });
    // List<DocumentSnapshot> newPosts = (await FirebaseCloudFirestore().getNextMatingProfiles(xSharedPrefs.matingFilterMap!, posts));
    // xPrint(newPosts.toString(), header: "fetchNextPosts");
    // posts.addAll(newPosts);
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      fetchingNew = false;
    });
  }

  void _scrollListener() {
    xPrint("the extent of controller = ${scrollController.position.extentAfter}", header: "feed/_scrollListener");
    if (scrollController.position.extentAfter < 500 && fetchingNew == false) {
      fetchNextPosts();
    }
  }
}
