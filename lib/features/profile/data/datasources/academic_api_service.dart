import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/academic_info_model.dart';

abstract class AcademicApiService {
  Future<AcademicInfoModel> getAcademicInfo(String studentId);
}

class AcademicApiServiceImpl implements AcademicApiService {
  final DioClient _dioClient;

  AcademicApiServiceImpl(this._dioClient);

  @override
  Future<AcademicInfoModel> getAcademicInfo(String studentId) async {
    try {
      // For now, we'll use the dashboard endpoint which contains some academic info
      // In a real implementation, this would be a dedicated academic endpoint
      final response = await _dioClient.get(
        ApiConstants.studentDashboardEndpoint,
      );
      
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true && responseData['data'] != null) {
        final data = responseData['data'] as Map<String, dynamic>;
        
        // Extract academic information from dashboard data or use defaults
        final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
        
        // Only return data if we have actual academic information
        if (userInfo['gpa'] == null || userInfo['year'] == null) {
          throw Exception('Academic information not available');
        }
        
        return AcademicInfoModel(
          currentSemester: _extractSemester(data),
          gpa: userInfo['gpa']?.toDouble() ?? 0.0,
          earnedHours: _calculateEarnedHours(data),
          expectedGraduation: _calculateGraduation(data),
          academicLevel: userInfo['year'] ?? 'غير محدد',
          totalCredits: userInfo['total_credits'] as int? ?? 0,
          remainingCredits: _calculateRemainingCredits(data),
        );
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch academic info: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch academic info: $e');
    }
  }
  
  String _extractSemester(Map<String, dynamic> data) {
    // Try to extract current semester from various possible fields
    final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
    return userInfo['current_semester'] ?? userInfo['year'] ?? 'غير محدد';
  }
  
  int _calculateEarnedHours(Map<String, dynamic> data) {
    // Use actual earned hours from API if available
    final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
    return userInfo['earned_hours'] as int? ?? userInfo['completed_credits'] as int? ?? 0;
  }
  
  String _calculateGraduation(Map<String, dynamic> data) {
    final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
    
    // Use expected graduation date from API if available
    if (userInfo['expected_graduation'] != null) {
      return userInfo['expected_graduation'].toString();
    }
    
    // If no graduation date available, return empty
    return 'غير محدد';
  }
  
  int _calculateRemainingCredits(Map<String, dynamic> data) {
    final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
    final earnedHours = _calculateEarnedHours(data);
    final totalCredits = userInfo['total_credits'] as int? ?? 0;
    
    if (totalCredits > 0 && earnedHours > 0) {
      return totalCredits - earnedHours;
    }
    
    return 0;
  }
}