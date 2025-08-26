import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../bloc/documents_bloc.dart';
import '../widgets/documents_header.dart';
import '../widgets/document_categories.dart';
import '../widgets/recent_documents.dart';
import '../widgets/document_actions.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      context.read<DocumentsBloc>().add(const LoadDocuments());
    } else if (query.trim().length >= 2) {
      context.read<DocumentsBloc>().add(SearchDocuments(
        query: query.trim(),
      ));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<DocumentsBloc>().add(const LoadDocuments());
    setState(() {
      _showSearch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      DocumentsHeader(
                        onSearchTap: _toggleSearch,
                        isSearchActive: _showSearch,
                        searchController: _searchController,
                        onSearchChanged: _onSearchChanged,
                        onSearchClear: _clearSearch,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Document Actions (hidden when search is active)
                       if (!_showSearch) const Padding(
                         padding: EdgeInsets.symmetric(horizontal: 20),
                         child: DocumentActions(),
                       ),
                       if (!_showSearch) const SizedBox(height: 20),
                       
                       // Document Categories (hidden when search is active)
                       if (!_showSearch) const Padding(
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
      );
  }
}