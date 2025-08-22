import 'package:flutter/material.dart';

enum NotificationType { academic, financial, event, system, general }
enum NotificationPriority { high, medium, low }

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getNotifications();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(context, notification);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, Map<String, dynamic> notification) {
    final type = notification['type'] as NotificationType;
    final priority = notification['priority'] as NotificationPriority;
    final isRead = notification['isRead'] as bool;
    
    return InkWell(
      onTap: () {
        // Handle notification tap
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(type),
                    color: _getTypeColor(type),
                    size: 24,
                  ),
                ),
                if (priority == NotificationPriority.high)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                            color: isRead ? Colors.black87 : Colors.black,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getTypeColor(type),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTypeColor(type).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTypeLabel(type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getTypeColor(type),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          notification['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getNotifications() {
    return [
      {
        'title': 'Course Registration Deadline',
        'message': 'Don\'t forget to register for Spring 2024 courses. Registration closes in 3 days.',
        'time': '2 hours ago',
        'type': NotificationType.academic,
        'priority': NotificationPriority.high,
        'isRead': false,
      },
      {
        'title': 'Tuition Payment Due',
        'message': 'Your tuition payment of \$2,500 is due on January 15th. Pay now to avoid late fees.',
        'time': '5 hours ago',
        'type': NotificationType.financial,
        'priority': NotificationPriority.high,
        'isRead': false,
      },
      {
        'title': 'New Grade Posted',
        'message': 'Your grade for Computer Science 101 midterm exam has been posted.',
        'time': '1 day ago',
        'type': NotificationType.academic,
        'priority': NotificationPriority.medium,
        'isRead': false,
      },
      {
        'title': 'Career Fair Next Week',
        'message': 'Join us for the Spring Career Fair on January 20th. Over 50 companies will be attending.',
        'time': '2 days ago',
        'type': NotificationType.event,
        'priority': NotificationPriority.medium,
        'isRead': true,
      },
      {
        'title': 'Library Book Due Soon',
        'message': 'Your borrowed book "Advanced Mathematics" is due in 2 days. Renew or return it.',
        'time': '3 days ago',
        'type': NotificationType.general,
        'priority': NotificationPriority.low,
        'isRead': true,
      },
      {
        'title': 'System Maintenance',
        'message': 'The student portal will be under maintenance on January 18th from 2-4 AM.',
        'time': '4 days ago',
        'type': NotificationType.system,
        'priority': NotificationPriority.low,
        'isRead': true,
      },
      {
        'title': 'Scholarship Application Open',
        'message': 'Applications for the Merit Scholarship are now open. Deadline: February 1st.',
        'time': '1 week ago',
        'type': NotificationType.financial,
        'priority': NotificationPriority.medium,
        'isRead': true,
      },
      {
        'title': 'Class Schedule Updated',
        'message': 'Your Physics 201 class has been moved to Room 305. Check your updated schedule.',
        'time': '1 week ago',
        'type': NotificationType.academic,
        'priority': NotificationPriority.medium,
        'isRead': true,
      },
    ];
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.academic:
        return Colors.blue;
      case NotificationType.financial:
        return Colors.green;
      case NotificationType.event:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.general:
        return Colors.orange;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.academic:
        return Icons.school;
      case NotificationType.financial:
        return Icons.account_balance_wallet;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.academic:
        return 'Academic';
      case NotificationType.financial:
        return 'Financial';
      case NotificationType.event:
        return 'Event';
      case NotificationType.system:
        return 'System';
      case NotificationType.general:
        return 'General';
    }
  }
}