import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/student_fee.dart';
import '../../domain/entities/payment.dart';
import '../bloc/financial_bloc.dart';

class PaymentPage extends StatefulWidget {
  final List<StudentFee> availableFees;
  final List<PaymentProvider> paymentProviders;
  final String studentId;
  final List<StudentFee>? preSelectedFees;

  const PaymentPage({
    super.key,
    required this.availableFees,
    required this.paymentProviders,
    required this.studentId,
    this.preSelectedFees,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionReferenceController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _transferNotesController = TextEditingController();

  List<StudentFee> _selectedFees = [];
  PaymentProvider? _selectedProvider;
  double _totalSelectedAmount = 0.0;
  bool _isProcessing = false;
  late FinancialBloc _financialBloc;

  @override
  void initState() {
    super.initState();
    if (widget.preSelectedFees != null) {
      _selectedFees = List.from(widget.preSelectedFees!);
      _calculateTotalAmount();
    }
    if (widget.paymentProviders.isNotEmpty) {
      _selectedProvider = widget.paymentProviders.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionReferenceController.dispose();
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _transferNotesController.dispose();
    super.dispose();
  }

  void _calculateTotalAmount() {
    _totalSelectedAmount = _selectedFees.fold(
      0.0,
      (sum, fee) => sum + fee.remainingBalance,
    );
    _amountController.text = _totalSelectedAmount.toStringAsFixed(2);
  }

  void _toggleFeeSelection(StudentFee fee) {
    setState(() {
      if (_selectedFees.contains(fee)) {
        _selectedFees.remove(fee);
      } else {
        _selectedFees.add(fee);
      }
      _calculateTotalAmount();
    });
  }

  void _selectAllFees() {
    setState(() {
      if (_selectedFees.length == widget.availableFees.length) {
        _selectedFees.clear();
      } else {
        _selectedFees = List.from(widget.availableFees);
      }
      _calculateTotalAmount();
    });
  }

  void _submitPayment() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار رسم واحد على الأقل للدفع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار مقدم خدمة الدفع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0 || amount > _totalSelectedAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال مبلغ دفع صحيح'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    _financialBloc.add(
      CreatePaymentEvent(
        studentId: widget.studentId,
        feeIds: _selectedFees.map((fee) => fee.id.toString()).toList(),
        paymentProviderId: _selectedProvider!.id.toString(),
        amount: amount,
        transactionReference: _transactionReferenceController.text.trim().isEmpty
            ? null
            : _transactionReferenceController.text.trim(),
        senderName: _senderNameController.text.trim().isEmpty
            ? null
            : _senderNameController.text.trim(),
        senderPhone: _senderPhoneController.text.trim().isEmpty
            ? null
            : _senderPhoneController.text.trim(),
        transferNotes: _transferNotesController.text.trim().isEmpty
            ? null
            : _transferNotesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Capture the FinancialBloc reference to avoid context issues in callbacks
    _financialBloc = context.read<FinancialBloc>();
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'إجراء دفعة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<FinancialBloc, FinancialState>(
        listener: (context, state) {
          if (state is PaymentCreated) {
            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تقديم الدفعة بنجاح! جاري معالجة دفعتك.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is FinancialError) {
            setState(() {
              _isProcessing = false;
            });
            // Don't show any message here - let parent handle error display
            Navigator.of(context).pop(false);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeeSelectionSection(),
                const SizedBox(height: 24),
                _buildPaymentAmountSection(),
                const SizedBox(height: 24),
                _buildPaymentProviderSection(),
                const SizedBox(height: 24),
                _buildPaymentDetailsSection(),
                const SizedBox(height: 24),
                _buildAmountSummarySection(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildFeeSelectionSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اختر الرسوم للدفع',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: _selectAllFees,
                child: Text(
                  _selectedFees.length == widget.availableFees.length
                      ? 'إلغاء تحديد الكل'
                      : 'تحديد الكل',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.availableFees.length,
              itemBuilder: (context, index) {
                final fee = widget.availableFees[index];
                return _buildFeeItem(fee);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem(StudentFee fee) {
    final isSelected = _selectedFees.contains(fee);
    final isOverdue = fee.isOverdue;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Colors.white,
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (value) => _toggleFeeSelection(fee),
        title: Text(
          fee.feeType.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تاريخ الاستحقاق: ${fee.dueDate?.toString().split(' ')[0] ?? 'لا يوجد تاريخ استحقاق'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            if (isOverdue)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'متأخر',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        secondary: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${fee.remainingBalance.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: fee.remainingBalance > 0 ? Colors.red[600] : Colors.green[600],
              ),
            ),
            if (fee.amountPaid > 0)
              Text(
                'مدفوع: \$${fee.amountPaid.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildPaymentAmountSection() {
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
            'مبلغ الدفع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'المبلغ المطلوب دفعه',
              prefixText: '\$',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال مبلغ الدفع';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'يرجى إدخال مبلغ صحيح';
              }
              if (amount > _totalSelectedAmount) {
                return 'لا يمكن أن يتجاوز المبلغ إجمالي الرسوم المحددة';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'يمكنك دفع المبلغ كاملاً أو دفع جزئي',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentProviderSection() {
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
            'اختر مقدم خدمة الدفع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.paymentProviders.map((provider) => _buildProviderItem(provider)),
        ],
      ),
    );
  }

  Widget _buildProviderItem(PaymentProvider provider) {
    final isSelected = _selectedProvider?.id == provider.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.05)
            : Colors.white,
      ),
      child: RadioListTile<PaymentProvider>(
        value: provider,
        groupValue: _selectedProvider,
        onChanged: (value) {
          setState(() {
            _selectedProvider = value;
          });
        },
        title: Row(
          children: [
            if (provider.logo != null)
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    provider.logo!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildProviderIcon(provider.name);
                    },
                  ),
                ),
              )
            else
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(right: 12),
                child: _buildProviderIcon(provider.name),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (provider.universityAccountNumber != null)
                    Text(
                      'الحساب: ${provider.universityAccountNumber}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        subtitle: provider.instructions != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  provider.instructions!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildProviderIcon(String providerName) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;
    
    final name = providerName.toLowerCase();
    if (name.contains('credit') || name.contains('card')) {
      iconData = Icons.credit_card;
      backgroundColor = Colors.blue[100]!;
      iconColor = Colors.blue[600]!;
    } else if (name.contains('bank') || name.contains('transfer')) {
      iconData = Icons.account_balance;
      backgroundColor = Colors.green[100]!;
      iconColor = Colors.green[600]!;
    } else if (name.contains('online')) {
      iconData = Icons.laptop;
      backgroundColor = Colors.purple[100]!;
      iconColor = Colors.purple[600]!;
    } else {
      iconData = Icons.payment;
      backgroundColor = Colors.grey[100]!;
      iconColor = Colors.grey[600]!;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildPaymentDetailsSection() {
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
            'تفاصيل الدفع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _transactionReferenceController,
            decoration: InputDecoration(
              labelText: 'مرجع المعاملة (اختياري)',
              hintText: 'أدخل مرجع معاملتك',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _senderNameController,
            decoration: InputDecoration(
              labelText: 'اسم المرسل (اختياري)',
              hintText: 'اسم الشخص الذي يقوم بالتحويل',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _senderPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'هاتف المرسل (اختياري)',
              hintText: 'رقم هاتف المرسل',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _transferNotesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'ملاحظات التحويل (اختياري)',
              hintText: 'ملاحظات إضافية حول التحويل',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSummarySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص الدفع',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الرسوم المحددة:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${_selectedFees.length} fee(s)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المبلغ الإجمالي:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Text(
                '\$${_totalSelectedAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          if (_selectedProvider != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'طريقة الدفع:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _selectedProvider!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _submitPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'جاري معالجة الدفع...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'ادفع بأمان',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    ); 
  }
}