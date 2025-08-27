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
          int totalDocuments = 0;

          // Get total documents count from statistics
          if (state is DocumentsLoaded && state.statistics != null) {
            totalDocuments = state.statistics!.totalDocuments;
          }

          // Add 'All Documents' option at the top
          categories.add({
            'title': 'جميع الوثائق',
        'subtitle': 'عرض جميع وثائقك',
            'icon': Icons.folder_open,
            'color': Colors.indigo,
            'count': totalDocuments,
            'api_value': null, // null means no filter
          });

          // Use dynamic categories from statistics if available
          if (state is DocumentsLoaded &&
              state.statistics != null &&
              state.statistics!.documentsByType.isNotEmpty) {
            categories.addAll(state.statistics!.documentsByType
                .map((typeCount) => {
                      'title': typeCount.typeDisplay,
                      'subtitle': _getCategorySubtitle(typeCount.typeDisplay),
                      'icon': _getCategoryIcon(typeCount.typeDisplay),
                      'color': _getCategoryColor(typeCount.typeDisplay),
                      'count': typeCount.count,
                      'api_value':
                          typeCount.type, // Use the actual API type value
                    })
                .toList());
          } else if (state is DocumentsLoaded &&
              state.documentTypes.isNotEmpty) {
            // Fallback to document types without counts
            categories.addAll(state.documentTypes
                .map((type) => {
                      'title': type.display,
                      'subtitle': type.description ?? 'فئة الوثائق',
                      'icon': _getCategoryIcon(type.display),
                      'color': _getCategoryColor(type.display),
                      'count': 0,
                      'api_value': type.value,
                    })
                .toList());
          }
          // Removed hardcoded fallback - rely only on server data

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'فئات الوثائق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Horizontal scrollable filter row
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = state is DocumentsLoaded &&
                          ((category['api_value'] == null &&
                                  state.selectedFilters.documentType == null) ||
                              (category['api_value'] != null &&
                                  state.selectedFilters.documentType ==
                                      category['api_value']));

                      return _buildFilterChip(
                        context,
                        title: category['title'],
                        icon: category['icon'],
                        color: category['color'],
                        count: category['count'],
                        isSelected: isSelected,
                        onTap: () {
                          // Handle 'All Documents' option
                          if (category['api_value'] == null) {
                            // Clear all filters to show all documents
                            context.read<DocumentsBloc>().add(
                                  FilterDocuments(
                                    DocumentFilter(
                                      documentType: null,
                                      search: state is DocumentsLoaded
                                          ? state.selectedFilters.search
                                          : null,
                                    ),
                                  ),
                                );
                          } else {
                            // Apply specific document type filter
                            context.read<DocumentsBloc>().add(
                                  FilterDocuments(
                                    DocumentFilter(
                                      documentType: category['api_value'],
                                      search: state is DocumentsLoaded
                                          ? state.selectedFilters.search
                                          : null,
                                    ),
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.2) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? color : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Removed hardcoded categories - now using server data only

  String _getCategorySubtitle(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'enrollment certificate':
        return 'التحقق من قيد الطالب';
      case 'official transcript':
        return 'كشوف الدرجات الأكاديمية';
      case 'graduation certificate':
        return 'شهادات التخرج والإنجاز';
      case 'payment receipt':
        return 'إيصالات الدفع والسجلات المالية';
      case 'other document':
        return 'وثائق متنوعة';
      default:
        return 'وثائق متنوعة';
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'enrollment certificate':
        return Icons.person;
      case 'official transcript':
        return Icons.school;
      case 'graduation certificate':
        return Icons.description;
      case 'payment receipt':
        return Icons.receipt_long;
      case 'other document':
        return Icons.folder;
      default:
        return Icons.folder;
    }
  }

  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'enrollment certificate':
        return Colors.orange;
      case 'official transcript':
        return Colors.blue;
      case 'graduation certificate':
        return Colors.purple;
      case 'payment receipt':
        return Colors.green;
      case 'other document':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getApiDocumentType(String displayName) {
    switch (displayName.toLowerCase()) {
      case 'enrollment certificate':
        return 'enrollment_certificate';
      case 'official transcript':
        return 'transcript';
      case 'graduation certificate':
        return 'graduation_certificate';
      case 'payment receipt':
        return 'payment_receipt';
      case 'other document':
        return 'other';
      default:
        return 'other';
    }
  }
}
