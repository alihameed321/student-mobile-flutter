import '../entities/document_entity.dart';
import '../entities/document_filter.dart';
import '../repositories/document_repository.dart';

class GetDocumentsUseCase {
  final DocumentRepository repository;

  const GetDocumentsUseCase(this.repository);

  Future<DocumentListResponse> call({
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await repository.getDocuments(
        filter: filter,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw DocumentException('Failed to fetch documents: ${e.toString()}');
    }
  }
}

class GetDocumentByIdUseCase {
  final DocumentRepository repository;

  const GetDocumentByIdUseCase(this.repository);

  Future<DocumentEntity> call(int id) async {
    try {
      return await repository.getDocumentById(id);
    } catch (e) {
      throw DocumentException('Failed to fetch document: ${e.toString()}');
    }
  }
}

class DownloadDocumentUseCase {
  final DocumentRepository repository;

  const DownloadDocumentUseCase(this.repository);

  Future<List<int>> call(int id) async {
    try {
      return await repository.downloadDocument(id);
    } catch (e) {
      throw DocumentException('Failed to download document: ${e.toString()}');
    }
  }
}

class SearchDocumentsUseCase {
  final DocumentRepository repository;

  const SearchDocumentsUseCase(this.repository);

  Future<DocumentListResponse> call({
    required String query,
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.trim().isEmpty) {
      throw DocumentException('Search query cannot be empty');
    }

    try {
      return await repository.searchDocuments(
        query: query.trim(),
        filter: filter,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw DocumentException('Failed to search documents: ${e.toString()}');
    }
  }
}

class DocumentException implements Exception {
  final String message;
  const DocumentException(this.message);

  @override
  String toString() => 'DocumentException: $message';
}