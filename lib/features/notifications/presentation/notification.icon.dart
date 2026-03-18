import 'package:flutter/material.dart';
import 'package:myapp/features/notifications/data/data_source/notification.data.service.dart';
import '../data/models/app.notification.dart';
import 'notification.listenner.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationDataService notificationService;

  const NotificationIcon({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppNotification>>(
      stream: notificationService.getNotifications(),
      builder: (context, snapshot) {
        bool hasUnread = false;

        if (snapshot.hasData) {
          hasUnread = snapshot.data!.any((n) => !n.read);
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(NotificationsScreen.routeName);
              },
            ),
            if (hasUnread)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
