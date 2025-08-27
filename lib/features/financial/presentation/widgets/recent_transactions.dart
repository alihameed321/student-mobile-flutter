import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/financial_summary.dart';
import '../pages/all_transactions_page.dart';

class RecentTransactions extends StatelessWidget {
  final List<RecentTransaction>? transactions;
  
  const RecentTransactions({super.key, this.transactions});

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
                  'المعاملات الحديثة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (transactions != null && transactions!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllTransactionsPage(
                            transactions: transactions!,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
          ),
          if (transactions != null && transactions!.isNotEmpty)
            ...transactions!.take(5).map((transaction) => [
              _buildTransactionItem(
                context,
                title: '${transaction.feeType} Payment',
                subtitle: 'معرف الدفع: ${transaction.paymentId}',
                amount: '-\$${transaction.amount.toStringAsFixed(2)}',
                date: DateFormat('MMM dd, yyyy').format(transaction.paymentDate),
                type: TransactionType.payment,
                status: transaction.status,
                icon: _getIconForFeeType(transaction.feeType),
              ),
              if (transaction != transactions!.take(5).last) _buildDivider(),
            ]).expand((x) => x)
          else
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'لا توجد معاملات حديثة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required TransactionType type,
    required String status,
    required IconData icon,
  }) {
    Color amountColor;
    Color iconBackgroundColor;
    Color statusColor;
    String statusText;
    
    switch (type) {
      case TransactionType.payment:
        amountColor = Colors.red;
        iconBackgroundColor = Colors.red.withOpacity(0.1);
        break;
      case TransactionType.refund:
        amountColor = Colors.green;
        iconBackgroundColor = Colors.green.withOpacity(0.1);
        break;
    }
    
    switch (status.toLowerCase()) {
      case 'verified':
        statusColor = Colors.green;
        statusText = 'تم التحقق';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusText = 'معلق';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'مرفوض';
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        statusText = 'ملغي';
        break;
      default:
        statusColor = Colors.blue;
        statusText = status;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: amountColor,
              size: 20,
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
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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

enum TransactionType { payment, refund }