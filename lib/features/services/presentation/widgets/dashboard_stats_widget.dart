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
          'نظرة عامة على لوحة التحكم',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 20),
        
        // Main Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildModernStatCard(
              context,
              'طلبات الخدمة',
              dashboardStats.totalServiceRequests.toString(),
              Icons.assignment_outlined,
              [const Color(0xFF667EEA), const Color(0xFF764BA2)],
              '${dashboardStats.pendingServiceRequests} معلق',
            ),
            _buildModernStatCard(
              context,
              'الوثائق',
              dashboardStats.totalDocuments.toString(),
              Icons.description_outlined,
              [const Color(0xFF11998E), const Color(0xFF38EF7D)],
              '${dashboardStats.verifiedDocuments} موثق',
            ),
            _buildModernStatCard(
              context,
              'تذاكر الدعم',
              dashboardStats.totalSupportTickets.toString(),
              Icons.support_agent_outlined,
              [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
              '${dashboardStats.openSupportTickets} مفتوح',
            ),
            if (dashboardStats.totalServiceRequests > 0)
              _buildModernStatCard(
                context,
                'معدل الإنجاز',
                '${(dashboardStats.serviceRequestCompletionRate * 100).toStringAsFixed(1)}%',
                Icons.trending_up_outlined,
                [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
                'التقدم العام',
              ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: _buildQuickStat(
                context,
                'مكتمل',
                dashboardStats.completedServiceRequests.toString(),
                Icons.check_circle_outline,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickStat(
                context,
                'معلق',
                dashboardStats.pendingServiceRequests.toString(),
                Icons.schedule_outlined,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    List<Color> gradientColors,
    String subtitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  icon,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
}