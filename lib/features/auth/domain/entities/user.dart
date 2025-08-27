import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? studentId;
  final String? phone;
  final bool isActive;
  final bool isStaff;
  final DateTime? dateJoined;
  final String? universityId;
  final String? major;
  final String? academicLevel;
  final String? department;
  final String? profilePicture;
  final String? userType;
  final int? enrollmentYear;
  final DateTime? dateOfBirth;
  
  // Student Profile fields
  final String? studentIdNumber;
  final double? gpa;
  final int? totalCredits;
  final DateTime? graduationDate;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.studentId,
    this.phone,
    required this.isActive,
    required this.isStaff,
    this.dateJoined,
    this.universityId,
    this.major,
    this.academicLevel,
    this.department,
    this.profilePicture,
    this.userType,
    this.enrollmentYear,
    this.dateOfBirth,
    this.studentIdNumber,
    this.gpa,
    this.totalCredits,
    this.graduationDate,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });
  
  String get fullName => '$firstName $lastName';
  
  // Academic helper methods
  String get formattedGpa => gpa != null ? gpa!.toStringAsFixed(2) : 'غير متوفر';
  
  int get earnedHours => totalCredits ?? 0;
  
  int get remainingCredits {
    if (totalCredits == null) return 0;
    // Assuming 132 total credits for graduation (can be made configurable)
    const int requiredCredits = 132;
    return requiredCredits - totalCredits!;
  }
  
  bool get isNearGraduation {
    if (totalCredits == null) return false;
    const int requiredCredits = 132;
    return (totalCredits! / requiredCredits) >= 0.8;
  }
  
  String get expectedGraduation {
    if (graduationDate != null) {
      return '${graduationDate!.year}';
    }
    return 'غير محدد';
  }
  
  String get currentSemester {
    return academicLevel ?? 'غير محدد';
  }
  
  @override
  List<Object?> get props => [
    id,
    email,
    username,
    firstName,
    lastName,
    studentId,
    phone,
    isActive,
    isStaff,
    dateJoined,
    universityId,
    major,
    academicLevel,
    department,
    profilePicture,
    userType,
    enrollmentYear,
    dateOfBirth,
    studentIdNumber,
    gpa,
    totalCredits,
    graduationDate,
    emergencyContactName,
    emergencyContactPhone,
  ];
}