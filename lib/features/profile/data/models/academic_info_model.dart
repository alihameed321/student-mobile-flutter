import '../../domain/entities/academic_info.dart';

class AcademicInfoModel extends AcademicInfo {
  const AcademicInfoModel({
    required super.currentSemester,
    required super.gpa,
    required super.earnedHours,
    required super.expectedGraduation,
    required super.academicLevel,
    required super.totalCredits,
    required super.remainingCredits,
  });

  factory AcademicInfoModel.fromJson(Map<String, dynamic> json) {
    return AcademicInfoModel(
      currentSemester: json['current_semester'] as String? ?? 'غير محدد',
      gpa: (json['gpa'] as num?)?.toDouble() ?? 0.0,
      earnedHours: json['earned_hours'] as int? ?? 0,
      expectedGraduation: json['expected_graduation'] as String? ?? 'غير محدد',
      academicLevel: json['academic_level'] as String? ?? 'غير محدد',
      totalCredits: json['total_credits'] as int? ?? 0,
      remainingCredits: json['remaining_credits'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_semester': currentSemester,
      'gpa': gpa,
      'earned_hours': earnedHours,
      'expected_graduation': expectedGraduation,
      'academic_level': academicLevel,
      'total_credits': totalCredits,
      'remaining_credits': remainingCredits,
    };
  }

  factory AcademicInfoModel.fromEntity(AcademicInfo entity) {
    return AcademicInfoModel(
      currentSemester: entity.currentSemester,
      gpa: entity.gpa,
      earnedHours: entity.earnedHours,
      expectedGraduation: entity.expectedGraduation,
      academicLevel: entity.academicLevel,
      totalCredits: entity.totalCredits,
      remainingCredits: entity.remainingCredits,
    );
  }
}