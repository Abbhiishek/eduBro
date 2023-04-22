import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/features/post/controller/post_controller.dart';
import 'package:sensei/models/post_model.dart';
import 'package:sensei/models/user_model.dart';

class UserModMenu extends ConsumerWidget {
  const UserModMenu({
    super.key,
    required this.post,
    required this.user,
  });
  final Post post;
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void navigateToUser(BuildContext context) {
      Routemaster.of(context).push('/u/${post.uid}');
    }

    void navigateToCommunity(BuildContext context) {
      Routemaster.of(context).push('/r/${post.communityName}');
    }

    void deletePost(WidgetRef ref, BuildContext context) async {
      ref.read(postControllerProvider.notifier).deletePost(post, context);
    }

    return PopupMenuButton(
      tooltip: "More options",
      position: PopupMenuPosition.under,
      shadowColor: Colors.black,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        // Handle menu option selection
        if (value == "delete_post") {
          // Code to delete the postcard
          deletePost(ref, context);
        }
        if (value == "view_author_profile") {
          // Code to delete the postcard
          navigateToUser(context);
        }
        if (value == "view_community") {
          navigateToCommunity(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "delete_post",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              Text(
                "Delete Post",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "view_author_profile",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              Text(
                "Author Profile",
                style: TextStyle(
                    // color: Colors.red,
                    ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "view_community",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(
                Icons.group,
                color: Colors.blue,
              ),
              Text("Community Page"),
            ],
          ),
        ),
      ],
    );
  }
}
