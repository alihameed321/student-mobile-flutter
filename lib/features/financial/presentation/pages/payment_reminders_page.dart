import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/financial_bloc.dart';
import '../../domain/entities/financial_summary.dart';

class PaymentRemindersPage extends StatelessWidget {
  const PaymentRemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Payment Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<FinancialBloc, FinancialState>(
        builder: (context, state) {
          if (state is FinancialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is FinancialError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading payment reminders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FinancialBloc>().add(const LoadFinancialSummary('student_id_placeholder'));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is FinancialSummaryLoaded) {
            return _buildPaymentRemindersList(context, state.summary);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPaymentRemindersList(BuildContext context, FinancialSummary summary) {
    final List<PaymentReminderItem> reminders = _generateReminders(summary);
    
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'All payments are up to date!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no pending payment reminders.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        return _buildReminderCard(context, reminder, index == 0);
      },
    );
  }

  List<PaymentReminderItem> _generateReminders(FinancialSummary summary) {
    final List<PaymentReminderItem> reminders = [];
    
    // Add overdue payments reminder
    if (summary.overdueCount > 0) {
      reminders.add(PaymentReminderItem(
        title: 'Overdue Payments',
        subtitle: '${summary.overdueCount} payment${summary.overdueCount > 1 ? 's' : ''} overdue',
        amount: null,
        dueDate: 'Action required immediately',
        priority: ReminderPriority.high,
        icon: Icons.warning,
        description: 'These payments are past their due date and require immediate attention to avoid penalties.',
      ));
    }
    
    // Add pending payments reminder
    if (summary.pendingPayments > 0) {
      reminders.add(PaymentReminderItem(
        title: 'Pending Payments',
        subtitle: 'Outstanding balance',
        amount: summary.pendingPayments,
        dueDate: 'Payment due soon',
        priority: ReminderPriority.medium,
        icon: Icons.pending,
        description: 'These payments are due soon. Pay now to avoid late fees and maintain good standing.',
      ));
    }
    
    // Add fee breakdown reminders
    for (final fee in summary.feeBreakdown) {
      if (fee.remainingAmount > 0) {
        reminders.add(PaymentReminderItem(
          title: fee.feeType,
          subtitle: '${fee.count} item${fee.count > 1 ? 's' : ''} • \$${fee.totalAmount.toStringAsFixed(2)} total',
          amount: fee.remainingAmount,
          dueDate: 'Remaining balance',
          priority: ReminderPriority.low,
          icon: _getIconForFeeType(fee.feeType),
          description: 'Partial payment made. \$${fee.paidAmount.toStringAsFixed(2)} paid of \$${fee.totalAmount.toStringAsFixed(2)} total.',
        ));
      }
    }
    
    return reminders;
  }

  Widget _buildReminderCard(BuildContext context, PaymentReminderItem reminder, bool isFirst) {
    Color priorityColor;
    Color backgroundColor;
    
    switch (reminder.priority) {
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

    return Container(
      margin: EdgeInsets.only(
        bottom: 16,
        top: isFirst ? 8 : 0,
      ),
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
        border: Border.all(
          color: priorityColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reminder.icon,
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
                        reminder.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (reminder.amount != null)
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
                      '\$${reminder.amount!.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        reminder.dueDate,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reminder.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to payment page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment functionality coming soon!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: priorityColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    _showReminderDetails(context, reminder);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: priorityColor,
                    side: BorderSide(color: priorityColor),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReminderDetails(BuildContext context, PaymentReminderItem reminder) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Payment Details',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reminder.subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (reminder.amount != null) ...[
                      _buildDetailRow('Amount Due', '\$${reminder.amount!.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                    ],
                    _buildDetailRow('Status', reminder.dueDate),
                    const SizedBox(height: 12),
                    _buildDetailRow('Priority', _getPriorityText(reminder.priority)),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reminder.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getPriorityText(ReminderPriority priority) {
    switch (priority) {
      case ReminderPriority.high:
        return 'High - Immediate action required';
      case ReminderPriority.medium:
        return 'Medium - Due soon';
      case ReminderPriority.low:
        return 'Low - Partial payment';
    }
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

class PaymentReminderItem {
  final String title;
  final String subtitle;
  final double? amount;
  final String dueDate;
  final ReminderPriority priority;
  final IconData icon;
  final String description;

  PaymentReminderItem({
    required this.title,
    required this.subtitle,
    this.amount,
    required this.dueDate,
    required this.priority,
    required this.icon,
    required this.description,
  });
}

enum ReminderPriority { high, medium, low }