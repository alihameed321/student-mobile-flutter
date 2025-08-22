import 'package:flutter/material.dart';

class PaymentReminders extends StatelessWidget {
  const PaymentReminders({super.key});

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Reminders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all reminders
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          _buildReminderItem(
            context,
            title: 'Tuition Fee - Spring 2024',
            amount: '\$1,200.00',
            dueDate: 'Due in 5 days',
            priority: ReminderPriority.high,
            icon: Icons.school,
          ),
          _buildDivider(),
          _buildReminderItem(
            context,
            title: 'Library Fine',
            amount: '\$25.00',
            dueDate: 'Due in 2 days',
            priority: ReminderPriority.medium,
            icon: Icons.local_library,
          ),
          _buildDivider(),
          _buildReminderItem(
            context,
            title: 'Parking Permit Renewal',
            amount: '\$150.00',
            dueDate: 'Due in 12 days',
            priority: ReminderPriority.low,
            icon: Icons.local_parking,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildReminderItem(
    BuildContext context, {
    required String title,
    required String amount,
    required String dueDate,
    required ReminderPriority priority,
    required IconData icon,
  }) {
    Color priorityColor;
    Color backgroundColor;
    
    switch (priority) {
      case ReminderPriority.high:
        priorityColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      case ReminderPriority.medium:
        priorityColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case ReminderPriority.low:
        priorityColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: priorityColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        dueDate,
                        style: TextStyle(
                          fontSize: 14,
                          color: priorityColor,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        amount,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: priorityColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Pay Now',
              style: TextStyle(
                color: priorityColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 68,
      endIndent: 20,
    );
  }
}

enum ReminderPriority { high, medium, low }