import 'package:flutter/material.dart';
import '../widgets/notifications_header.dart';
import '../widgets/notification_filters.dart';
import '../widgets/notifications_list.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh notifications
            await Future.delayed(const Duration(seconds: 1));
          },
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationsHeader(),
                  SizedBox(height: 16),
                  NotificationFilters(),
                  SizedBox(height: 16),
                  NotificationsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}