import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../domain/entities/financial_summary.dart';

class AllTransactionsPage extends StatefulWidget {
  final List<RecentTransaction> transactions;

  const AllTransactionsPage({super.key, required this.transactions});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'الكل';
  String _selectedFeeType = 'الكل';
  List<RecentTransaction> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = widget.transactions;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    setState(() {
      _filteredTransactions = widget.transactions.where((transaction) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            transaction.feeType.toLowerCase().contains(searchQuery) ||
            transaction.paymentId.toString().contains(searchQuery) ||
            transaction.paymentProvider.toLowerCase().contains(searchQuery);

        // Status filter
        final matchesStatus = _selectedStatus == 'الكل' ||
            _translateStatus(transaction.status) == _selectedStatus;

        // Fee type filter
        final matchesFeeType = _selectedFeeType == 'الكل' ||
            transaction.feeType
                .toLowerCase()
                .contains(_selectedFeeType.toLowerCase());

        return matchesSearch && matchesStatus && matchesFeeType;
      }).toList();
    });
  }

  List<String> _getUniqueStatuses() {
    final statuses = widget.transactions.map((t) => _translateStatus(t.status)).toSet().toList();
    statuses.insert(0, 'الكل');
    return statuses;
  }

  List<String> _getUniqueFeeTypes() {
    final feeTypes = widget.transactions.map((t) => t.feeType).toSet().toList();
    feeTypes.insert(0, 'الكل');
    return feeTypes;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'completed':
      case 'موثق':
      case 'مكتمل':
        return Colors.green;
      case 'pending':
      case 'معلق':
        return Colors.orange;
      case 'failed':
      case 'rejected':
      case 'فاشل':
      case 'مرفوض':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForFeeType(String feeType) {
    switch (feeType.toLowerCase()) {
      case 'tuition':
      case 'tuition fee':
        return Icons.school;
      case 'library':
      case 'library fee':
        return Icons.library_books;
      case 'lab':
      case 'lab fee':
        return Icons.science;
      case 'registration':
      case 'registration fee':
        return Icons.app_registration;
      case 'hostel':
      case 'accommodation':
        return Icons.home;
      case 'transport':
      case 'transportation':
        return Icons.directions_bus;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              // Custom Header similar to other pages
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'جميع المعاملات',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Filter options
                            },
                            icon: const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'إدارة وتتبع جميع معاملاتك المالية',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
               // Search and Filter Section
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: 20),
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.08),
                       blurRadius: 20,
                       offset: const Offset(0, 8),
                     ),
                   ],
                 ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => _filterTransactions(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'البحث في المعاملات بالرقم أو النوع أو المزود...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.grey[400],
                            size: 22,
                          ),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _filteredTransactions = widget.transactions;
                                  });
                                },
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.grey[500],
                                  size: 20,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'حالة المعاملة',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 16,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[600],
                            ),
                            items: _getUniqueStatuses().map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                              _filterTransactions();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedFeeType,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: 'نوع الرسوم',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 16,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey[600],
                            ),
                            items: _getUniqueFeeTypes().map((feeType) {
                              return DropdownMenuItem(
                                value: feeType,
                                child: Text(feeType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFeeType = value!;
                              });
                              _filterTransactions();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Results Summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2E7D32).withOpacity(0.05),
                    const Color(0xFF4CAF50).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'عدد المعاملات',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_filteredTransactions.length}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                      if (_filteredTransactions.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'إجمالي المبلغ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${_filteredTransactions.fold(0.0, (sum, transaction) => sum + transaction.amount).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (_searchController.text.isNotEmpty ||
                      _selectedStatus != 'الكل' ||
                      _selectedFeeType != 'الكل')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _selectedStatus = 'الكل';
                                _selectedFeeType = 'الكل';
                                _filteredTransactions = widget.transactions;
                              });
                            },
                            icon: const Icon(
                              Icons.clear_all,
                              size: 18,
                              color: Color(0xFF2E7D32),
                            ),
                            label: const Text(
                              'مسح جميع المرشحات',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Transactions List
            Expanded(
              child: _filteredTransactions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _filteredTransactions[index];
                        return _buildTransactionCard(transaction);
                      },
                    ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد معاملات',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'لم يتم العثور على أي معاملات مالية\nتطابق معايير البحث المحددة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 18,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'جرب تعديل معايير البحث أو المرشحات',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(RecentTransaction transaction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _translateFeeType(transaction.feeType),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'رقم الدفع: ${transaction.paymentId}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(transaction.status).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _translateStatus(transaction.status),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(transaction.status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Details Row
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'المبلغ',
                    '${transaction.amount.toStringAsFixed(2)} ر.س',
                    Icons.payments_outlined,
                    const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailItem(
                    'مزود الدفع',
                    transaction.paymentProvider,
                    Icons.account_balance_wallet_outlined,
                    Colors.blue[600]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Date and Actions Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd/MM/yyyy - HH:mm').format(transaction.paymentDate),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (transaction.status.toLowerCase() == 'verified' ||
                    transaction.status.toLowerCase() == 'completed')
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        // TODO: Implement view receipt functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم تنفيذ عرض الإيصال'),
                            backgroundColor: Color(0xFF2E7D32),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        Icons.receipt_long_outlined,
                        size: 16,
                        color: Color(0xFF2E7D32),
                      ),
                      label: const Text(
                        'عرض الإيصال',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _translateFeeType(String feeType) {
    switch (feeType.toLowerCase()) {
      case 'tuition':
        return 'رسوم دراسية';
      case 'registration':
        return 'رسوم تسجيل';
      case 'library':
        return 'رسوم مكتبة';
      case 'lab':
        return 'رسوم مختبر';
      case 'exam':
        return 'رسوم امتحان';
      case 'graduation':
        return 'رسوم تخرج';
      default:
        return feeType;
    }
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'completed':
        return 'مكتمل';
      case 'pending':
        return 'معلق';
      case 'failed':
        return 'فاشل';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
