import '../entities/academic_info.dart';
import '../repositories/academic_repository.dart';

class GetAcademicInfo {
  final AcademicRepository _repository;

  GetAcademicInfo(this._repository);

  Future<AcademicInfo> call(String studentId) async {
    return await _repository.getAcademicInfo(studentId);
  }
}