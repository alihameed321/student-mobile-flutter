import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../services/presentation/pages/service_request_form_page.dart';
import '../../../services/presentation/bloc/service_request/service_request_bloc.dart';
import '../../../main/presentation/bloc/navigation_bloc.dart';
import '../../../main/presentation/bloc/navigation_event.dart';
import '../../../financial/presentation/pages/financial_page.dart';
import '../../../documents/presentation/pages/documents_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

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
          Text(
            'إجراءات سريعة',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildQuickActionItem(
                context,
                icon: Icons.receipt_long,
                title: 'كشف الدرجات',
                color: AppColors.primary,
                onTap: () => _navigateToServiceRequest(context, 'transcript'),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.school,
                title: 'شهادة تسجيل',
                color: AppColors.success,
                onTap: () => _navigateToServiceRequest(context, 'enrollment_certificate'),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.payment,
                title: 'المدفوعات',
                color: AppColors.warning,
                onTap: () => _navigateToFinancial(context),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.schedule,
                title: 'الجدول الدراسي',
                color: AppColors.info,
                onTap: () => _navigateToServiceRequest(context, 'schedule'),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.folder,
                title: 'الوثائق',
                color: AppColors.secondary,
                onTap: () => _navigateToDocuments(context),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.support_agent,
                title: 'الدعم الفني',
                color: AppColors.error,
                onTap: () => _navigateToServiceRequest(context, 'support'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
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
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToServiceRequest(BuildContext context, String serviceType) {
    final serviceRequestBloc = di.sl<ServiceRequestBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: serviceRequestBloc,
          child: ServiceRequestFormPage(
            serviceType: serviceType,
          ),
        ),
      ),
    );
  }

  void _navigateToFinancial(BuildContext context) {
    // Navigate to financial tab
    context.read<NavigationBloc>().add(const NavigationTabChanged(1));
  }

  void _navigateToDocuments(BuildContext context) {
    // Navigate to documents tab
    context.read<NavigationBloc>().add(const NavigationTabChanged(3));
  }
}