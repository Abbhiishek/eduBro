import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:sensei/core/common/error_text.dart';
import 'package:sensei/core/common/loader.dart';
import 'package:sensei/features/notification/controller/notification_controller.dart';

class NotificationFeedScreen extends ConsumerWidget {
  const NotificationFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userNotificationsProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    // get the notification to mark it as read
                    ref
                        .watch(getnotificationControllerProvider.notifier)
                        .setNotificationToRead(data[index].title);
                    // navigate to the the payload screen
                    final payload = data[index].payload.value;
                    Routemaster.of(context).push(payload);
                  },
                  title: Text(
                    data[index].title,
                    style: TextStyle(
                      fontWeight: data[index].isRead
                          ? FontWeight.w100
                          : FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    data[index].body,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  // horizontalTitleGap: 10,
                  minVerticalPadding: 12,
                  leading: Image.network(
                    data[index].image,
                    cacheHeight: 50,
                    cacheWidth: 50,
                  ),
                );
              },
            );
          },
          loading: () => const Loader(),
          error: (error, stack) => ErrorText(error: error.toString()),
        );
  }
}
