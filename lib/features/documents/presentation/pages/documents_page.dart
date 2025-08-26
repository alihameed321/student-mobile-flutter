import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../bloc/documents_bloc.dart';
import '../widgets/documents_header.dart';
import '../widgets/document_categories.dart';
import '../widgets/recent_documents.dart';
import '../widgets/document_actions.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DocumentsBloc>()
        ..add(const LoadDocuments(refresh: true))
        ..add(const LoadDocumentTypes())
        ..add(const LoadDocumentStatistics()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocBuilder<DocumentsBloc, DocumentsState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DocumentsBloc>().add(const RefreshDocuments());
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
              );
            },
          ),
        ),
      ),
    );
  }
}