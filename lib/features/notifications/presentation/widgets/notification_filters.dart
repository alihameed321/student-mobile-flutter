import 'package:flutter/material.dart';

class NotificationFilters extends StatefulWidget {
  const NotificationFilters({super.key});

  @override
  State<NotificationFilters> createState() => _NotificationFiltersState();
}

class _NotificationFiltersState extends State<NotificationFilters> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> filters = [
    {'label': 'All', 'icon': Icons.all_inbox, 'color': Colors.blue},
    {'label': 'Academic', 'icon': Icons.school, 'color': Colors.green},
    {'label': 'Financial', 'icon': Icons.account_balance_wallet, 'color': Colors.orange},
    {'label': 'Events', 'icon': Icons.event, 'color': Colors.purple},
    {'label': 'System', 'icon': Icons.settings, 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['label'];
          
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == filters.length - 1 ? 0 : 8,
            ),
            child: _buildFilterChip(
              label: filter['label'],
              icon: filter['icon'],
              color: filter['color'],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedFilter = filter['label'];
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}