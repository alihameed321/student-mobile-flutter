import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/domain/entities/user.dart';

class AcademicProgressCard extends StatelessWidget {
  const AcademicProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                'التقدم الأكاديمي',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is AuthLoading) {
                    return const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthGetCurrentUserRequested(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is AuthLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (authState is AuthAuthenticated) {
                return _buildProgressContent(authState.user);
              } else if (authState is AuthError) {
                return _buildErrorContent();
              }
              return _buildDefaultContent();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressContent(User user) {
    final earnedHours = user.earnedHours ?? 0;
    final totalCredits = user.totalCredits ?? 132;
    final progressPercentage = totalCredits > 0 ? (earnedHours / totalCredits * 100) : 0.0;
    final progress = totalCredits > 0 ? (earnedHours / totalCredits) : 0.0;
    
    return Column(
      children: [
        // Overall Progress
        _buildProgressSection(
          title: 'إجمالي التقدم',
          progress: progress,
          current: earnedHours,
          total: totalCredits,
          unit: 'ساعة',
          color: progressPercentage > 80 
              ? AppColors.success 
              : AppColors.primary,
        ),
        const SizedBox(height: 20),
        
        // Academic Status
        _buildStatusCard(
          title: 'الحالة الأكاديمية',
          status: _getAcademicStatus(user.gpa ?? 0.0),
          gpa: user.formattedGpa,
          color: _getGpaColor(user.gpa ?? 0.0),
        ),
        const SizedBox(height: 16),
        
        // Graduation Info
        _buildGraduationInfo(user),
        
        // Quick Stats
        const SizedBox(height: 16),
        _buildQuickStats(user),
      ],
    );
  }

  Widget _buildProgressSection({
    required String title,
    required double progress,
    required int current,
    required int total,
    required String unit,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$current/$total $unit',
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}% مكتمل',
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required String gpa,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.grade,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      status,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($gpa)',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraduationInfo(User user) {
    final isNearGraduation = user.isNearGraduation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNearGraduation 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isNearGraduation ? Icons.celebration : Icons.schedule,
            color: isNearGraduation ? AppColors.success : AppColors.info,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isNearGraduation ? 'قريب من التخرج!' : 'التخرج المتوقع',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isNearGraduation ? AppColors.success : AppColors.info,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isNearGraduation 
                      ? 'متبقي ${user.remainingCredits ?? 0} ساعة فقط'
                      : 'العام ${user.expectedGraduation}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(User user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'المستوى الحالي',
            user.academicLevel ?? 'غير محدد',
            Icons.school,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'الساعات المتبقية',
            '${user.remainingCredits ?? 0}',
            Icons.pending_actions,
            AppColors.warning,
          ),
        ),
      ],
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
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
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

  Widget _buildErrorContent() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل بيانات التقدم الأكاديمي',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey[400],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات تقدم أكاديمي متاحة',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى تسجيل الدخول لعرض تقدمك الأكاديمي',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
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

  String _getAcademicStatus(double gpa) {
    if (gpa >= 3.5) return 'ممتاز';
    if (gpa >= 3.0) return 'جيد جداً';
    if (gpa >= 2.5) return 'جيد';
    if (gpa >= 2.0) return 'مقبول';
    return 'ضعيف';
  }
}