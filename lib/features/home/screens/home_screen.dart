import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/core/common/assignmnet_card.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/feed/explore_feed_screen.dart';
import 'package:sensei/features/feed/feed_screen.dart';
import 'package:sensei/features/feed/new_content_feed_screen.dart';
import 'package:sensei/features/home/delegates/search_community_delegate.dart';
import 'package:sensei/features/home/drawers/profile_drawer.dart';
import 'package:sensei/features/home/drawers/side_drawer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sensei/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  int _emojiIndex = 0;
  final List<String> _emojis = ["😀", "😂", "😍", "😎", "👋", "🚀", "😴", "🦄"];
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  final List<Widget> _widgetOptions = <Widget>[
    const FeedScreen(),
    const ExploreFeedScreen(),
    const NewContentFeedScreen(),
  ];

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _emojiIndex = (_emojiIndex + 1) % _emojis.length;
      });
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          leadingWidth: 70,
          leading: Builder(builder: (context) {
            return TextButton(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (child, animation) {
                  // return ScaleTransition(
                  //   scale: animation,
                  //   child: child,
                  // );
                  // return FadeTransition(
                  //   opacity: animation,
                  //   child: child,
                  // );
                  return RotationTransition(
                    turns: animation,
                    child: child,
                  );
                  // return SizeTransition(
                  //   sizeFactor: animation,
                  //   child: child,
                  // );
                  // return SlideTransition(
                  //   position: Tween<Offset>(
                  //     begin: const Offset(0, 0),
                  //     end: const Offset(0.5, 0),
                  //   ).animate(animation),
                  //   child: child,
                  // );
                },
                child: Text(
                  _emojis[_emojiIndex],
                  key: ValueKey(_emojis[_emojiIndex]),
                  style: const TextStyle(
                    fontSize: 35,
                    shadows: [
                      Shadow(
                        blurRadius: 40.0,
                        color: Pallete.mintColor,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              onPressed: () => {
                setState(() {
                  _emojiIndex = (_emojiIndex + 1) % _emojis.length;
                }),
                _controller.reset(),
                _controller.forward(),
                displayDrawer(context)
              },
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
                Routemaster.of(context).push('/show-qr');
              },
              icon: Icon(
                Icons.qr_code_rounded,
                color: currentTheme.brightness == Brightness.dark
                    ? Colors.tealAccent
                    : Colors.black87,
              ),
            ),
            IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "Notifications Coming Soon! 😀",
                  toastLength: Toast.values[1],
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Pallete.mintColor,
                  textColor: Colors.black,
                  fontSize: 16.0,
                );
              },
              icon: const Icon(Icons.notifications_active),
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
        endDrawer: const ProfileDrawer(),
        // body: const FeedScreen(),
        body: Column(
          children: [
            Expanded(child: _widgetOptions[_selectedIndex]),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          color: currentTheme.brightness == Brightness.dark
              ? Pallete.mintColor
              : Pallete.mintColor,
          backgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(
              Icons.home,
              color: currentTheme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.black,
              size: _selectedIndex == 0 ? 45 : 30,
            ),
            Icon(
              Icons.explore,
              color: currentTheme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.black,
              size: _selectedIndex == 1 ? 45 : 30,
            ),
            Icon(
              Icons.watch_later,
              color: currentTheme.brightness == Brightness.dark
                  ? Colors.black
                  : Colors.black,
              size: _selectedIndex == 2 ? 45 : 30,
            ),
          ],
          height: 60,
          animationCurve: Curves.ease,
          animationDuration: const Duration(milliseconds: 800),
          onTap: (value) => setState(() {
            _selectedIndex = value;
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: SpeedDial(
            backgroundColor: Pallete.mintColor,
            animatedIcon: AnimatedIcons.menu_close,
            icon: Icons.add,
            tooltip: 'Add Content',
            heroTag: 'speed-dial-hero-tag',
            children: [
              SpeedDialChild(
                backgroundColor: Pallete.drawerColor,
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
          ),
        ));
  }

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type');
  }
}
