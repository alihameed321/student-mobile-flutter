import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإشعارات',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ابق على اطلاع بالمعلومات المهمة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<NotificationProvider>(
                    builder: (context, provider, child) {
                      return IconButton(
                        onPressed: provider.isLoading ? null : () async {
                          await provider.markAllAsRead();
                        },
                        icon: const Icon(
                          Icons.done_all,
                          color: Colors.white,
                        ),
                        tooltip: 'تحديد الكل كمقروء',
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      // Notification settings
                    },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    tooltip: 'الإعدادات',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              final stats = provider.stats;
              final isLoading = provider.isLoading;
              
              return Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.notifications,
                      label: 'الإجمالي',
                      value: isLoading ? '...' : (stats?.totalNotifications.toString() ?? '0'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.circle,
                      label: 'غير مقروء',
                      value: isLoading ? '...' : (stats?.unreadNotifications.toString() ?? provider.unreadCount.toString()),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.priority_high,
                      label: 'مهم',
                      value: isLoading ? '...' : ((stats?.highPriorityUnread ?? 0) + (stats?.urgentPriorityUnread ?? 0)).toString(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}