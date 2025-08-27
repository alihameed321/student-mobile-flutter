import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/service_request.dart';
import '../../domain/entities/student_document.dart';
import '../../domain/entities/support_ticket.dart';

// Helper function to convert color strings to Color objects
Color _getColorFromString(String colorString) {
  switch (colorString.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'orange':
      return Colors.orange;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

class RecentActivitiesWidget extends StatelessWidget {
  final DashboardStats dashboardStats;

  const RecentActivitiesWidget({
    super.key,
    required this.dashboardStats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأنشطة الحديثة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        
        // Recent Service Requests
        if (dashboardStats.recentServiceRequests.isNotEmpty) ...[
          _buildSectionHeader(context, 'طلبات الخدمة', Icons.assignment),
          const SizedBox(height: 8),
          ...dashboardStats.recentServiceRequests.take(3).map(
            (request) => _buildServiceRequestItem(context, request),
          ),
          const SizedBox(height: 16),
        ],
        
        // Recent Documents
        if (dashboardStats.recentDocuments.isNotEmpty) ...[
          _buildSectionHeader(context, 'الوثائق', Icons.description),
          const SizedBox(height: 8),
          ...dashboardStats.recentDocuments.take(3).map(
            (document) => _buildDocumentItem(context, document),
          ),
          const SizedBox(height: 16),
        ],
        
        // Recent Support Tickets
        if (dashboardStats.recentSupportTickets.isNotEmpty) ...[
          _buildSectionHeader(context, 'تذاكر الدعم', Icons.support),
          const SizedBox(height: 8),
          ...dashboardStats.recentSupportTickets.take(3).map(
            (ticket) => _buildSupportTicketItem(context, ticket),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRequestItem(BuildContext context, ServiceRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorFromString(request.statusColor).withOpacity(0.1),
          child: Icon(
            request.isCompleted ? Icons.check_circle : 
            request.isPending ? Icons.pending : Icons.assignment,
            color: _getColorFromString(request.statusColor),
            size: 20,
          ),
        ),
        title: Text(
          request.requestType,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.description.length > 50 
                ? '${request.description.substring(0, 50)}...'
                : request.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy').format(request.createdAt),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getColorFromString(request.statusColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            request.status,
            style: TextStyle(
              color: _getColorFromString(request.statusColor),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          // Navigate to service request detail
          // TODO: Implement navigation
        },
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, StudentDocument document) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: document.officialStatusColor.withOpacity(0.1),
          child: Icon(
            document.isOfficial ? Icons.verified : Icons.description,
            color: document.officialStatusColor,
            size: 20,
          ),
        ),
        title: Text(
          document.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document.documentTypeDisplayName,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  document.downloadCountText,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(document.issuedDate),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: document.officialStatusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            document.officialStatus,
            style: TextStyle(
              color: document.officialStatusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          // Navigate to document detail or download
          // TODO: Implement navigation
        },
      ),
    );
  }

  Widget _buildSupportTicketItem(BuildContext context, SupportTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: ticket.statusColor.withOpacity(0.1),
          child: Icon(
            ticket.isResolved ? Icons.check_circle : 
            ticket.isOpen ? Icons.help_outline : Icons.support,
            color: ticket.statusColor,
            size: 20,
          ),
        ),
        title: Text(
          ticket.subject,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.categoryDisplayName,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ticket.priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket.priority,
                    style: TextStyle(
                      color: ticket.priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(ticket.createdAt),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ticket.statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ticket.status,
            style: TextStyle(
              color: ticket.statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          // Navigate to support ticket detail
          // TODO: Implement navigation
        },
      ),
    );
  }
}