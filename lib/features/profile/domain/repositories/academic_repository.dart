import '../entities/academic_info.dart';

abstract class AcademicRepository {
  Future<AcademicInfo> getAcademicInfo(String studentId);
}