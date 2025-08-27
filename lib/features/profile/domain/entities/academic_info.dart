import 'package:equatable/equatable.dart';

class AcademicInfo extends Equatable {
  final String currentSemester;
  final double gpa;
  final int earnedHours;
  final String expectedGraduation;
  final String academicLevel;
  final int totalCredits;
  final int remainingCredits;

  const AcademicInfo({
    required this.currentSemester,
    required this.gpa,
    required this.earnedHours,
    required this.expectedGraduation,
    required this.academicLevel,
    required this.totalCredits,
    required this.remainingCredits,
  });

  double get progressPercentage {
    if (totalCredits == 0) return 0.0;
    return (earnedHours / totalCredits) * 100;
  }

  String get formattedGpa {
    return gpa.toStringAsFixed(2);
  }

  bool get isNearGraduation {
    return remainingCredits <= 30; // Within 30 credits of graduation
  }

  String get academicStatus {
    if (gpa >= 3.5) return 'ممتاز';
    if (gpa >= 3.0) return 'جيد جداً';
    if (gpa >= 2.5) return 'جيد';
    if (gpa >= 2.0) return 'مقبول';
    return 'ضعيف';
  }

  @override
  List<Object?> get props => [
        currentSemester,
        gpa,
        earnedHours,
        expectedGraduation,
        academicLevel,
        totalCredits,
        remainingCredits,
      ];
}