import 'package:flutter/material.dart';
import '../widgets/documents_header.dart';
import '../widgets/document_categories.dart';
import '../widgets/recent_documents.dart';
import '../widgets/document_actions.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh documents data
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header
                const DocumentsHeader(),
                
                const SizedBox(height: 20),
                
                // Document Actions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DocumentActions(),
                ),
                
                const SizedBox(height: 20),
                
                // Document Categories
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: DocumentCategories(),
                ),
                
                const SizedBox(height: 20),
                
                // Recent Documents
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RecentDocuments(),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}