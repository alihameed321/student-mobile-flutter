// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      studentId: json['university_id'] as String?,
      phone: json['phone_number'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isStaff: json['is_staff_member'] as bool,
      dateJoined: json['date_joined'] == null
          ? null
          : DateTime.parse(json['date_joined'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'university_id': instance.studentId,
      'phone_number': instance.phone,
      'is_active': instance.isActive,
      'is_staff_member': instance.isStaff,
      'date_joined': instance.dateJoined?.toIso8601String(),
    };
