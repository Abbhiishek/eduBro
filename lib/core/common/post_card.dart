import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/common/user_mod_menu_button.dart';
import 'package:sensei/core/constants/constants.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/community/controller/community_controller.dart';
import 'package:sensei/features/post/controller/post_controller.dart';
import 'package:sensei/models/post_model.dart';
import 'package:sensei/core/common/user_not_mod_menu_button.dart';
import 'package:sensei/responsive/responsive.dart';
import 'package:sensei/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    super.key,
    required this.post,
  });

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifierProvider);
    return Responsive(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
              borderRadius: BorderRadiusGeometry.lerp(
                BorderRadius.circular(40),
                BorderRadius.circular(40),
                1,
              ),
              boxShadow: kIsWeb
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black45.withOpacity(0.7),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      IconButton(
                        onPressed: isGuest ? () {} : () => upvotePost(ref),
                        icon: Icon(
                          Icons.arrow_upward,
                          size: 30,
                          color: post.upvotes.contains(user.uid)
                              ? Pallete.redColor
                              : null,
                        ),
                      ),
                      Text(
                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        onPressed: isGuest ? () {} : () => downvotePost(ref),
                        icon: Icon(
                          Icons.arrow_downward_outlined,
                          size: 30,
                          color: post.downvotes.contains(user.uid)
                              ? Pallete.blueColor
                              : null,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.communityProfilePic,
                                        ),
                                        radius: 26,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'c/${post.communityName.toLowerCase()}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          GestureDetector(
                                            onTap: () =>
                                                navigateToUser(context),
                                            child: Text(
                                              'u/${post.username}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //* Menu Button for More Options for normal user and mods of the community
                                ref
                                    .watch(getCommunityByNameProvider(
                                        post.communityName))
                                    .when(
                                      data: (data) {
                                        // if the user is not a mod, return an empty sized box
                                        if (!data.mods.contains(user.uid)) {
                                          return UserNotModMenu(
                                              post: post, user: user);
                                        }
                                        if (data.mods.contains(user.uid)) {
                                          return UserModMenu(
                                              post: post, user: user);
                                        }
                                        return const SizedBox();
                                      },
                                      error: (error, stackTrace) => ErrorText(
                                        error: error.toString(),
                                      ),
                                      loading: () => const Loader(),
                                    ),
                              ],
                            ),

                            // * Awards for the post
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 13,
                                    );
                                  },
                                ),
                              ),
                            ],
                            // * Post Title
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // * Post Image
                            if (isTypeImage)
                              SizedBox(
                                width: double.infinity,
                                child: post.link != null
                                    ? InstaImageViewer(
                                        disableSwipeToDismiss: false,
                                        disposeLevel: DisposeLevel.high,
                                        child: CachedNetworkImage(
                                          imageUrl: post.link!,
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.topLeft,
                                          filterQuality: FilterQuality.high,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          cacheManager: CacheManager(
                                            Config('customCacheKey',
                                                stalePeriod:
                                                    const Duration(days: 30),
                                                maxNrOfCacheObjects: 1000,
                                                repo: JsonCacheInfoRepository(
                                                    databaseName:
                                                        'mypostscache')),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            if (isTypeLink)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: AnyLinkPreview(
                                    showMultimedia: true,
                                    // urlLaunchMode:
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade800
                                            .withOpacity(0.7),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    cache: const Duration(days: 7),
                                    bodyTextOverflow: TextOverflow.ellipsis,
                                    backgroundColor: currentTheme.brightness ==
                                            Brightness.dark
                                        ? Colors.grey[900]
                                        : Colors.grey[100],

                                    titleStyle: TextStyle(
                                      color: currentTheme.brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    bodyStyle: TextStyle(
                                      color: currentTheme.brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                    ),
                                    removeElevation: false,
                                    bodyMaxLines: 30,
                                    displayDirection:
                                        UIDirection.uiDirectionHorizontal,
                                    link: post.link!,
                                  ),
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      Text(
                                        '${post.upvotes.length - post.downvotes.length == 0 ? '' : post.upvotes.length - post.downvotes.length}',
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      IconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => upvotePost(ref),
                                        icon: Icon(
                                          Icons.thumb_up,
                                          size: 25,
                                          color: post.upvotes.contains(user.uid)
                                              ? Colors.blue
                                              : null,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: isGuest
                                            ? () {}
                                            : () => downvotePost(ref),
                                        icon: Icon(
                                          Icons.thumb_down,
                                          size: 25,
                                          color:
                                              post.downvotes.contains(user.uid)
                                                  ? Colors.red
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          navigateToComments(context),
                                      icon: const Icon(
                                        Icons.comment,
                                        size: 25,
                                      ),
                                    ),
                                    Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                //
                                IconButton(
                                  onPressed: isGuest
                                      ? () {}
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                  ),
                                                  itemCount: user.awards.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final award =
                                                        user.awards[index];
                                                    return GestureDetector(
                                                      onTap: () => awardPost(
                                                          ref, award, context),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            Constants.awards[
                                                                award]!),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  icon:
                                      const Icon(Icons.card_giftcard_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
