import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/notifications_header.dart';
import '../widgets/notification_filters.dart';
import '../widgets/notifications_list.dart';
import '../providers/notification_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NotificationProvider>();
      provider.loadStats();
      provider.loadNotifications(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: () => provider.refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NotificationsHeader(),
                      const SizedBox(height: 16),
                      const NotificationFilters(),
                      const SizedBox(height: 16),
                      const NotificationsList(showAll: true),
                      if (provider.error != null)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'خطأ في تحميل الإشعارات',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red[800],
                                      ),
                                    ),
                                    Text(
                                      provider.error!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => provider.clearError(),
                                child: const Text('إغلاق'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      ),
    );
  }
}