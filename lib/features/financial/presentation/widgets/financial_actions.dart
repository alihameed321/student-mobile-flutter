import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/financial_bloc.dart';
import '../../domain/entities/student_fee.dart';
import '../../domain/entities/payment.dart';
import '../pages/payment_page.dart';

class FinancialActions extends StatelessWidget {
  const FinancialActions({super.key});

  void _navigateToPaymentPage(BuildContext context) async {
    final financialBloc = context.read<FinancialBloc>();
    final currentState = financialBloc.state;
    
    if (currentState is FinancialSummaryLoaded) {
      // Convert fee breakdown to student fees for payment
      final studentFees = _convertToStudentFeesForPayment(currentState.summary);
      
      // Load payment providers from API
      financialBloc.add(const LoadPaymentProviders());
      
      // Wait for payment providers to load
      await for (final state in financialBloc.stream) {
        if (state is PaymentProvidersLoaded) {
          final paymentProviders = state.providers;
          await _navigateWithProviders(context, studentFees, financialBloc, paymentProviders);
          break;
        } else if (state is FinancialError) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load payment providers: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
          break;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for financial data to load'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
  
  Future<void> _navigateWithProviders(
    BuildContext context, 
    List<StudentFee> studentFees, 
    FinancialBloc financialBloc, 
    List<PaymentProvider> paymentProviders
  ) async {
      
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: financialBloc,
            child: PaymentPage(
              availableFees: studentFees,
              paymentProviders: paymentProviders,
              studentId: '1', // This should come from user session
            ),
          ),
        ),
      );
      
      if (result == true) {
        // Refresh financial data after successful payment
        financialBloc.add(const RefreshFinancialData('1'));
      }
  }
  
  List<StudentFee> _convertToStudentFeesForPayment(dynamic summary) {
    // This is a simplified conversion - in real app, you'd have proper types
    final feeBreakdown = summary.feeBreakdown as List;
    return feeBreakdown.map((breakdown) {
      String status;
      if (breakdown.remainingAmount <= 0) {
        status = 'paid';
      } else if (breakdown.paidAmount > 0) {
        status = 'partially_paid';
      } else {
        status = 'pending';
      }
      
      return StudentFee(
        id: breakdown.feeType.hashCode,
        studentName: 'Current Student',
        studentId: '1',
        feeType: FeeType(
          id: breakdown.feeType.hashCode,
          name: breakdown.feeType,
          description: '${breakdown.feeType} fee',
          category: 'Academic',
          isActive: true,
        ),
        amount: breakdown.totalAmount,
        amountPaid: breakdown.paidAmount,
        remainingBalance: breakdown.remainingAmount,
        status: status,
        dueDate: breakdown.remainingAmount > 0 
            ? DateTime.now().add(const Duration(days: 30)) 
            : null,
        semester: 'Current Semester',
        academicYear: DateTime.now().year.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).where((fee) => fee.remainingBalance > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.payment,
                  label: 'Make Payment',
                  color: Colors.green,
                  onTap: () => _navigateToPaymentPage(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.receipt_long,
                  label: 'View Receipts',
                  color: Colors.blue,
                  onTap: () {
                    // Navigate to receipts page
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.account_balance,
                  label: 'Financial Aid',
                  color: Colors.purple,
                  onTap: () {
                    // Navigate to financial aid page
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.schedule,
                  label: 'Payment Plan',
                  color: Colors.orange,
                  onTap: () {
                    // Navigate to payment plan page
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }}