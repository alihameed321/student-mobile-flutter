import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/financial_repository.dart';

class GetPayments {
  final FinancialRepository repository;

  GetPayments(this.repository);

  Future<Either<Failure, List<Payment>>> call(String studentId) async {
    return await repository.getPayments(studentId);
  }
}