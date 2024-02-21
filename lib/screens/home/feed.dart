import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../firebase/firestore.dart';
import '../../providers/feedProvider.dart';
import '../../utils/constants.dart';
import '../../utils/functions/common.dart';
import '../../utils/functions/location.dart';
import '../../utils/functions/toShowWidgets.dart';
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
// /// }
// class Feed extends StatefulWidget {
//   const Feed({Key? key}) : super(key: key);
//
//   @override
//   State<Feed> createState() => _FeedState();
// }
//
// class _FeedState extends State<Feed> {
//   bool? isPositionAvailable;
//   List<DocumentSnapshot> posts = [];
//
//   @override
//   Widget build(BuildContext context) {
//     isPositionAvailable = xSharedPrefs.matingFilterMap?['position'] != null;
//
//     return Column(
//       children: [
//         AbsorbPointer(
//           absorbing: isPositionAvailable != true,
//           child: XAppBar(
//             AppBarType.home,
//           ),
//         ),
//         if (isPositionAvailable != true)
//           getLocationPermissionWidget(() {
//             setState(() {});
//           }),
//         if (isPositionAvailable == true)
//           FutureBuilder(
//               future: fetchPosts(),
//               builder: (context, snap) {
//                 // handle the process
//                 if (snap.connectionState == ConnectionState.waiting) {
//                   return Center(child: dogWaitLoader("Fetching profiles..."));
//                 } else if (snap.hasError) {
//                   return xErrorText(context, "faced some error, please try again later.");
//                 } else {
//                   // final newPosts = snap.data ?? [];
//                   // // handle no profile found
//                   // if (newPosts.isEmpty) {
//                   //   return Padding(
//                   //     padding: const EdgeInsets.all(xSize / 2),
//                   //     child: xInfoText(
//                   //       context,
//                   //       posts.isEmpty ? "Sorry we couldn't find any mating posts. Please try updating your filters." : "No more results for your filters found.",
//                   //     ),
//                   //   );
//                   // }
//                   // posts = newPosts;
//                   //display profiles
//                   return SizedBox(
//                     height: xHeight,
//                     child: ListView.builder(
//                       itemCount: posts.length + 1,
//                       // one more for recursion
//                       padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
//                       // physics: const NeverScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//
//                         /// returns future loader if the index is last and fetching new
//                         if (index == posts.length) {
//                           // fetchPosts();
//                   return Center(child: dogWaitLoader("Fetching profiles..."));
//                         } else {
//
//                           xPrint("the widget ${posts[index].id}", header: "PostsListWidget");
//                           return Padding(
//                             padding: EdgeInsets.only(bottom: xSize / 2),
//                             child: displayWidget(index),
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 }
//               })
//         // Expanded(
//         //
//         //   // child: PostsListWidget(),
//         //   // child: SingleChildScrollView(child: PostsListWidget()),
//         // ),
//       ],
//     );
//   }
//   Widget displayWidget(int index){
//     xPrint("index = $index",header: "displayWidget");
//     return FindingPartnerWidget(postDetails: (posts[index].data() as Map));
//   }
//   Future<void> fetchPosts() async {
//     final next = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, posts);
//     if(next!=null&&next.isNotEmpty)posts.addAll(next);
//     // setState(() {
//     //
//     // });
//   }
// }
class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool? isPositionAvailable;
  List<DocumentSnapshot> posts = [];

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
        if (isPositionAvailable == true)
          Expanded(
            child: PostsListWidgetD(),
          ),
      ],
    );
  }
}

class PostsListWidgetD extends StatelessWidget {
  PostsListWidgetD({super.key});
  late FeedProvider feedProvider, feedProviderListen;
  @override
  Widget build(BuildContext context) {
     feedProvider = Provider.of<FeedProvider>(context, listen: false);
     feedProviderListen = Provider.of<FeedProvider>(context, listen: true);

     // fetch if not present
     if (feedProviderListen.posts == null) {
       fetchPosts();
       return Center(child: dogWaitLoader("Fetching profiles..."));
     } else if (feedProviderListen.posts!.isEmpty) {
       return Padding(
         padding: const EdgeInsets.all(xSize / 2),
         child: xInfoText(
           context,
           "Sorry we couldn't find any mating posts. Please try updating your filters.",
         ),
       );
     } else {
       return Expanded(
         child: (feedProviderListen.isFetching)
             ? Text("isfetching")
             : RefreshIndicator(
           onRefresh: refreshPosts,
           child: ListView.builder(
             itemCount: feedProviderListen.posts!.length + 1,
             // one more for recursion
             padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
             // physics: const NeverScrollableScrollPhysics(),
             itemBuilder: (context, index) {
               xPrint("the widget ${index} ", header: "PostsListWidget");

               /// returns future loader if the index is last and fetching new
               if (index == feedProviderListen.posts!.length) {
                 fetchNextPosts(context);
                 return Center();
               } else {
                 return Padding(
                   padding: EdgeInsets.only(bottom: xSize / 2),
                   child: FindingPartnerWidget(postDetails: (feedProvider.posts![index].data() as Map)),
                 );
               }
             },
           ),
         ),
       );
     }
  }

  // fetch posts
  Future<void> fetchPosts() async {
    // feedProvider.updateIsFetching(true);
    final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, feedProvider.posts ?? []);
    // feedProvider.updateIsFetching(false, notify: false); // avoiding multiple notify listeners
    feedProvider.addPosts(newPosts ?? []);
  }

  // refresh posts
  Future<void> refreshPosts() async {
    feedProvider.resetPosts();
    final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, []);
    feedProvider.addPosts(newPosts ?? []);
  }

  // fetchNextPosts
  Future<void> fetchNextPosts(BuildContext context) async {
    try {
      if (!feedProvider.isFetching) {
            xPrint("now we will fetch next posts", header: "fetchNextPosts");
            fetchPosts();
            xSnackbar( context,"Getting more posts...", type: MessageType.info);
          }
    } catch (e) {
      xPrint(e.toString());
    }
  }
}

