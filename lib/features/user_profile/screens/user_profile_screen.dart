import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/common/post_card.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/user_profile/controller/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/theme/pallete.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  void followUserWithId(WidgetRef ref) {
    final signedUser = ref.watch(userProvider)!;
    if (signedUser.uid == uid) {
      return; // don't follow yourself
    }

    ref.read(userProfileControllerProvider.notifier).followUser(uid);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signedUser = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) => NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                              child: CachedNetworkImage(
                            imageUrl: user.banner,
                            fit: BoxFit.cover,
                            // height: 100,
                            // placeholder: (context, url) => const Center(
                            //   child: CircularProgressIndicator(),
                            // ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            cacheManager: CacheManager(
                              Config('customCacheKey',
                                  stalePeriod: const Duration(days: 30),
                                  maxNrOfCacheObjects: 1000,
                                  repo: JsonCacheInfoRepository(
                                      databaseName: 'profilebanner')),
                            ),
                          )),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.all(20),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePic),
                              radius: 70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(
                          top: 18, bottom: 0, left: 18, right: 18),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        if (user.isAuthenticated)
                                          Icon(
                                            Icons.verified_user,
                                            color: currentTheme.accentColor,
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        '${user.karma} karma',
                                      ),
                                    ),
                                  ],
                                ),
                                if (signedUser.uid != uid)
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding:
                                        const EdgeInsets.only(left: 0, top: 20),
                                    child: OutlinedButton(
                                      onPressed: () => {
                                        followUserWithId(ref),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(user.followers
                                              .contains(signedUser.uid)
                                          ? 'Following'
                                          : 'Follow'),
                                    ),
                                  ),
                                if (signedUser.uid == uid)
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding:
                                        const EdgeInsets.only(left: 0, top: 20),
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          navigateToEditUser(context),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text('Edit Profile'),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                user.bio,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  '${user.followers.length} followers',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${user.following.length} following',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '${user.posts.length} posts',
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                body: ref.watch(getUserPostsProvider(uid)).when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
                      },
                      loading: () => const Loader(),
                    ),
              ),
              error: (error, stackTrace) =>
                  const ErrorText(error: "No user Found 🥲"),
              loading: () => const Loader(),
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Routemaster.of(context).push('/add-post'),
          child: const Icon(Icons.post_add),
        ));
  }
}
