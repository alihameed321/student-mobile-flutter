import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsWidget extends StatelessWidget {
  final DashboardStats dashboardStats;

  const DashboardStatsWidget({
    super.key,
    required this.dashboardStats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        
        // Service Requests Stats
        _buildStatsSection(
          context,
          'Service Requests',
          [
            _StatItem(
              label: 'Total',
              value: dashboardStats.totalServiceRequests.toString(),
              color: Colors.blue,
              icon: Icons.assignment,
            ),
            _StatItem(
              label: 'Pending',
              value: dashboardStats.pendingServiceRequests.toString(),
              color: Colors.orange,
              icon: Icons.pending,
            ),
            _StatItem(
              label: 'Completed',
              value: dashboardStats.completedServiceRequests.toString(),
              color: Colors.green,
              icon: Icons.check_circle,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Documents Stats
        _buildStatsSection(
          context,
          'Documents',
          [
            _StatItem(
              label: 'Total',
              value: dashboardStats.totalDocuments.toString(),
              color: Colors.purple,
              icon: Icons.description,
            ),
            _StatItem(
              label: 'Verified',
              value: dashboardStats.verifiedDocuments.toString(),
              color: Colors.green,
              icon: Icons.verified,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Support Tickets Stats
        _buildStatsSection(
          context,
          'Support Tickets',
          [
            _StatItem(
              label: 'Total',
              value: dashboardStats.totalSupportTickets.toString(),
              color: Colors.red,
              icon: Icons.support,
            ),
            _StatItem(
              label: 'Open',
              value: dashboardStats.openSupportTickets.toString(),
              color: Colors.orange,
              icon: Icons.help_outline,
            ),
          ],
        ),
        
        // Completion Rate
        if (dashboardStats.totalServiceRequests > 0) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.green[600],
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Completion Rate',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(dashboardStats.serviceRequestCompletionRate * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    String title,
    List<_StatItem> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: items.map((item) => Expanded(
            child: _buildStatCard(context, item),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, _StatItem item) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(
                item.icon,
                color: item.color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                item.value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
}