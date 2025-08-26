import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/financial_bloc.dart';
import '../../domain/entities/student_fee.dart';
import '../../domain/entities/financial_summary.dart';
import '../../domain/entities/payment.dart';
import 'payment_page.dart';

class AllPaymentRemindersPage extends StatefulWidget {
  final List<StudentFee>? studentFees;
  
  const AllPaymentRemindersPage({super.key, this.studentFees});

  @override
  State<AllPaymentRemindersPage> createState() => _AllPaymentRemindersPageState();
}

class _AllPaymentRemindersPageState extends State<AllPaymentRemindersPage> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    // Only load student fees if not provided as parameter
    if (widget.studentFees == null) {
      // TODO: Get actual student ID from authentication or navigation
      context.read<FinancialBloc>().add(LoadStudentFees(studentId: '1'));
    }
  }

  void _navigateToPaymentPage(BuildContext context, StudentFee fee) async {
    final financialBloc = context.read<FinancialBloc>();
    
    // Load fresh outstanding fees first to get real fee IDs
    financialBloc.add(const LoadOutstandingFees());
    
    // Wait for outstanding fees to load
    await for (final state in financialBloc.stream) {
      if (state is OutstandingFeesLoaded) {
        final outstandingFees = state.fees;
        
        // Find the corresponding real fee by matching fee type and amount
        final realFee = outstandingFees.firstWhere(
          (realFee) => realFee.feeType.name == fee.feeType.name && 
                      realFee.remainingBalance == fee.remainingBalance,
          orElse: () => outstandingFees.isNotEmpty ? outstandingFees.first : fee,
        );
        
        // Load payment providers from API
        financialBloc.add(const LoadPaymentProviders());
        
        // Wait for payment providers to load
        await for (final providerState in financialBloc.stream) {
          if (providerState is PaymentProvidersLoaded) {
            final paymentProviders = providerState.providers;
            await _navigateWithProviders(context, realFee, financialBloc, paymentProviders);
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
    StudentFee fee, 
    FinancialBloc financialBloc, 
    List<PaymentProvider> paymentProviders
  ) async {
    
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: financialBloc,
          child: PaymentPage(
            availableFees: [fee], // Pass the selected fee
            paymentProviders: paymentProviders,
            studentId: '1', // This should come from user session
          ),
        ),
      ),
    );
    
    // Refresh financial data when returning from payment page (regardless of payment outcome)
    if (context.mounted) {
      financialBloc.add(LoadStudentFees(studentId: '1'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Reminders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: BlocBuilder<FinancialBloc, FinancialState>(
        builder: (context, state) {
          print('[AllPaymentRemindersPage] Current state: ${state.runtimeType}');
          
          // Use provided studentFees if available, otherwise rely on BLoC state
          if (widget.studentFees != null) {
            final fees = widget.studentFees!;
            print('[AllPaymentRemindersPage] Using provided studentFees with ${fees.length} fees');
            
            return Column(
              children: [
                // Filter tabs
                _buildFilterTabs(),
                // Fees list
                Expanded(
                   child: fees.isEmpty
                       ? _buildEmptyState()
                       : _buildStudentFeesList(fees),
                 ),
              ],
            );
          }
          
          if (state is FinancialLoading) {
            print('[AllPaymentRemindersPage] Showing loading indicator');
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is FinancialError) {
            print('[AllPaymentRemindersPage] Error state: ${state.message}');
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
                      fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FinancialBloc>().add(LoadStudentFees(studentId: '1'));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is FeesLoaded) {
            final fees = state.fees;
            print('[AllPaymentRemindersPage] FeesLoaded state received with ${fees.length} fees');
            for (int i = 0; i < fees.length; i++) {
              print('[AllPaymentRemindersPage] Fee $i: ${fees[i].feeType.name} - ${fees[i].status} - Amount: ${fees[i].amount}');
            }
            
            return Column(
              children: [
                // Filter tabs
                _buildFilterTabs(),
                // Fees list
                Expanded(
                  child: fees.isEmpty
                      ? _buildEmptyState()
                      : _buildStudentFeesList(fees),
                ),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterTab('all', 'All'),
          const SizedBox(width: 12),
          _buildFilterTab('overdue', 'Overdue'),
          const SizedBox(width: 12),
          _buildFilterTab('pending', 'Pending'),
          const SizedBox(width: 12),
          _buildFilterTab('paid', 'Paid'),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String filter, String label) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    Color color;
    
    switch (_selectedFilter) {
      case 'overdue':
        message = 'No overdue payments';
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'pending':
        message = 'No pending payments';
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      case 'paid':
        message = 'No paid fees to display';
        icon = Icons.receipt_outlined;
        color = Colors.grey;
        break;
      default:
        message = 'No payment reminders';
        icon = Icons.check_circle_outline;
        color = Colors.green;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.brown,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == 'overdue' || _selectedFilter == 'pending'
                ? 'All your payments are up to date!'
                : 'Check back later for updates.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentFeesList(List<StudentFee> fees) {
    final filteredFees = _getFilteredStudentFees(fees);
    print('[AllPaymentRemindersPage] _buildStudentFeesList called with ${fees.length} fees, filtered to ${filteredFees.length} fees for filter: $_selectedFilter');
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredFees.length,
      itemBuilder: (context, index) {
        final fee = filteredFees[index];
        print('[AllPaymentRemindersPage] Building fee item $index: ${fee.feeType.name}');
        return _buildStudentFeeItem(fee);
      },
    );
  }

  Widget _buildStudentFeeItem(StudentFee fee) {
    final isOverdue = _isStudentFeeOverdue(fee);
    final isPending = fee.status.toLowerCase() == 'pending';
    final isPaid = fee.status.toLowerCase() == 'paid';
    
    Color priorityColor;
    Color backgroundColor;
    IconData icon;
    String statusText;
    
    if (isOverdue) {
      priorityColor = Colors.red;
      backgroundColor = Colors.red.withOpacity(0.1);
      icon = Icons.warning;
      statusText = 'Overdue';
    } else if (isPending) {
      priorityColor = Colors.orange;
      backgroundColor = Colors.orange.withOpacity(0.1);
      icon = Icons.pending;
      statusText = 'Pending';
    } else {
      priorityColor = Colors.green;
      backgroundColor = Colors.green.withOpacity(0.1);
      icon = Icons.check_circle;
      statusText = 'Paid';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    fee.feeType.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (fee.feeType.description != null && fee.feeType.description!.isNotEmpty) ...[
                    Text(
                      fee.feeType.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Amount: \$${fee.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (fee.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Due: ${_formatDate(fee.dueDate!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: isOverdue ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isPaid)
              GestureDetector(
                onTap: () => _navigateToPaymentPage(context, fee),
                child: Container(
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
              ),
          ],
        ),
      ),
    );
  }

  List<StudentFee> _getFilteredStudentFees(List<StudentFee> fees) {
    switch (_selectedFilter) {
      case 'overdue':
        return fees.where((fee) => _isStudentFeeOverdue(fee)).toList();
      case 'pending':
        return fees.where((fee) => fee.status.toLowerCase() == 'pending' && !_isStudentFeeOverdue(fee)).toList();
      case 'paid':
        return fees.where((fee) => fee.status.toLowerCase() == 'paid').toList();
      default:
        return fees;
    }
  }

  bool _isStudentFeeOverdue(StudentFee fee) {
    if (fee.dueDate == null || fee.status.toLowerCase() == 'paid') {
      return false;
    }
    return fee.dueDate!.isBefore(DateTime.now()) && fee.status.toLowerCase() != 'paid';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}