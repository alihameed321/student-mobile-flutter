import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/download_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class DownloadIdCardUseCase extends UseCase<String, NoParams> {
  final DownloadService downloadService;
  final AuthRepository authRepository;
  final SharedPreferences sharedPreferences;

  DownloadIdCardUseCase({
    required this.downloadService,
    required this.authRepository,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, String>> call([NoParams? params]) async {
    try {
      // Check if user is logged in
      final isLoggedIn = sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
      if (!isLoggedIn) {
        return const Left(AuthenticationFailure('User not logged in'));
      }
      
      // Get authentication token
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);
      if (token == null) {
        return const Left(AuthenticationFailure('Authentication token not found'));
      }
      
      final filePath = await downloadService.downloadStudentIdCard(token);
      return Right(filePath);
    } catch (e) {
      return Left(UnknownFailure('Failed to download student ID card: $e'));
    }
  }
}