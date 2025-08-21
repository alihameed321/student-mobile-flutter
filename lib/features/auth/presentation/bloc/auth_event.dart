import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String identifier; // Can be email or username
  final String password;
  
  const AuthLoginRequested({
    required this.identifier,
    required this.password,
  });
  
  @override
  List<Object> get props => [identifier, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthGetCurrentUserRequested extends AuthEvent {
  const AuthGetCurrentUserRequested();
}