import '../../domain/entities/academic_info.dart';
import '../../domain/repositories/academic_repository.dart';
import '../datasources/academic_api_service.dart';

class AcademicRepositoryImpl implements AcademicRepository {
  final AcademicApiService _apiService;

  AcademicRepositoryImpl(this._apiService);

  @override
  Future<AcademicInfo> getAcademicInfo(String studentId) async {
    try {
      final academicInfoModel = await _apiService.getAcademicInfo(studentId);
      return academicInfoModel;
    } catch (e) {
      throw Exception('Failed to get academic info: $e');
    }
  }
}