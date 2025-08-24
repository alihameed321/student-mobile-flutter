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
    
    // Load outstanding fees first to get real fee IDs
    financialBloc.add(const LoadOutstandingFees());
    
    // Wait for outstanding fees to load
    await for (final state in financialBloc.stream) {
      if (state is OutstandingFeesLoaded) {
        final studentFees = state.fees;
        
        if (studentFees.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No outstanding fees to pay'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          break;
        }
        
        // Load payment providers from API
        financialBloc.add(const LoadPaymentProviders());
        
        // Wait for payment providers to load
        await for (final providerState in financialBloc.stream) {
          if (providerState is PaymentProvidersLoaded) {
            final paymentProviders = providerState.providers;
            await _navigateWithProviders(context, studentFees, financialBloc, paymentProviders);
            break;
          } else if (providerState is FinancialError) {
            // Show error message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to load payment providers: ${providerState.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            break;
          }
        }
        break;
      } else if (state is FinancialError) {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load outstanding fees: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
      }
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
  
  // Removed _convertToStudentFeesForPayment method as we now use real outstanding fees

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