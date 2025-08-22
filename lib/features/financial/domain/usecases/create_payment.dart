import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/financial_repository.dart';

class CreatePayment {
  final FinancialRepository repository;

  CreatePayment(this.repository);

  Future<Either<Failure, Payment>> call({
    required String studentId,
    required List<String> feeIds,
    required String paymentProviderId,
    required double amount,
  }) async {
    return await repository.createPayment(
      studentId: studentId,
      feeIds: feeIds,
      paymentProviderId: paymentProviderId,
      amount: amount,
    );
  }
}