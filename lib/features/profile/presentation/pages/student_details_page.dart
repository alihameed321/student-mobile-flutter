import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/api_constants.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'تفاصيل الطالب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Profile Picture and Basic Info
                  _buildProfileSection(context, user),
                  const SizedBox(height: 24),

                  // Personal Information
                  _buildSectionCard(
                    'المعلومات الشخصية',
                    Icons.person_outline,
                    [
                      _buildInfoRow('الاسم الكامل', user.fullName),
            _buildInfoRow('الرقم الجامعي', user.studentId ?? 'غير متوفر'),
            _buildInfoRow('البريد الإلكتروني', user.email),
                      _buildInfoRow(
                          'رقم الهاتف',
                          user.phone?.isNotEmpty == true
                              ? user.phone!
                              : 'غير متوفر'),
                      _buildInfoRow(
                          'تاريخ الانضمام',
                          user.dateJoined?.toString().split(' ')[0] ??
                              'غير متوفر'),
                      _buildInfoRow('نوع المستخدم',
                          user.userType?.toUpperCase() ?? 'غير محدد'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Academic Information
                  _buildSectionCard(
                      'المعلومات الأكاديمية',
                    Icons.school_outlined,
                    [
                      _buildInfoRow('التخصص', user.major ?? 'غير محدد'),
                        _buildInfoRow('المستوى الأكاديمي',
                            user.academicLevel ?? 'غير محدد'),
                        _buildInfoRow('الرقم الجامعي',
                            user.universityId ?? 'غير محدد'),
                        _buildInfoRow('حالة الطالب',
                            user.isActive ? 'نشط' : 'غير نشط'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Account Information
                  _buildSectionCard(
                      'معلومات الحساب',
                    Icons.account_circle_outlined,
                    [
                      _buildInfoRow('حالة الحساب',
                            user.isActive ? 'نشط' : 'غير نشط'),
                        _buildInfoRow(
                            'عضو هيئة تدريس', user.isStaff ? 'نعم' : 'لا'),
                        _buildInfoRow(
                            'تاريخ الانضمام',
                            user.dateJoined?.toString().split(' ')[0] ??
                                'غير متوفر'),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('يرجى تسجيل الدخول لعرض تفاصيل الطالب'),
          );
        },
      ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        textDirection: ui.TextDirection.rtl,
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundImage: user.profilePicture != null
                  ? NetworkImage(
                      '${ApiConstants.baseUrl}${user.profilePicture!}')
                  : null,
              backgroundColor: Colors.grey[200],
              child: user.profilePicture == null
                  ? Text(
                      '${user.firstName[0]}${user.lastName[0]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 16),

          // Basic Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.major ?? 'لم يتم تحديد التخصص',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'الرقم الجامعي: ${user.studentId ?? 'غير متوفر'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              textDirection: ui.TextDirection.rtl,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          textDirection: ui.TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
