import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationsList extends StatefulWidget {
  final bool showAll;
  final VoidCallback? onNotificationTap;
  
  const NotificationsList({
    super.key,
    this.showAll = false,
    this.onNotificationTap,
  });

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.notifications.isEmpty) {
          return _buildLoadingState();
        }

        if (provider.error != null && provider.notifications.isEmpty) {
          return _buildErrorState(provider.error!, provider);
        }

        final notifications = widget.showAll 
            ? provider.notifications 
            : provider.notifications.take(5).toList();

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
              _buildHeader(provider),
              if (notifications.isEmpty)
                _buildEmptyState()
              else
                _buildNotificationsList(notifications, provider),
              if (widget.showAll && provider.hasMore)
                _buildLoadMoreButton(provider),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(NotificationProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.showAll ? 'جميع الإشعارات' : 'الإشعارات الحديثة',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (provider.unreadCount > 0)
                Text(
                  '${provider.unreadCount} غير مقروء',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          if (widget.showAll && provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: const Text('تحديد الكل كمقروء'),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
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
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(String error, NotificationProvider provider) {
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'فشل في تحميل الإشعارات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.loadNotifications(refresh: true),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات بعد',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر إشعاراتك هنا عند استلامها.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications, NotificationProvider provider) {
    return ListView.separated(
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
        return _buildNotificationItem(context, notification, provider);
      },
    );
  }

  Widget _buildLoadMoreButton(NotificationProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: provider.isLoadingMore
            ? const CircularProgressIndicator()
            : TextButton(
                onPressed: () => provider.loadMoreNotifications(),
                child: const Text('تحميل المزيد'),
              ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    return InkWell(
      onTap: () async {
        // Mark as read if not already read
        if (!notification.isRead) {
          await provider.markAsRead(notification.id);
        }
        
        // Handle notification tap
        if (widget.onNotificationTap != null) {
          widget.onNotificationTap!();
        }
      },
      onLongPress: () {
        _showNotificationOptions(context, notification, provider);
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
                    color: _getTypeColor(notification.notificationType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.notificationType),
                    color: _getTypeColor(notification.notificationType),
                    size: 24,
                  ),
                ),
                if (notification.priority == 'high' || notification.priority == 'urgent')
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
                          notification.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                            color: notification.isRead ? Colors.black87 : Colors.black,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getTypeColor(notification.notificationType),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
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
                          color: _getTypeColor(notification.notificationType).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTypeLabel(notification.notificationType),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getTypeColor(notification.notificationType),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (notification.priority != 'low')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(notification.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            notification.priority.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getPriorityColor(notification.priority),
                            ),
                          ),
                        ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          notification.timeSinceCreated,
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

  void _showNotificationOptions(BuildContext context, NotificationModel notification, NotificationProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
              ),
              title: Text(
                notification.isRead ? 'تحديد كغير مقروء' : 'تحديد كمقروء',
              ),
              onTap: () {
                Navigator.pop(context);
                if (notification.isRead) {
                  provider.markAsUnread(notification.id);
                } else {
                  provider.markAsRead(notification.id);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                provider.deleteNotification(notification.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'announcement':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'announcement':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return 'معلومات';
      case 'warning':
        return 'تحذير';
      case 'success':
        return 'نجاح';
      case 'error':
        return 'خطأ';
      case 'announcement':
        return 'إعلان';
      default:
        return type.substring(0, 1).toUpperCase() + type.substring(1);
    }
  }
}