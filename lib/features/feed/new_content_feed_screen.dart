import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/core/constants/constants.dart';

class NewContentFeedScreen extends ConsumerWidget {
  const NewContentFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ** future work **

    // return ref.watch(newContentPostsProvider).when(
    //       data: (data) {
    //         return ListView.builder(
    //           itemCount: data.length,
    //           itemBuilder: (BuildContext context, int index) {
    //             final post = data[index];
    //             return PostCard(post: post);
    //           },
    //         );
    //       },
    //       error: (error, stackTrace) {
    //         return ErrorText(
    //           error: error.toString(),
    //         );
    //       },
    //       loading: () => const Loader(),
    //     );

    // simple centere text for now

    return Center(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(image: AssetImage(Constants.loginScreenImage)),
          SizedBox(height: 120),
          Text('New Content Feed Screen'),
          Text('Coming Soon', strutStyle: StrutStyle(height: 2.0)),
        ],
      ),
    ));
  }
}
