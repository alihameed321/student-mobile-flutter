import '../../domain/entities/financial_summary.dart';

class FinancialSummaryModel extends FinancialSummary {
  const FinancialSummaryModel({
    required super.totalFees,
    required super.pendingPayments,
    required super.paidThisSemester,
    required super.overdueCount,
    required super.recentTransactions,
    required super.feeBreakdown,
  });

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    try {
      print('FinancialSummaryModel: Starting to parse JSON');
      
      // Parse recent transactions
      List<RecentTransactionModel> recentTransactions = [];
      try {
        print('FinancialSummaryModel: Parsing recent_transactions');
        recentTransactions = (json['recent_transactions'] as List<dynamic>?)
            ?.map((e) {
              try {
                return RecentTransactionModel.fromJson(e as Map<String, dynamic>);
              } catch (error) {
                print('Error parsing individual transaction: $error');
                return null;
              }
            })
            .where((transaction) => transaction != null)
            .cast<RecentTransactionModel>()
            .toList() ?? [];
        print('FinancialSummaryModel: Successfully parsed ${recentTransactions.length} transactions');
      } catch (e) {
        print('Error parsing recent_transactions list: $e');
        recentTransactions = [];
      }
      
      // Parse fee breakdown
      List<FeeBreakdownModel> feeBreakdown = [];
      try {
        print('FinancialSummaryModel: Parsing fee_breakdown');
        feeBreakdown = (json['fee_breakdown'] as List<dynamic>?)
            ?.map((e) => FeeBreakdownModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];
        print('FinancialSummaryModel: Successfully parsed ${feeBreakdown.length} fee breakdown items');
      } catch (e) {
        print('Error parsing fee_breakdown: $e');
        feeBreakdown = [];
      }
      
      // Helper function to safely parse numeric values
       double parseDouble(dynamic value) {
         if (value == null) return 0.0;
         if (value is double) return value;
         if (value is int) return value.toDouble();
         if (value is String) {
           return double.tryParse(value) ?? 0.0;
         }
         return 0.0;
       }
       
       int parseInt(dynamic value) {
         if (value == null) return 0;
         if (value is int) return value;
         if (value is String) {
           return int.tryParse(value) ?? 0;
         }
         return 0;
       }
       
       print('FinancialSummaryModel: Creating final model');
       final model = FinancialSummaryModel(
         totalFees: parseDouble(json['total_fees']),
         paidThisSemester: parseDouble(json['paid_this_semester']),
         pendingPayments: parseDouble(json['pending_payments']),
         overdueCount: parseInt(json['overdue_count']),
         recentTransactions: recentTransactions,
         feeBreakdown: feeBreakdown,
       );
      print('FinancialSummaryModel: Successfully created model');
      return model;
    } catch (e, stackTrace) {
      print('FinancialSummaryModel: Critical error in fromJson: $e');
      print('FinancialSummaryModel: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'total_fees': totalFees,
      'paid_this_semester': paidThisSemester,
      'pending_payments': pendingPayments,
      'overdue_count': overdueCount,
      'recent_transactions': recentTransactions
          .map((e) => (e as RecentTransactionModel).toJson())
          .toList(),
      'fee_breakdown': feeBreakdown
          .map((e) => (e as FeeBreakdownModel).toJson())
          .toList(),
    };
  }
}

class RecentTransactionModel extends RecentTransaction {
  const RecentTransactionModel({
    required super.paymentId,
    required super.amount,
    required super.paymentDate,
    required super.paymentProvider,
    required super.status,
    required super.feeId,
    required super.feeType,
  });

  factory RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    try {
      // Helper function to safely parse amount
      double parseAmount(dynamic value) {
        if (value == null) return 0.0;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) {
          return double.tryParse(value) ?? 0.0;
        }
        return 0.0;
      }

      // Helper function to safely parse ID
      int parseId(dynamic value) {
        if (value == null) return 0;
        if (value is int) return value;
        if (value is String) {
          return int.tryParse(value) ?? 0;
        }
        return 0;
      }

      // Extract nested data according to PaymentSerializer structure
      final feeData = json['fee'] as Map<String, dynamic>? ?? {};
      final paymentProviderData = json['payment_provider'] as Map<String, dynamic>? ?? {};
      final feeTypeData = feeData['fee_type'] as Map<String, dynamic>? ?? {};
      
      // Extract payment date - it's directly available in the transaction
      final paymentDate = json['payment_date'] != null ? 
        DateTime.tryParse(json['payment_date'].toString()) ?? DateTime.now() : DateTime.now();
      
      return RecentTransactionModel(
        paymentId: parseId(json['id']),
        amount: parseAmount(json['amount']),
        paymentDate: paymentDate,
        paymentProvider: paymentProviderData['name']?.toString() ?? 'Unknown',
        status: json['status']?.toString() ?? 'unknown',
        feeId: parseId(feeData['id']),
        feeType: feeTypeData['name']?.toString() ?? 'Unknown',
      );
    } catch (e, stackTrace) {
      print('Error parsing RecentTransactionModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON keys: ${json.keys}');
      if (json['fee'] != null) {
        print('Fee keys: ${json['fee'].keys}');
      }
      if (json['payment_provider'] != null) {
        print('Payment provider keys: ${json['payment_provider'].keys}');
      }
      // Return a default transaction to prevent complete failure
      return RecentTransactionModel(
        paymentId: 0,
        amount: 0.0,
        paymentDate: DateTime.now(),
        paymentProvider: 'Unknown',
        status: 'unknown',
        feeId: 0,
        feeType: 'Unknown',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_provider': paymentProvider,
      'status': status,
      'fee_id': feeId,
      'fee_type': feeType,
    };
  }
}

class FeeBreakdownModel extends FeeBreakdown {
  const FeeBreakdownModel({
    required super.feeType,
    required super.totalAmount,
    required super.paidAmount,
    required super.remainingAmount,
    required super.count,
  });

  factory FeeBreakdownModel.fromJson(Map<String, dynamic> json) {
    try {
      // Extract nested fee_type data according to StudentFeeSerializer structure
      final feeTypeData = json['fee_type'] as Map<String, dynamic>? ?? {};
      String feeTypeName = feeTypeData['name']?.toString() ?? 'Unknown';
      
      // Helper function to safely parse amount
      double parseAmount(dynamic value) {
        if (value == null) return 0.0;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) {
          return double.tryParse(value) ?? 0.0;
        }
        return 0.0;
      }
      
      return FeeBreakdownModel(
        feeType: feeTypeName,
        totalAmount: parseAmount(json['amount']),
        paidAmount: parseAmount(json['amount_paid']),
        remainingAmount: parseAmount(json['remaining_balance']),
        count: 1, // Each StudentFee represents one fee item
      );
    } catch (e, stackTrace) {
      print('Error parsing FeeBreakdownModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON keys: ${json.keys}');
      if (json['fee_type'] != null) {
        print('Fee type keys: ${json['fee_type'].keys}');
      }
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'fee_type': feeType,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'count': count,
    };
  }
}