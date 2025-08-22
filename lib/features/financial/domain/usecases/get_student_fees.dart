import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/student_fee.dart';
import '../repositories/financial_repository.dart';

class GetStudentFees {
  final FinancialRepository repository;

  GetStudentFees(this.repository);

  Future<Either<Failure, List<StudentFee>>> call(String studentId) async {
    return await repository.getStudentFees(studentId);
  }
}