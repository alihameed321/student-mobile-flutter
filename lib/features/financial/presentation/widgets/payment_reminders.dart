import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/financial_summary.dart';
import '../pages/all_payment_reminders_page.dart';
import '../bloc/financial_bloc.dart';

class PaymentReminders extends StatelessWidget {
  final FinancialSummary? summary;
  
  const PaymentReminders({super.key, this.summary});

  @override
  Widget build(BuildContext context) {
    final financialBloc = context.read<FinancialBloc>();
    
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: financialBloc,
                          child: const AllPaymentRemindersPage(),
                        ),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          if (summary != null && summary!.overdueCount > 0)
            _buildReminderItem(
              context,
              title: 'Overdue Payments',
              amount: '${summary!.overdueCount} items',
              dueDate: 'Action required',
              priority: ReminderPriority.high,
              icon: Icons.warning,
            )
          else if (summary != null && summary!.pendingPayments > 0)
            _buildReminderItem(
              context,
              title: 'Pending Payments',
              amount: '\$${summary!.pendingPayments.toStringAsFixed(2)}',
              dueDate: 'Payment due soon',
              priority: ReminderPriority.medium,
              icon: Icons.pending,
            )
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All payments are up to date!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (summary != null && summary!.feeBreakdown.isNotEmpty) ...[
            if (summary!.overdueCount > 0 || summary!.pendingPayments > 0)
              _buildDivider(),
            ...summary!.feeBreakdown.take(2).map((fee) => [
              _buildReminderItem(
                context,
                title: '${fee.feeType} (${fee.count} items)',
                amount: '\$${fee.remainingAmount.toStringAsFixed(2)} remaining',
                dueDate: 'Total: \$${fee.totalAmount.toStringAsFixed(2)}',
                priority: fee.remainingAmount > 0 ? ReminderPriority.low : ReminderPriority.low,
                icon: _getIconForFeeType(fee.feeType),
              ),
              if (fee != summary!.feeBreakdown.take(2).last) _buildDivider(),
            ]).expand((x) => x),
          ],
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

  IconData _getIconForFeeType(String feeType) {
    final lowerFeeType = feeType.toLowerCase();
    if (lowerFeeType.contains('tuition')) {
      return Icons.school;
    } else if (lowerFeeType.contains('library')) {
      return Icons.local_library;
    } else if (lowerFeeType.contains('parking')) {
      return Icons.local_parking;
    } else if (lowerFeeType.contains('lab')) {
      return Icons.science;
    } else if (lowerFeeType.contains('registration')) {
      return Icons.app_registration;
    } else if (lowerFeeType.contains('activity') || lowerFeeType.contains('student')) {
      return Icons.groups;
    } else {
      return Icons.receipt;
    }
  }
}

enum ReminderPriority { high, medium, low }