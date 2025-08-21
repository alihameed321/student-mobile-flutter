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
  ];
}