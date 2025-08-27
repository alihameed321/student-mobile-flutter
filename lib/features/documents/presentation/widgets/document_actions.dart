import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/documents_bloc.dart';
import '../../../services/presentation/pages/service_request_form_page.dart';
import '../../../services/presentation/pages/service_requests_page.dart';
import '../../../services/presentation/bloc/service_request/service_request_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;

class DocumentActions extends StatelessWidget {
  const DocumentActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.request_page,
                  label: 'طلب وثيقة',
                  color: Colors.orange,
                  onTap: () {
                    _showDocumentRequestOptions(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.list_alt,
                  label: 'طلباتي',
                  color: Colors.blue,
                  onTap: () {
                    _navigateToMyRequests(context);
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }



  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 100, // Reduced height to prevent overflow
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentRequestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'طلب وثيقة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'اختر نوع الوثيقة التي تحتاجها',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Document options
            _buildDocumentOption(
              context,
              icon: Icons.school_rounded,
              title: 'شهادة القيد',
          subtitle: 'التحقق الرسمي من القيد',
              color: const Color(0xFF2196F3),
              requestType: 'enrollment_certificate',
            ),
            _buildDocumentOption(
              context,
              icon: Icons.description_rounded,
              title: 'كشف الدرجات الرسمي',
          subtitle: 'السجلات الأكاديمية والدرجات',
              color: const Color(0xFF9C27B0),
              requestType: 'transcript',
            ),
            _buildDocumentOption(
              context,
              icon: Icons.workspace_premium_rounded,
              title: 'شهادة التخرج',
          subtitle: 'وثائق التخرج الرسمية',
              color: const Color(0xFFE91E63),
              requestType: 'graduation_certificate',
            ),
            _buildDocumentOption(
              context,
              icon: Icons.support_agent_rounded,
              title: 'وثائق أخرى',
          subtitle: 'طلبات وثائق مخصصة',
              color: const Color(0xFF00BCD4),
              requestType: 'other',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String requestType,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close bottom sheet
        _navigateToServiceRequest(context, requestType);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToServiceRequest(BuildContext context, String requestType) async {
    final serviceRequestBloc = di.sl<ServiceRequestBloc>();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: serviceRequestBloc,
          child: ServiceRequestFormPage(
            serviceType: requestType,
          ),
        ),
      ),
    );
    
    // Refresh documents when returning from service request
    if (result == true) {
      if (context.mounted) {
        context.read<DocumentsBloc>().add(RefreshDocuments());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تقديم طلب الوثيقة بنجاح!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _navigateToMyRequests(BuildContext context) async {
    final serviceRequestBloc = di.sl<ServiceRequestBloc>();
    // Load service requests before navigation
    serviceRequestBloc.add(LoadServiceRequests());
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: serviceRequestBloc,
          child: const ServiceRequestsPage(),
        ),
      ),
    );
  }
}
