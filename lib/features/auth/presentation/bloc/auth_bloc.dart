import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(const AuthInitial()) {
    developer.log('AuthBloc initialized', name: 'AuthBloc');
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthGetCurrentUserRequested>(_onGetCurrentUserRequested);
  }
  
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    developer.log('Login requested for identifier: "${event.identifier}"', name: 'AuthBloc');
    emit(const AuthLoading());
    developer.log('Auth state changed to loading', name: 'AuthBloc');
    
    try {
      final result = await loginUseCase(event.identifier, event.password);
      
      result.fold(
        (failure) {
          developer.log('Login failed: ${failure.message}', name: 'AuthBloc');
          emit(AuthError(failure.message));
        },
        (user) {
          developer.log('Login successful for user: ${user.email}', name: 'AuthBloc');
          emit(AuthAuthenticated(user));
        },
      );
    } catch (e) {
      developer.log('Login error: $e', name: 'AuthBloc');
      emit(AuthError('An unexpected error occurred'));
    }
  }
  
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    developer.log('Logout requested', name: 'AuthBloc');
    emit(const AuthLoading());
    
    final result = await logoutUseCase();
    
    result.fold(
      (failure) {
        developer.log('Logout failed: ${failure.message}', name: 'AuthBloc');
        emit(AuthError(failure.message));
      },
      (_) {
        developer.log('Logout successful', name: 'AuthBloc');
        emit(const AuthUnauthenticated());
      },
    );
  }
  
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    developer.log('Auth check requested', name: 'AuthBloc');
    emit(const AuthLoading());
    
    final result = await getCurrentUserUseCase();
    
    result.fold(
      (failure) {
        developer.log('Auth check failed: ${failure.message}', name: 'AuthBloc');
        emit(const AuthUnauthenticated());
      },
      (user) {
        developer.log('Auth check successful for user: ${user.email}', name: 'AuthBloc');
        emit(AuthAuthenticated(user));
      },
    );
  }
  
  Future<void> _onGetCurrentUserRequested(
    AuthGetCurrentUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    developer.log('Get current user requested', name: 'AuthBloc');
    final result = await getCurrentUserUseCase();
    
    result.fold(
      (failure) {
        developer.log('Get current user failed: ${failure.message}', name: 'AuthBloc');
        emit(AuthError(failure.message));
      },
      (user) {
        developer.log('Get current user successful: ${user.email}', name: 'AuthBloc');
        emit(AuthAuthenticated(user));
      },
    );
  }
}