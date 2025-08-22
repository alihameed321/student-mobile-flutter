import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/financial_summary.dart';
import '../repositories/financial_repository.dart';

class GetFinancialSummary {
  final FinancialRepository repository;

  GetFinancialSummary(this.repository);

  Future<Either<Failure, FinancialSummary>> call(String studentId) async {
    return await repository.getFinancialSummary(studentId);
  }
}