import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/financial_bloc.dart';
import '../widgets/financial_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/payment_reminders.dart';

class FinancialPage extends StatefulWidget {
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  @override
  void initState() {
    super.initState();
    // Load financial data when page initializes
    // TODO: Get actual student ID from authentication/user context
    context.read<FinancialBloc>().add(LoadFinancialSummary('student_id_placeholder'));
  }

  @override
  Widget build(BuildContext context) {
    final financialBloc = context.read<FinancialBloc>();
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
        child: BlocConsumer<FinancialBloc, FinancialState>(
          listener: (context, state) {
            if (state is FinancialError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                // TODO: Get actual student ID from authentication/user context
                financialBloc.add(RefreshFinancialData('student_id_placeholder'));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header
                    const FinancialHeader(),
                    
                    const SizedBox(height: 20),
                    
                    if (state is FinancialLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state is FinancialError)
                      Center(
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
                              'خطأ في تحميل البيانات المالية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<FinancialBloc>().add(
                                  LoadFinancialSummary('student_id_placeholder'),
                                );
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    else if (state is FinancialInitial)
                      const Center(
                        child: Text(
                          'جاري تحميل البيانات المالية...',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    else if (state is FinancialSummaryLoaded) ...[
                      // Balance Card with real data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: BalanceCard(summary: state.summary),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Payment Reminders with real data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PaymentReminders(summary: state.summary),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Recent Transactions with real data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RecentTransactions(transactions: state.summary.recentTransactions),
                      ),
                    ] else ...[
                      // Default widgets when no data is loaded
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: BalanceCard(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: PaymentReminders(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: RecentTransactions(),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                  ],
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