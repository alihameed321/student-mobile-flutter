import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/documents_bloc.dart';
import '../../domain/entities/document_filter.dart';

class DocumentSearch extends StatefulWidget {
  const DocumentSearch({super.key});

  @override
  State<DocumentSearch> createState() => _DocumentSearchState();
}

class _DocumentSearchState extends State<DocumentSearch> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      // Clear search and reload documents
      context.read<DocumentsBloc>().add(const LoadDocuments());
      setState(() {
        _isSearchActive = false;
      });
    } else if (query.trim().length >= 2) {
      // Perform search
      context.read<DocumentsBloc>().add(SearchDocuments(
        query: query.trim(),
      ));
      setState(() {
        _isSearchActive = true;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<DocumentsBloc>().add(const LoadDocuments());
    setState(() {
      _isSearchActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'البحث في الوثائق...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
            size: 22,
          ),
          suffixIcon: _isSearchActive
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}