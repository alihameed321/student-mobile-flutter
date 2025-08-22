import 'package:flutter/material.dart';
import '../widgets/financial_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/financial_actions.dart';
import '../widgets/payment_reminders.dart';

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh financial data
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header
                const FinancialHeader(),
                
                const SizedBox(height: 20),
                
                // Balance Card
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: BalanceCard(),
                ),
                
                const SizedBox(height: 20),
                
                // Payment Reminders
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: PaymentReminders(),
                ),
                
                const SizedBox(height: 20),
                
                // Financial Actions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FinancialActions(),
                ),
                
                const SizedBox(height: 20),
                
                // Recent Transactions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RecentTransactions(),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}