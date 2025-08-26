import '../entities/document_entity.dart';
import '../entities/document_filter.dart';
import '../entities/document_statistics.dart';
import '../entities/document_status.dart';
import '../entities/document_type.dart';
import '../entities/document_sharing_info.dart';
import '../../data/models/document_model.dart';

abstract class DocumentRepository {
  /// Get paginated list of documents with optional filtering and sorting
  Future<DocumentListResponse> getDocuments({
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  /// Get document details by ID
  Future<DocumentEntity> getDocumentById(int id);

  /// Download document file
  Future<List<int>> downloadDocument(int id);

  /// Get available document types for filtering
  Future<List<DocumentType>> getDocumentTypes();

  /// Get document statistics for dashboard
  Future<DocumentStatistics> getDocumentStatistics();

  /// Get document status information
  Future<DocumentStatusEntity> getDocumentStatus(int id);

  /// Search documents with advanced criteria
  Future<DocumentListResponse> searchDocuments({
    required String query,
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  });

  /// Get document sharing information
  Future<DocumentSharingInfo> getDocumentSharingInfo(int documentId);

  /// Create document sharing link
  Future<DocumentSharingLink> createSharingLink({
    required int documentId,
    int? expiryHours,
    bool allowDownload = true,
    int? maxDownloads,
    bool requiresAuth = false,
  });

  /// Revoke document sharing access
  Future<void> revokeSharingAccess(int documentId);
}

class DocumentListResponse {
  final List<DocumentEntity> documents;
  final int totalCount;
  final String? nextPageUrl;
  final String? previousPageUrl;
  final DocumentFilter? appliedFilters;

  const DocumentListResponse({
    required this.documents,
    required this.totalCount,
    this.nextPageUrl,
    this.previousPageUrl,
    this.appliedFilters,
  });
}