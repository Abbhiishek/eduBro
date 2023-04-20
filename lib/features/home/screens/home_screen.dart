import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/core/common/assignmnet_card.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/feed/feed_screen.dart';
import 'package:sensei/features/home/delegates/search_community_delegate.dart';
import 'package:sensei/features/home/drawers/profile_drawer.dart';
import 'package:sensei/features/home/drawers/side_drawer.dart';
import 'package:sensei/theme/pallete.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider.notifier);
    final isGuest = !user.isAuthenticated;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: false,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }),
          actions: [
            IconButton(
              onPressed: () async {
                // search bar ;
                showSearch(
                    context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Routemaster.of(context).push('/add-post');
              },
              icon: const Icon(Icons.add),
            ),
            Builder(builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context),
              );
            }),
          ],
        ),
        drawer: const SideDrawer(),
        endDrawer: isGuest ? null : const ProfileDrawer(),
        body: const FeedScreen(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => navigateToAddPost(context),
        //   child: const Icon(Icons.add),
        // ),

        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          icon: Icons.add,
          tooltip: 'Add Content',
          heroTag: 'speed-dial-hero-tag',
          children: [
            SpeedDialChild(
              child: const Icon(Icons.image),
              label: 'Post an Image',
              onTap: () => navigateToType(context, 'image'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.post_add_rounded),
              label: 'Post an Article',
              onTap: () => navigateToType(context, 'text'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.link_sharp),
              label: 'Post a Link',
              onTap: () => navigateToType(context, 'link'),
            ),
          ],
        ));
  }

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }
}
