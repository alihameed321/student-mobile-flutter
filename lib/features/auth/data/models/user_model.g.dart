// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      studentId: json['university_id'] as String?,
      phone: json['phone_number'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isStaff: json['is_staff_member'] as bool,
      dateJoined: json['date_joined'] == null
          ? null
          : DateTime.parse(json['date_joined'] as String),
      major: json['major'] as String?,
      academicLevel: json['academic_level'] as String?,
      department: json['department'] as String?,
      profilePicture: json['profile_picture'] as String?,
      userType: json['user_type'] as String?,
      enrollmentYear: (json['enrollment_year'] as num?)?.toInt(),
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      studentIdNumber: json['student_id_number'] as String?,
      gpa: (json['gpa'] as num?)?.toDouble(),
      totalCredits: (json['total_credits'] as num?)?.toInt(),
      graduationDate: json['graduation_date'] == null
          ? null
          : DateTime.parse(json['graduation_date'] as String),
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'university_id': instance.studentId,
      'phone_number': instance.phone,
      'is_active': instance.isActive,
      'is_staff_member': instance.isStaff,
      'date_joined': instance.dateJoined?.toIso8601String(),
      'major': instance.major,
      'academic_level': instance.academicLevel,
      'department': instance.department,
      'profile_picture': instance.profilePicture,
      'user_type': instance.userType,
      'enrollment_year': instance.enrollmentYear,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'student_id_number': instance.studentIdNumber,
      'gpa': instance.gpa,
      'total_credits': instance.totalCredits,
      'graduation_date': instance.graduationDate?.toIso8601String(),
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
    };
