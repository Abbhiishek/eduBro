import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/core/common/sign_in_button.dart';
import 'package:sensei/features/auth/controller/auth_controller.dart';
import 'package:sensei/features/community/controller/community_controller.dart';
import 'package:sensei/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Communities 🦄'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              isGuest
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SignInButton(),
                    )
                  : const ListTile(
                      title: Text('Communities you are a part of'),
                      leading: Icon(Icons.celebration),
                    ),
              if (!isGuest)
                ref.watch(userCommunitiesProvider).when(
                      data: (communities) => Expanded(
                        child: ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (BuildContext context, int index) {
                            final community = communities[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                              title: Text('r/${community.name}'),
                              onTap: () {
                                navigateToCommunity(context, community);
                              },
                            );
                          },
                        ),
                      ),
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => navigateToCreateCommunity(context),
          child: const Icon(Icons.add),
        ));
  }
}
