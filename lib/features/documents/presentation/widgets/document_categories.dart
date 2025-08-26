import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/documents_bloc.dart';
import '../../domain/entities/document_filter.dart';

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
      child: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          List<Map<String, dynamic>> categories = [];
          
          // Add 'All Documents' option at the top
          categories.add({
            'title': 'All Documents',
            'subtitle': 'View all your documents',
            'icon': Icons.folder_open,
            'color': Colors.indigo,
            'count': 0,
            'api_value': null, // null means no filter
          });
          
          if (state is DocumentsLoaded && state.documentTypes.isNotEmpty) {
            categories.addAll(state.documentTypes.map((type) => {
              'title': type.display,
              'subtitle': _getCategorySubtitle(type.display),
              'icon': _getCategoryIcon(type.display),
              'color': _getCategoryColor(type.display),
              'count': 0, // DocumentType doesn't have count, will need to get from DocumentTypeCount
              'api_value': type.value, // Store the actual API value
            }).toList());
          } else {
            // Fallback to server-compatible categories
            categories.addAll(_getServerCompatibleCategories());
          }
          
          return Column(
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
              ...categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return Column(
                  children: [
                    _buildCategoryItem(
                      context,
                      title: category['title'],
                      subtitle: category['subtitle'],
                      icon: category['icon'],
                      color: category['color'],
                      count: category['count'],
                      onTap: () {
                        // Handle 'All Documents' option
                        if (category['api_value'] == null) {
                          print('DEBUG: All Documents tapped - clearing filters');
                          context.read<DocumentsBloc>().add(
                            const LoadDocuments(refresh: true),
                          );
                          return;
                        }
                        
                        // Use the API value from server if available, otherwise fallback to mapping
                        final apiValue = category['api_value'] ?? _getApiDocumentType(category['title']);
                        final currentFilters = state is DocumentsLoaded 
                            ? state.selectedFilters 
                            : const DocumentFilter();
                        
                        print('DEBUG: Category tapped: ${category['title']}, API value: $apiValue');
                        
                        final newFilters = currentFilters.copyWith(
                          documentType: apiValue,
                        );
                        
                        context.read<DocumentsBloc>().add(
                          FilterDocuments(newFilters),
                        );
                      },
                    ),
                    if (index < categories.length - 1) _buildDivider(),
                  ],
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          );
        },
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

  List<Map<String, dynamic>> _getServerCompatibleCategories() {
    return [
      {
        'title': 'Academic Records',
        'subtitle': 'Transcripts, grades, certificates',
        'icon': Icons.school,
        'color': Colors.blue,
        'count': 0,
        'api_value': 'transcript',
      },
      {
        'title': 'Financial Documents',
        'subtitle': 'Receipts, invoices, financial aid',
        'icon': Icons.receipt_long,
        'color': Colors.green,
        'count': 0,
        'api_value': 'payment_receipt',
      },
      {
        'title': 'Personal Documents',
        'subtitle': 'ID, passport, personal info',
        'icon': Icons.person,
        'color': Colors.orange,
        'count': 0,
        'api_value': 'enrollment_certificate',
      },
      {
        'title': 'Application Forms',
        'subtitle': 'Applications, requests, forms',
        'icon': Icons.description,
        'color': Colors.purple,
        'count': 0,
        'api_value': 'graduation_certificate',
      },
      {
        'title': 'Other Documents',
        'subtitle': 'Miscellaneous files',
        'icon': Icons.folder,
        'color': Colors.grey,
        'count': 0,
        'api_value': 'other',
      },
    ];
  }

  String _getCategorySubtitle(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'official transcript':
        return 'Transcripts, grades, certificates';
      case 'financial documents':
      case 'payment receipt':
        return 'Receipts, invoices, financial aid';
      case 'personal documents':
      case 'enrollment certificate':
        return 'ID, passport, personal info';
      case 'application forms':
      case 'graduation certificate':
        return 'Applications, requests, forms';
      case 'other document':
        return 'Miscellaneous files';
      default:
        return 'Miscellaneous files';
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'official transcript':
        return Icons.school;
      case 'financial documents':
      case 'payment receipt':
        return Icons.receipt_long;
      case 'personal documents':
      case 'enrollment certificate':
        return Icons.person;
      case 'application forms':
      case 'graduation certificate':
        return Icons.description;
      case 'other document':
        return Icons.folder;
      default:
        return Icons.folder;
    }
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'official transcript':
        return Colors.blue;
      case 'financial documents':
      case 'payment receipt':
        return Colors.green;
      case 'personal documents':
      case 'enrollment certificate':
        return Colors.orange;
      case 'application forms':
      case 'graduation certificate':
        return Colors.purple;
      case 'other document':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getApiDocumentType(String displayName) {
    switch (displayName.toLowerCase()) {
      case 'official transcript':
        return 'transcript';
      case 'financial documents':
      case 'payment receipt':
        return 'payment_receipt';
      case 'personal documents':
      case 'enrollment certificate':
        return 'enrollment_certificate';
      case 'application forms':
      case 'graduation certificate':
        return 'graduation_certificate';
      case 'other documents':
      case 'other document':
        return 'other';
      default:
        return 'other';
    }
  }
}