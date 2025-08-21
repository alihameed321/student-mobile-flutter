import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;
  
  AuthRepositoryImpl(this.remoteDataSource, this.prefs);
  
  @override
  Future<Either<Failure, User>> login(String identifier, String password) async {
    try {
      final user = await remoteDataSource.login(identifier, password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on AuthenticationException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('An unexpected error occurred'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
      final hasToken = prefs.getString(AppConstants.accessTokenKey) != null;
      return Right(isLoggedIn && hasToken);
    } catch (e) {
      return Left(CacheFailure('Failed to check login status'));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveUserData(User user) async {
    try {
      // This is handled in the remote data source
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save user data'));
    }
  }
  
  @override
  Future<Either<Failure, void>> clearUserData() async {
    try {
      await prefs.remove(AppConstants.accessTokenKey);
      await prefs.remove(AppConstants.refreshTokenKey);
      await prefs.remove(AppConstants.userDataKey);
      await prefs.setBool(AppConstants.isLoggedInKey, false);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear user data'));
    }
  }
}