class PostsListWidget extends StatelessWidget {
  PostsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FeedProvider feedProvider = Provider.of<FeedProvider>(context, listen: false);
    FeedProvider feedProviderListen = Provider.of<FeedProvider>(context, listen: true);
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, _) {
        // fetch posts
        Future<void> fetchPosts() async {
          Provider.of<FeedProvider>(context, listen: false).updateIsFetching(true);
          final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, feedProvider.posts ?? []);
          Provider.of<FeedProvider>(context, listen: false).updateIsFetching(false, notify: false); // avoiding multiple notify listeners
          Provider.of<FeedProvider>(context, listen: false).addPosts(newPosts ?? []);
        }

        // refresh posts
        Future<void> refreshPosts() async {
          feedProvider.resetPosts();
          final newPosts = await FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, []);
          feedProvider.addPosts(newPosts ?? []);
        }

        // fetchNextPosts
        Future<void> fetchNextPosts() async {
          if (!feedProvider.isFetching) {
            xPrint("now we will fetch next posts", header: "fetchNextPosts");
            // xSnackbar(context, "Getting more posts...", type: MessageType.info);
            fetchPosts();
          }
        }

        // fetch if not present
        if (feedProvider.posts == null) {
          fetchPosts();
          return Center(child: dogWaitLoader("Fetching profiles..."));
        } else if (feedProvider.posts!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(xSize / 2),
            child: xInfoText(
              context,
              "Sorry we couldn't find any mating posts. Please try updating your filters.",
            ),
          );
        } else {
          return Expanded(
            child: (feedProvider.isFetching)
                ? Text("isfetching")
                : RefreshIndicator(
                    onRefresh: refreshPosts,
                    child: ListView.builder(
                      itemCount: feedProvider.posts!.length + 1,
                      // one more for recursion
                      padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        xPrint("the widget ${index} ", header: "PostsListWidget");

                        /// returns future loader if the index is last and fetching new
                        if (index == feedProvider.posts!.length) {
                          fetchNextPosts();
                          return Center();
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(bottom: xSize / 2),
                            child: FindingPartnerWidget(postDetails: (feedProvider.posts![index].data() as Map)),
                          );
                        }
                      },
                    ),
                  ),
          );
        }  // todo study refresh indicator kaise kaam karta hai
      }, // $ todo show a loader while next posts are being fetched and stop it from continuosly fetching
    );
    // return FutureBuilder(
    //     future: FirebaseCloudFirestore().getMatingProfiles(xSharedPrefs.matingFilterMap, prePosts),
    //     builder: (context, snap) {
    //       // handle the process
    //       if (snap.connectionState == ConnectionState.waiting) {
    //         return Center(child: dogWaitLoader("Fetching profiles..."));
    //       } else if (snap.hasError) {
    //         return xErrorText(context, "faced some error, please try again later.");
    //       } else {
    //         final newPosts = snap.data ?? [];
    //         // handle no profile found
    //         // if (newPosts.isEmpty) {
    //         //   return Padding(
    //         //     padding: const EdgeInsets.all(xSize / 2),
    //         //     child: xInfoText(
    //         //       context,
    //         //       prePosts.isEmpty ? "Sorry we couldn't find any mating posts. Please try updating your filters." : "No more results for your filters found.",
    //         //     ),
    //         //   );
    //         // }
    //         // return Column(
    //         //   children: [
    //         //     ...List.generate(newPosts.length + 1, (index) {
    //         //
    //         //       /// returns future loader if the index is last and fetching new
    //         //       if (index == newPosts.length) {
    //         //         return PostsListWidget(prePosts: [...prePosts, ...newPosts]);
    //         //       } else {
    //         //
    //         //         xPrint("the widget ${newPosts[index].id}", header: "PostsListWidget");
    //         //         return Padding(
    //         //           padding: EdgeInsets.only(bottom: xSize / 2),
    //         //           child: FindingPartnerWidget(postDetails: (newPosts[index].data() as Map)),
    //         //         );
    //         //       }
    //         //     }),
    //         //     // ...newPosts.map((p) {
    //         //     //   xPrint("the widget ${p.id}", header: "PostsListWidget");
    //         //     //   return Padding(
    //         //     //     padding: EdgeInsets.only(bottom: xSize / 2),
    //         //     //     child: FindingPartnerWidget(postDetails: (p.data() as Map)),
    //         //     //   );
    //         //     // }).toList(),
    //         //     // PostsListWidget(prePosts: [...prePosts, ...newPosts]),
    //         //   ],
    //         // );
    //         //display profiles
    //         return ListView.builder(
    //           itemCount: newPosts.length + 1,
    //           // one more for recursion
    //           padding: const EdgeInsets.all(xSize / 2).copyWith(top: xSize / 4),
    //           // physics: const NeverScrollableScrollPhysics(),
    //           itemBuilder: (context, index) {
    //             xPrint("the widget ${index}", header: "PostsListWidget");
    //
    //             /// returns future loader if the index is last and fetching new
    //             if (index == newPosts.length) {
    //               return Center();
    //               // return PostsListWidget(prePosts: [...prePosts, ...newPosts]);
    //             } else {
    //               return Padding(
    //                 padding: EdgeInsets.only(bottom: xSize / 2),
    //                 child: FindingPartnerWidget(postDetails: (newPosts[index].data() as Map)),
    //               );
    //             }
    //           },
    //         );
    //       }
    //     });
  }
}
