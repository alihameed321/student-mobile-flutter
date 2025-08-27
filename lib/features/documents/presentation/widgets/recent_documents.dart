import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/documents_bloc.dart';
import '../../domain/entities/document_entity.dart';
import '../../../../core/constants/typography.dart';

class RecentDocuments extends StatelessWidget {
  const RecentDocuments({super.key});

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'جميع الوثائق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: AppTypography.semiBold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all documents
                  },
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: AppTypography.medium,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Documents List
          BlocListener<DocumentsBloc, DocumentsState>(
            listener: (context, state) {
              if (state is DocumentSharingInfoLoaded) {
                _showSharingDialog(context, state.sharingInfo);
              } else if (state is DocumentByIdLoaded) {
                _showDocumentDetailsDialog(context, state.document);
              }
            },
            child: BlocBuilder<DocumentsBloc, DocumentsState>(
              builder: (context, state) {
              print(
                  'DEBUG: RecentDocuments - Current state: ${state.runtimeType}');

              if (state is DocumentsLoading) {
                print('DEBUG: RecentDocuments - Showing loading indicator');
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is DocumentsError) {
                print('DEBUG: RecentDocuments - Error state: ${state.message}');
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'فشل في تحميل الوثائق',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is DocumentDownloading) {
                print('DEBUG: RecentDocuments - Document downloading: ${state.documentId}');
                // Show a snackbar or toast for download progress
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('جاري تحميل الوثيقة...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
                // Continue showing the current documents list
                context.read<DocumentsBloc>().add(const LoadDocuments());
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DocumentDownloaded) {
                print('DEBUG: RecentDocuments - Document downloaded: ${state.filePath}');
                // Show success message and reload documents
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم تحميل الوثيقة بنجاح!'),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'موافق',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                });
                // Reload documents to refresh the list
                context.read<DocumentsBloc>().add(const LoadDocuments());
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DocumentsLoaded) {
                print(
                    'DEBUG: RecentDocuments - DocumentsLoaded state with ${state.documents.length} documents');
                final recentDocuments =
                    state.documents; // Show all documents instead of just 5
                print(
                    'DEBUG: RecentDocuments - All documents count: ${recentDocuments.length}');

                if (recentDocuments.isEmpty) {
                  print(
                      'DEBUG: RecentDocuments - No documents, showing empty state');
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'لا توجد وثائق متاحة',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentDocuments.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: Color(0xFFF0F0F0),
                  ),
                  itemBuilder: (context, index) {
                    final document = recentDocuments[index];
                    return _DocumentItem(document: document);
                  },
                );
              }

              if (state is DocumentSharingInfoLoaded || state is DocumentByIdLoaded) {
                // These states are handled by the BlocListener, continue showing current documents
                context.read<DocumentsBloc>().add(const LoadDocuments());
                return const Center(child: CircularProgressIndicator());
              }

              // Handle DocumentsInitial and other states
              print(
                  'DEBUG: RecentDocuments - Unhandled state: ${state.runtimeType}, showing loading');
              return const Center(
                child: CircularProgressIndicator(),
              );            },
            ),
          ),
        ],
      ),
    );  }

  void _showSharingDialog(BuildContext context, dynamic sharingInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('مشاركة الوثيقة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الوثيقة: ${sharingInfo.title}'),
              const SizedBox(height: 8),
              Text('النوع: ${sharingInfo.documentType}'),
              const SizedBox(height: 16),
              if (sharingInfo.sharingCapabilities.canShare)
                const Text('يمكن مشاركة هذه الوثيقة.')
              else
                Text('لا يمكن المشاركة: ${sharingInfo.sharingCapabilities.reason}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
            if (sharingInfo.sharingCapabilities.canShare)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Implement actual sharing functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('وظيفة المشاركة قريباً!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                child: const Text('مشاركة'),
              ),
          ],
        );
      },
    );
  }

  void _showDocumentDetailsDialog(BuildContext context, dynamic document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تفاصيل الوثيقة'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('العنوان: ${document.title}'),
              const SizedBox(height: 8),
              Text('النوع: ${document.documentType}'),
              const SizedBox(height: 8),
              Text('الحجم: ${document.fileSizeFormatted}'),
              const SizedBox(height: 8),
              Text('تاريخ الإصدار: ${_formatDate(document.issuedDate)}'),
              const SizedBox(height: 8),
              Text('الحالة: ${document.statusBadge.text}'),
              const SizedBox(height: 8),
              Text('رسمي: ${document.isOfficial ? "نعم" : "لا"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
            if (document.isDownloadable)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<DocumentsBloc>().add(DownloadDocument(document.id));
                },
                child: const Text('تحميل'),
              ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getRecentDocuments() {
    return [
      {
        'name': 'Fall_2024_Transcript.pdf',
        'type': 'PDF',
        'size': '2.4 MB',
        'lastModified': '2 hours ago',
      },
      {
        'name': 'Tuition_Receipt_Jan2024.pdf',
        'type': 'PDF',
        'size': '1.2 MB',
        'lastModified': '1 day ago',
      },
      {
        'name': 'Course_Registration_Form.docx',
        'type': 'DOCX',
        'size': '856 KB',
        'lastModified': '3 days ago',
      },
      {
        'name': 'Student_ID_Card.jpg',
        'type': 'JPG',
        'size': '1.8 MB',
        'lastModified': '1 week ago',
      },
      {
        'name': 'Financial_Aid_Application.pdf',
        'type': 'PDF',
        'size': '3.1 MB',
        'lastModified': '2 weeks ago',
      },
    ];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'transcript':
      case 'academic_record':
        return const Color(0xFF2B6CB0);
      case 'certificate':
      case 'diploma':
        return const Color(0xFF38A169);
      case 'enrollment':
      case 'registration':
        return const Color(0xFFD69E2E);
      case 'financial':
      case 'fee_statement':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'transcript':
      case 'academic_record':
        return Icons.school;
      case 'certificate':
      case 'diploma':
        return Icons.workspace_premium;
      case 'enrollment':
      case 'registration':
        return Icons.how_to_reg;
      case 'financial':
      case 'fee_statement':
        return Icons.account_balance_wallet;
      default:
        return Icons.description;
    }
  }
}

