import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @override
  final String username;
  
  @JsonKey(name: 'first_name')
  @override
  final String firstName;
  
  @JsonKey(name: 'last_name')
  @override
  final String lastName;
  
  @JsonKey(name: 'university_id')
  @override
  final String? studentId;
  
  @JsonKey(name: 'phone_number')
  @override
  final String? phone;
  
  @JsonKey(name: 'is_active', defaultValue: true)
  @override
  final bool isActive;
  
  @JsonKey(name: 'is_staff_member')
  @override
  final bool isStaff;
  
  @JsonKey(name: 'date_joined')
  @override
  final DateTime? dateJoined;
  
  @JsonKey(name: 'major')
  @override
  final String? major;
  
  @JsonKey(name: 'academic_level')
  @override
  final String? academicLevel;
  
  @JsonKey(name: 'department')
  @override
  final String? department;
  
  @JsonKey(name: 'profile_picture')
  @override
  final String? profilePicture;
  
  @JsonKey(name: 'user_type')
  @override
  final String? userType;
  
  @JsonKey(name: 'enrollment_year')
  @override
  final int? enrollmentYear;
  
  @JsonKey(name: 'date_of_birth')
  @override
  final DateTime? dateOfBirth;
  
  @JsonKey(name: 'student_id_number')
  @override
  final String? studentIdNumber;
  
  @JsonKey(name: 'gpa')
  @override
  final double? gpa;
  
  @JsonKey(name: 'total_credits')
  @override
  final int? totalCredits;
  
  @JsonKey(name: 'graduation_date')
  @override
  final DateTime? graduationDate;
  
  @JsonKey(name: 'emergency_contact_name')
  @override
  final String? emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  @override
  final String? emergencyContactPhone;

  const UserModel({
    required super.id,
    required super.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.studentId,
    this.phone,
    required this.isActive,
    required this.isStaff,
    this.dateJoined,
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
  }) : super(
    username: username,
    firstName: firstName,
    lastName: lastName,
    studentId: studentId,
    phone: phone,
    isActive: isActive,
    isStaff: isStaff,
    dateJoined: dateJoined,
    universityId: studentId,
    major: major,
    academicLevel: academicLevel,
    department: department,
    profilePicture: profilePicture,
    userType: userType,
    enrollmentYear: enrollmentYear,
    dateOfBirth: dateOfBirth,
    studentIdNumber: studentIdNumber,
    gpa: gpa,
    totalCredits: totalCredits,
    graduationDate: graduationDate,
    emergencyContactName: emergencyContactName,
    emergencyContactPhone: emergencyContactPhone,
  );
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Extract student profile data if available
    final studentProfile = json['student_profile'] as Map<String, dynamic>?;
    
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      studentId: json['university_id'],
      phone: json['phone_number'],
      isActive: json['is_active'] ?? json['is_student'] ?? true,
      isStaff: json['is_staff_member'] ?? false,
      dateJoined: json['date_joined'] != null
          ? DateTime.tryParse(json['date_joined'])
          : null,
      major: json['major'],
      academicLevel: json['academic_level'],
      department: json['department'],
      profilePicture: json['profile_picture'],
      userType: json['user_type'],
      enrollmentYear: json['enrollment_year'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      // Student Profile fields
      studentIdNumber: studentProfile?['student_id_number'],
      gpa: studentProfile?['gpa'] != null 
          ? double.tryParse(studentProfile!['gpa'].toString()) 
          : null,
      totalCredits: studentProfile?['total_credits'],
      graduationDate: studentProfile?['graduation_date'] != null
          ? DateTime.tryParse(studentProfile!['graduation_date'])
          : null,
      emergencyContactName: studentProfile?['emergency_contact_name'],
      emergencyContactPhone: studentProfile?['emergency_contact_phone'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'university_id': studentId,
      'phone_number': phone,
      'is_active': isActive,
      'is_staff_member': isStaff,
      'date_joined': dateJoined?.toIso8601String(),
      'major': major,
      'academic_level': academicLevel,
      'department': department,
      'profile_picture': profilePicture,
      'user_type': userType,
      'enrollment_year': enrollmentYear,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'student_profile': {
        'student_id_number': studentIdNumber,
        'gpa': gpa,
        'total_credits': totalCredits,
        'graduation_date': graduationDate?.toIso8601String(),
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
      },
    };
  }
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      studentId: user.studentId,
      phone: user.phone,
      isActive: user.isActive,
      isStaff: user.isStaff,
      dateJoined: user.dateJoined,
      major: user.major,
      academicLevel: user.academicLevel,
      department: user.department,
      profilePicture: user.profilePicture,
      userType: user.userType,
      enrollmentYear: user.enrollmentYear,
      dateOfBirth: user.dateOfBirth,
      studentIdNumber: user.studentIdNumber,
      gpa: user.gpa,
      totalCredits: user.totalCredits,
      graduationDate: user.graduationDate,
      emergencyContactName: user.emergencyContactName,
      emergencyContactPhone: user.emergencyContactPhone,
    );
  }
}