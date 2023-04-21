import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/post/controller/post_controller.dart';
import 'package:sensei/models/comment_model.dart';
// import 'package:sensei/responsive/responsive.dart';
import 'package:sensei/theme/pallete.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  void deleteComment(WidgetRef ref, BuildContext context) async {
    // show a dialog to confirm the deletion
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment? \n'
            'This action cannot be undone'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => {
              ref
                  .read(postControllerProvider.notifier)
                  .deleteComment(comment, context),
              Navigator.pop(context, true),
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void upvoteComment(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).upvoteComment(comment);
  }

  void downvoteComment(WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).downvoteComment(comment);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  comment.profilePic,
                ),
                radius: 20,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'u/${comment.username}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            comment.createdAt.isUtc
                                ? comment.createdAt
                                    .toLocal()
                                    .toString()
                                    .substring(0, 10)
                                : comment.createdAt.toString().substring(0, 10),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.text),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => upvoteComment(ref),
                                    icon: Icon(
                                      Icons.thumb_up_alt_outlined,
                                      size: 18,
                                      color: !comment.upVotes.contains(user.uid)
                                          ? Colors.grey
                                          : Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    comment.upVotes.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => downvoteComment(ref),
                                    icon: Icon(
                                      Icons.thumb_down_alt_outlined,
                                      size: 20,
                                      color:
                                          comment.downVotes.contains(user.uid)
                                              ? Pallete.redColor
                                              : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    comment.downVotes.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              if (comment.username == user.name)
                                IconButton(
                                  onPressed: () => deleteComment(ref, context),
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
