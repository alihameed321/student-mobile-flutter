// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      studentId: json['studentId'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool,
      isStaff: json['isStaff'] as bool,
      dateJoined: json['dateJoined'] == null
          ? null
          : DateTime.parse(json['dateJoined'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'studentId': instance.studentId,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'isStaff': instance.isStaff,
      'dateJoined': instance.dateJoined?.toIso8601String(),
    };
