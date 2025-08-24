import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';
import '../repositories/financial_repository.dart';

class GetPaymentProviders {
  final FinancialRepository repository;

  GetPaymentProviders(this.repository);

  Future<Either<Failure, List<PaymentProvider>>> call() async {
    return await repository.getPaymentProviders();
  }
}