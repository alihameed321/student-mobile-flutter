import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
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
  
  const User({
    required this.id,
    required this.email,
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
  });
  
  String get fullName => '$firstName $lastName';
  
  @override
  List<Object?> get props => [
    id,
    email,
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
  ];
}