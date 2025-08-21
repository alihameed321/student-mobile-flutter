import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;
  
  AuthRemoteDataSourceImpl(this.client);
  
  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        ApiConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        if (data['access'] != null) {
          await prefs.setString(AppConstants.accessTokenKey, data['access']);
        }
        if (data['refresh'] != null) {
          await prefs.setString(AppConstants.refreshTokenKey, data['refresh']);
        }
        
        // Mark as logged in
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        
        // Return user data
        final userModel = UserModel.fromJson(data['user']);
        
        // Save user data locally
        await prefs.setString(
          AppConstants.userDataKey,
          jsonEncode(userModel.toJson()),
        );
        
        return userModel;
      } else {
        throw ServerException(
          'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
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
      final prefs = await SharedPreferences.getInstance();
      // First try to get from local storage
      final userData = prefs.getString(AppConstants.userDataKey);
      if (userData != null) {
        final userJson = jsonDecode(userData);
        return UserModel.fromJson(userJson);
      }
      
      // If not in local storage, fetch from API
      final response = await client.get(ApiConstants.userProfileEndpoint);
      
      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.data);
        
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
      if (e is ServerException) rethrow;
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