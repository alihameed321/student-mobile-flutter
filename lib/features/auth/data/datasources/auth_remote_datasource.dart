import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String identifier, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> login(String identifier, String password) async {
    try {
      developer.log('Starting login request for identifier: $identifier', name: 'AuthRemoteDataSource');
      
      final response = await client.post(
        ApiConstants.loginEndpoint,
        data: {
          'identifier': identifier,
          'password': password,
        },
      );
      
      developer.log('Login response status: ${response.statusCode}', name: 'AuthRemoteDataSource');
      developer.log('Login response data: ${response.data}', name: 'AuthRemoteDataSource');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Check if response has expected structure
        if (data == null) {
          developer.log('Response data is null', name: 'AuthRemoteDataSource');
          throw const ServerException('Invalid response format');
        }
        
        if (data['success'] != true) {
          developer.log('Response success is false: ${data['success']}', name: 'AuthRemoteDataSource');
          throw ServerException(data['message'] ?? 'Login failed');
        }
        
        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        if (data['access_token'] != null) {
          await prefs.setString(AppConstants.accessTokenKey, data['access_token']);
          developer.log('Access token saved', name: 'AuthRemoteDataSource');
        } else {
          developer.log('No access token in response', name: 'AuthRemoteDataSource');
        }
        
        if (data['refresh_token'] != null) {
          await prefs.setString(AppConstants.refreshTokenKey, data['refresh_token']);
          developer.log('Refresh token saved', name: 'AuthRemoteDataSource');
        } else {
          developer.log('No refresh token in response', name: 'AuthRemoteDataSource');
        }
        
        // Mark as logged in
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        
        // Check if user data exists
        if (data['user'] == null) {
          developer.log('No user data in response', name: 'AuthRemoteDataSource');
          throw const ServerException('No user data in response');
        }
        
        // Return user data
        developer.log('Parsing user data: ${data['user']}', name: 'AuthRemoteDataSource');
        final userModel = UserModel.fromJson(data['user']);
        
        // Save user data locally
        await prefs.setString(
          AppConstants.userDataKey,
          jsonEncode(userModel.toJson()),
        );
        
        developer.log('Login successful for user: ${userModel.email}', name: 'AuthRemoteDataSource');
        return userModel;
      } else {
        developer.log('Login failed with status code: ${response.statusCode}', name: 'AuthRemoteDataSource');
        throw ServerException(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      developer.log('Login error: $e', name: 'AuthRemoteDataSource');
      if (e is ServerException) rethrow;
      throw const ServerException('Login failed');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(AppConstants.refreshTokenKey);
      
      if (refreshToken != null) {
        await client.post(
          ApiConstants.logoutEndpoint,
          data: {'refresh': refreshToken},
        );
      }
      
      // Clear local data regardless of API call result
      await _clearLocalData();
    } catch (e) {
      // Clear local data even if API call fails
      await _clearLocalData();
      throw const ServerException('Logout failed');
    }
  }
  
  @override
  Future<UserModel> getCurrentUser() async {
    try {
      print('[AuthRemoteDataSource] getCurrentUser called');
      final prefs = await SharedPreferences.getInstance();
      
      // Check if user is logged in
      final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
      print('[AuthRemoteDataSource] isLoggedIn: $isLoggedIn');
      if (!isLoggedIn) {
        print('[AuthRemoteDataSource] User not logged in');
        throw const AuthenticationException('User not logged in');
      }
      
      // Check if access token exists
      final accessToken = prefs.getString(AppConstants.accessTokenKey);
      print('[AuthRemoteDataSource] accessToken exists: ${accessToken != null}');
      if (accessToken == null) {
        print('[AuthRemoteDataSource] No access token found');
        throw const AuthenticationException('No access token found');
      }
      
      // First try to get from local storage
      final userData = prefs.getString(AppConstants.userDataKey);
      print('[AuthRemoteDataSource] Local userData exists: ${userData != null}');
      if (userData != null) {
        try {
          final userJson = jsonDecode(userData);
          final user = UserModel.fromJson(userJson);
          print('[AuthRemoteDataSource] Successfully parsed local user data for: ${user.email}');
          return user;
        } catch (e) {
          print('[AuthRemoteDataSource] Failed to parse local user data: $e');
          developer.log('Failed to parse local user data: $e', name: 'AuthRemoteDataSource');
          // Continue to fetch from API if local data is corrupted
        }
      }

      // If not in local storage or corrupted, fetch from API
      print('[AuthRemoteDataSource] Fetching user data from API');
      final response = await client.get(ApiConstants.userProfileEndpoint);

      if (response.statusCode == 200) {
        // Extract user data from the nested response structure
        final userData = response.data['user'];
        if (userData == null) {
          throw const ServerException('User data not found in response');
        }
        
        final userModel = UserModel.fromJson(userData);

        // Save to local storage
        await prefs.setString(
          AppConstants.userDataKey,
          jsonEncode(userModel.toJson()),
        );

        return userModel;
      } else {
        throw ServerException(
          'Failed to get user data',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is AuthenticationException) rethrow;
      throw const ServerException('Failed to get user data');
    }
  }
  
  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.accessTokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userDataKey);
    await prefs.setBool(AppConstants.isLoggedInKey, false);
  }
}