class _DocumentItem extends StatelessWidget {
  final DocumentEntity document;

  const _DocumentItem({required this.document});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getFileTypeColor(document.documentType).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          _getFileTypeIcon(document.documentType),
          color: _getFileTypeColor(document.documentType),
          size: 20,
        ),
      ),
      title: Text(
        document.title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            document.documentTypeDisplay ?? 'Document',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${document.fileSizeFormatted} • ${_formatDate(document.issuedDate)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Color(int.parse(
                  document.statusBadge.background.replaceFirst('#', '0xff'))),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              document.statusBadge.text,
              style: AppTypography.labelSmallStyle.copyWith(
                fontWeight: AppTypography.medium,
                color: Color(int.parse(
                    document.statusBadge.color.replaceFirst('#', '0xff'))),
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.download,
          color: document.isDownloadable ? const Color(0xFF2B6CB0) : Colors.grey,
          size: 20,
        ),
        onPressed: document.isDownloadable ? () {
          context
              .read<DocumentsBloc>()
              .add(DownloadDocument(document.id));
        } : null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'transcript':
      case 'academic_record':
        return const Color(0xFF2B6CB0);
      case 'certificate':
      case 'diploma':
        return const Color(0xFF38A169);
      case 'enrollment':
      case 'registration':
        return const Color(0xFFD69E2E);
      case 'financial':
      case 'fee_statement':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData _getFileTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'transcript':
      case 'academic_record':
        return Icons.school;
      case 'certificate':
      case 'diploma':
        return Icons.workspace_premium;
      case 'enrollment':
      case 'registration':
        return Icons.how_to_reg;
      case 'financial':
      case 'fee_statement':
        return Icons.account_balance_wallet;
      default:
        return Icons.description;
    }
  }
}

class _DocumentItemLegacy extends StatelessWidget {
  final Map<String, dynamic> document;

  const _DocumentItemLegacy({required this.document});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getFileTypeColorLegacy(document['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getFileTypeIconLegacy(document['type']),
              color: _getFileTypeColorLegacy(document['type']),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getFileTypeColorLegacy(document['type'])
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        document['type'],
                        style: AppTypography.labelSmallStyle.copyWith(
                          fontWeight: AppTypography.medium,
                          color: _getFileTypeColorLegacy(document['type']),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        document['size'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        document['lastModified'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.download,
              color: const Color(0xFF2B6CB0),
              size: 20,
            ),
            onPressed: () {
              // Handle download action for legacy documents
              // Note: Legacy documents don't have the same structure as DocumentEntity
              // This is a placeholder for legacy document download
            },
          ),
        ],
      ),
    );
  }

  Color _getFileTypeColorLegacy(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileTypeIconLegacy(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}
