import 'package:flutter/material.dart';

class DocumentCategories extends StatelessWidget {
  const DocumentCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Document Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          _buildCategoryItem(
            context,
            title: 'Academic Records',
            subtitle: 'Transcripts, grades, certificates',
            icon: Icons.school,
            color: Colors.blue,
            count: 12,
            onTap: () {},
          ),
          _buildDivider(),
          _buildCategoryItem(
            context,
            title: 'Financial Documents',
            subtitle: 'Receipts, invoices, financial aid',
            icon: Icons.receipt_long,
            color: Colors.green,
            count: 8,
            onTap: () {},
          ),
          _buildDivider(),
          _buildCategoryItem(
            context,
            title: 'Personal Documents',
            subtitle: 'ID, passport, personal info',
            icon: Icons.person,
            color: Colors.orange,
            count: 5,
            onTap: () {},
          ),
          _buildDivider(),
          _buildCategoryItem(
            context,
            title: 'Application Forms',
            subtitle: 'Applications, requests, forms',
            icon: Icons.description,
            color: Colors.purple,
            count: 3,
            onTap: () {},
          ),
          _buildDivider(),
          _buildCategoryItem(
            context,
            title: 'Health Records',
            subtitle: 'Medical records, immunizations',
            icon: Icons.local_hospital,
            color: Colors.red,
            count: 4,
            onTap: () {},
          ),
          _buildDivider(),
          _buildCategoryItem(
            context,
            title: 'Other Documents',
            subtitle: 'Miscellaneous files',
            icon: Icons.folder,
            color: Colors.grey,
            count: 7,
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
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
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
      indent: 68,
      endIndent: 20,
    );
  }
}