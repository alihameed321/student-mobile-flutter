import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  @override
  void initState() {
    super.initState();
    developer.log('LoginForm initialized', name: 'LoginForm');
  }
  
  @override
  void dispose() {
    developer.log('LoginForm disposing', name: 'LoginForm');
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        developer.log('Auth state changed: ${state.runtimeType}', name: 'LoginForm');
        final isLoading = state is AuthLoading;
        
        if (state is AuthError) {
          developer.log('Authentication failed: ${state.message}', name: 'LoginForm');
        } else if (state is AuthAuthenticated) {
          developer.log('Authentication successful for user: ${state.user.email}', name: 'LoginForm');
        } else if (state is AuthLoading) {
          developer.log('Authentication in progress', name: 'LoginForm');
        }
        
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email or Username Field
              TextFormField(
                controller: _identifierController,
                keyboardType: TextInputType.text,
                enabled: !isLoading,
                onChanged: (value) {
                  developer.log('Identifier field changed: ${value.length} characters', name: 'LoginForm');
                },
                decoration: InputDecoration(
                  labelText: 'Email or Username',
                  hintText: 'Enter your email or username',
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  developer.log('Validating identifier field: "${value ?? 'null'}"', name: 'LoginForm');
                  if (value == null || value.isEmpty) {
                    developer.log('Identifier validation failed: empty field', name: 'LoginForm');
                    return 'Please enter your email or username';
                  }
                  // Allow both email and username formats
                  if (value.length < 3) {
                    developer.log('Identifier validation failed: too short (${value.length} chars)', name: 'LoginForm');
                    return 'Must be at least 3 characters long';
                  }
                  developer.log('Identifier validation passed', name: 'LoginForm');
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                enabled: !isLoading,
                onChanged: (value) {
                  developer.log('Password field changed: ${value.length} characters', name: 'LoginForm');
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      developer.log('Password visibility toggled: ${!_obscurePassword ? 'hidden' : 'visible'}', name: 'LoginForm');
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  developer.log('Validating password field: ${value?.length ?? 0} characters', name: 'LoginForm');
                  if (value == null || value.isEmpty) {
                    developer.log('Password validation failed: empty field', name: 'LoginForm');
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    developer.log('Password validation failed: too short (${value.length} chars)', name: 'LoginForm');
                    return 'Password must be at least 6 characters';
                  }
                  developer.log('Password validation passed', name: 'LoginForm');
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Login Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Forgot Password
              TextButton(
                onPressed: isLoading ? null : _onForgotPasswordPressed,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _onLoginPressed() {
    developer.log('Login button pressed', name: 'LoginForm');
    developer.log('Form validation started', name: 'LoginForm');
    
    if (_formKey.currentState!.validate()) {
      developer.log('Form validation passed', name: 'LoginForm');
      final identifier = _identifierController.text.trim();
      final isEmail = identifier.contains('@');
      
      developer.log('Login attempt - Type: ${isEmail ? 'email' : 'username'}, Identifier: "$identifier"', name: 'LoginForm');
      
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          identifier: identifier,
          password: _passwordController.text,
        ),
      );
    } else {
      developer.log('Form validation failed', name: 'LoginForm');
    }
  }
  
  void _onForgotPasswordPressed() {
    developer.log('Forgot password button pressed', name: 'LoginForm');
    // TODO: Implement forgot password functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password functionality coming soon!'),
      ),
    );
  }
}