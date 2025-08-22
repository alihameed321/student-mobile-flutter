import 'package:flutter/material.dart';

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
          childAspectRatio: 1.1,
          children: [
            _buildServiceCard(
              context,
              title: 'Academic Advising',
              icon: Icons.school_outlined,
              color: Colors.blue,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Student Health',
              icon: Icons.local_hospital_outlined,
              color: Colors.red,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'IT Support',
              icon: Icons.computer_outlined,
              color: Colors.green,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Campus Housing',
              icon: Icons.home_outlined,
              color: Colors.orange,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Transportation',
              icon: Icons.directions_bus_outlined,
              color: Colors.purple,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Dining Services',
              icon: Icons.restaurant_outlined,
              color: Colors.teal,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Recreation Center',
              icon: Icons.fitness_center_outlined,
              color: Colors.indigo,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Student Activities',
              icon: Icons.celebration_outlined,
              color: Colors.pink,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Counseling Services',
              icon: Icons.psychology_outlined,
              color: Colors.cyan,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'International Office',
              icon: Icons.public_outlined,
              color: Colors.amber,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Disability Services',
              icon: Icons.accessibility_outlined,
              color: Colors.deepOrange,
              onTap: () {},
            ),
            _buildServiceCard(
              context,
              title: 'Alumni Relations',
              icon: Icons.groups_outlined,
              color: Colors.brown,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}