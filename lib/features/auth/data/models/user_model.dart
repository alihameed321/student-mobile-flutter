import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
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

  const UserModel({
    required super.id,
    required super.email,
    required this.firstName,
    required this.lastName,
    this.studentId,
    this.phone,
    required this.isActive,
    required this.isStaff,
    this.dateJoined,
  }) : super(
    firstName: firstName,
    lastName: lastName,
    studentId: studentId,
    phone: phone,
    isActive: isActive,
    isStaff: isStaff,
    dateJoined: dateJoined,
  );
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      studentId: user.studentId,
      phone: user.phone,
      isActive: user.isActive,
      isStaff: user.isStaff,
      dateJoined: user.dateJoined,
    );
  }
}