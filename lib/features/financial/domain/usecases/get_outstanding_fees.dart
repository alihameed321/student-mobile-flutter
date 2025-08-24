import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/student_fee.dart';
import '../repositories/financial_repository.dart';

class GetOutstandingFees {
  final FinancialRepository repository;

  GetOutstandingFees(this.repository);

  Future<Either<Failure, List<StudentFee>>> call() async {
    return await repository.getOutstandingFees();
  }
}