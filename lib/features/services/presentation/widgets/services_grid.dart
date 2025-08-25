import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/service_request_form_page.dart';
import '../bloc/service_request/service_request_bloc.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'All Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
             ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildServiceCard(
              context,
              title: 'Enrollment Certificate',
              subtitle: 'Official enrollment verification',
              icon: Icons.school_outlined,
              color: Colors.blue,
              requestType: 'enrollment_certificate',
            ),
            _buildServiceCard(
              context,
              title: 'Schedule Modification',
              subtitle: 'Course schedule changes',
              icon: Icons.schedule_outlined,
              color: Colors.green,
              requestType: 'schedule_modification',
            ),
            _buildServiceCard(
              context,
              title: 'Semester Postponement',
              subtitle: 'Defer semester enrollment',
              icon: Icons.pause_circle_outline,
              color: Colors.orange,
              requestType: 'semester_postponement',
            ),
            _buildServiceCard(
              context,
              title: 'Official Transcript',
              subtitle: 'Academic records and grades',
              icon: Icons.description_outlined,
              color: Colors.purple,
              requestType: 'transcript',
            ),
            _buildServiceCard(
              context,
              title: 'Graduation Certificate',
              subtitle: 'Official graduation documents',
              icon: Icons.workspace_premium_outlined,
              color: Colors.red,
              requestType: 'graduation_certificate',
            ),
            _buildServiceCard(
              context,
              title: 'Other Services',
              subtitle: 'General inquiries and requests',
              icon: Icons.help_outline,
              color: Colors.teal,
              requestType: 'other',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String requestType,
  }) {
    return GestureDetector(
      onTap: () => _navigateToServiceRequest(context, requestType),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToServiceRequest(BuildContext context, String requestType) {
    final serviceRequestBloc = context.read<ServiceRequestBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: serviceRequestBloc,
          child: ServiceRequestFormPage(
            serviceType: requestType,
          ),
        ),
      ),
    );
  }
}