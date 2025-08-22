import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

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
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all transactions
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          _buildTransactionItem(
            context,
            title: 'Tuition Payment',
            subtitle: 'Fall 2024 Semester',
            amount: '-\$1,500.00',
            date: 'Jan 15, 2024',
            type: TransactionType.payment,
            icon: Icons.school,
          ),
          _buildDivider(),
          _buildTransactionItem(
            context,
            title: 'Financial Aid Refund',
            subtitle: 'Pell Grant Disbursement',
            amount: '+\$2,000.00',
            date: 'Jan 10, 2024',
            type: TransactionType.refund,
            icon: Icons.account_balance,
          ),
          _buildDivider(),
          _buildTransactionItem(
            context,
            title: 'Parking Fee',
            subtitle: 'Spring Semester Permit',
            amount: '-\$150.00',
            date: 'Jan 8, 2024',
            type: TransactionType.payment,
            icon: Icons.local_parking,
          ),
          _buildDivider(),
          _buildTransactionItem(
            context,
            title: 'Book Store Purchase',
            subtitle: 'Textbooks & Supplies',
            amount: '-\$320.50',
            date: 'Jan 5, 2024',
            type: TransactionType.payment,
            icon: Icons.menu_book,
          ),
          _buildDivider(),
          _buildTransactionItem(
            context,
            title: 'Lab Fee Refund',
            subtitle: 'Chemistry Lab - Cancelled',
            amount: '+\$75.00',
            date: 'Jan 3, 2024',
            type: TransactionType.refund,
            icon: Icons.science,
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
    required IconData icon,
  }) {
    Color amountColor;
    Color iconBackgroundColor;
    
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
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
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
}

enum TransactionType { payment, refund }