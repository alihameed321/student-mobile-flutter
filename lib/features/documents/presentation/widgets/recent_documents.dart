import 'package:flutter/material.dart';

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
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Documents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all documents
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          _buildDocumentItem(
            context,
            fileName: 'Fall_2024_Transcript.pdf',
            fileType: 'PDF',
            fileSize: '2.4 MB',
            lastModified: '2 hours ago',
            icon: Icons.picture_as_pdf,
            color: Colors.red,
          ),
          _buildDivider(),
          _buildDocumentItem(
            context,
            fileName: 'Tuition_Receipt_Jan2024.pdf',
            fileType: 'PDF',
            fileSize: '1.2 MB',
            lastModified: '1 day ago',
            icon: Icons.receipt,
            color: Colors.green,
          ),
          _buildDivider(),
          _buildDocumentItem(
            context,
            fileName: 'Course_Registration_Form.docx',
            fileType: 'DOCX',
            fileSize: '856 KB',
            lastModified: '3 days ago',
            icon: Icons.description,
            color: Colors.blue,
          ),
          _buildDivider(),
          _buildDocumentItem(
            context,
            fileName: 'Student_ID_Card.jpg',
            fileType: 'JPG',
            fileSize: '1.8 MB',
            lastModified: '1 week ago',
            icon: Icons.image,
            color: Colors.orange,
          ),
          _buildDivider(),
          _buildDocumentItem(
            context,
            fileName: 'Financial_Aid_Application.pdf',
            fileType: 'PDF',
            fileSize: '3.1 MB',
            lastModified: '2 weeks ago',
            icon: Icons.account_balance,
            color: Colors.purple,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(
    BuildContext context, {
    required String fileName,
    required String fileType,
    required String fileSize,
    required String lastModified,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  fileName,
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
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        fileType,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        fileSize,
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
                        lastModified,
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
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu selection
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 8),
                    Text('Download'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 18),
                    SizedBox(width: 8),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Icon(
              Icons.more_vert,
              color: Colors.grey[400],
            ),
          ),
        ],
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