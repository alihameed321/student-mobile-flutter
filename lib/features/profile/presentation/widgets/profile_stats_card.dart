import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Container(
          margin: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'نظرة عامة أكاديمية',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () {
                      if (authState is AuthAuthenticated) {
                        context.read<AuthBloc>().add(AuthGetCurrentUserRequested());
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (authState is AuthAuthenticated)
                _buildAcademicContent(authState.user)
              else
                _buildEmptyState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAcademicContent(user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'الفصل الحالي',
                user.currentSemester,
                Icons.school,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                'المعدل التراكمي',
                user.formattedGpa,
                Icons.grade,
                _getGpaColor(user.gpa ?? 0.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'الساعات المكتسبة',
                '${user.earnedHours ?? 0}/132',
                Icons.access_time,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                'التخرج المتوقع',
                user.expectedGraduation,
                Icons.celebration,
                user.isNearGraduation ? AppColors.success : AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildProgressBar(user),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[400],
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'لا توجد بيانات أكاديمية متاحة',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى تسجيل الدخول لعرض البيانات الأكاديمية',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }



  Color _getGpaColor(double gpa) {
    if (gpa >= 3.5) return AppColors.success;
    if (gpa >= 2.5) return AppColors.warning;
    return AppColors.error;
  }

  Widget _buildProgressBar(user) {
    final earnedHours = user.earnedHours ?? 0;
    const totalRequiredCredits = 132; // Standard requirement
    final progress = earnedHours / totalRequiredCredits;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تقدم الدراسة',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.8 ? AppColors.success : AppColors.primary,
          ),
        ),
      ],
    );
  }
}