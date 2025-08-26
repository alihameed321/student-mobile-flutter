import 'dart:typed_data';
import '../../domain/entities/document_entity.dart';
import '../../domain/entities/document_filter.dart';
import '../../domain/entities/document_statistics.dart';
import '../../domain/entities/document_status.dart' as entities;
import '../../domain/entities/document_type.dart';
import '../../domain/entities/document_sharing_info.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_datasource.dart';
import '../models/document_model.dart' as models;

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;

  const DocumentRepositoryImpl(this.remoteDataSource);

  @override
  Future<DocumentListResponse> getDocuments({
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = filter?.toQueryParams();
      final response = await remoteDataSource.getDocuments(
        queryParams: queryParams,
        page: page,
        pageSize: pageSize,
      );

      return DocumentListResponse(
        documents: response.results.map(_mapToEntity).toList(),
        totalCount: response.count,
        nextPageUrl: response.next,
        previousPageUrl: response.previous,
        appliedFilters: filter,
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DocumentEntity> getDocumentById(int id) async {
    try {
      final model = await remoteDataSource.getDocumentById(id);
      return _mapToEntity(model);
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<List<int>> downloadDocument(int id) async {
    try {
      final bytes = await remoteDataSource.downloadDocument(id);
      return bytes.toList();
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<List<DocumentType>> getDocumentTypes() async {
    try {
      final models = await remoteDataSource.getDocumentTypes();
      return models.map((model) => DocumentType(
        value: model.value,
        display: model.display,
        description: model.description,
        isActive: model.isActive,
      )).toList();
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DocumentStatistics> getDocumentStatistics() async {
    try {
      final model = await remoteDataSource.getDocumentStatistics();
      print('DEBUG: Repository - Model received: totalDocuments=${model.totalDocuments}, documentsByType=${model.documentsByType.length}');
      
      final statistics = DocumentStatistics(
        totalDocuments: model.totalDocuments,
        officialDocuments: model.officialDocuments,
        totalDownloads: model.totalDownloads,
        recentDocuments: model.recentDocuments.map(_mapToEntity).toList(),
        documentsByType: model.documentsByType.map((typeCount) => 
          DocumentTypeCount(
            type: typeCount.type,
            typeDisplay: typeCount.typeDisplay,
            count: typeCount.count,
          )
        ).toList(),
        mostDownloaded: model.mostDownloaded.map(_mapToEntity).toList(),
      );
      
      print('DEBUG: Repository - Statistics created: totalDocuments=${statistics.totalDocuments}, documentsByType=${statistics.documentsByType.length}');
      return statistics;
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<entities.DocumentStatusEntity> getDocumentStatus(int id) async {
    try {
      final model = await remoteDataSource.getDocumentStatus(id);
      return entities.DocumentStatusEntity(
        documentId: model.documentId,
        title: model.title,
        documentType: model.documentType,
        status: entities.DocumentStatus(
          status: model.status.status,
          statusDisplay: model.status.statusDisplay,
          isAvailable: model.status.isAvailable,
          isProcessing: model.status.isProcessing,
          message: model.status.message,
          progress: model.status.progress,
        ),
        fileInfo: entities.DocumentFileInfo(
          exists: model.fileInfo.exists,
          size: model.fileInfo.size,
          sizeFormatted: model.fileInfo.sizeFormatted,
          mimeType: model.fileInfo.mimeType,
          lastModified: model.fileInfo.lastModified,
          checksum: model.fileInfo.checksum,
        ),
        lastUpdated: model.lastUpdated,
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DocumentListResponse> searchDocuments({
    required String query,
    DocumentFilter? filter,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = filter?.toQueryParams();
      final response = await remoteDataSource.searchDocuments(
        query: query,
        queryParams: queryParams,
        page: page,
        pageSize: pageSize,
      );

      return DocumentListResponse(
        documents: response.results.map(_mapToEntity).toList(),
        totalCount: response.count,
        nextPageUrl: response.next,
        previousPageUrl: response.previous,
        appliedFilters: filter,
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DocumentSharingInfo> getDocumentSharingInfo(int documentId) async {
    try {
      final model = await remoteDataSource.getDocumentSharingInfo(documentId);
      return DocumentSharingInfo(
        documentId: model.documentId,
        title: model.title,
        documentType: model.documentType,
        isOfficial: model.isOfficial,
        issuedDate: model.issuedDate,
        sharingCapabilities: SharingCapabilities(
          canShare: model.sharingCapabilities.canShare,
          canGenerateLink: model.sharingCapabilities.canGenerateLink,
          supportsAccessControl: model.sharingCapabilities.supportsAccessControl,
          reason: model.sharingCapabilities.reason,
        ),
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DocumentSharingLink> createSharingLink({
    required int documentId,
    int? expiryHours,
    bool allowDownload = true,
    int? maxDownloads,
    bool requiresAuth = false,
  }) async {
    try {
      final model = await remoteDataSource.createSharingLink(
        documentId: documentId,
        expiryHours: expiryHours,
        allowDownload: allowDownload,
        maxDownloads: maxDownloads,
        requiresAuth: requiresAuth,
      );

      return DocumentSharingLink(
        documentId: model.documentId,
        sharingToken: model.sharingToken,
        sharingUrl: model.sharingUrl,
        createdAt: model.createdAt,
        expiresAt: model.expiresAt,
        accessSettings: AccessSettings(
          downloadEnabled: model.accessSettings.downloadEnabled,
          viewEnabled: model.accessSettings.viewEnabled,
          maxDownloads: model.accessSettings.maxDownloads,
          requiresAuth: model.accessSettings.requiresAuth,
        ),
      );
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> revokeSharingAccess(int documentId) async {
    try {
      await remoteDataSource.revokeSharingAccess(documentId);
    } catch (e) {
      throw _handleException(e);
    }
  }

  DocumentEntity _mapToEntity(models.DocumentModel model) {
    return DocumentEntity(
      id: model.id,
      title: model.title,
      documentType: model.documentType,
      documentTypeDisplay: model.documentTypeDisplay,
      issuedDate: model.issuedDate,
      issuedDateFormatted: model.issuedDateFormatted,
      isOfficial: model.isOfficial,
      downloadCount: model.downloadCount,
      fileSize: model.fileSize,
      fileSizeFormatted: model.fileSizeFormatted,
      fileExtension: model.fileExtension,
      downloadUrl: model.downloadUrl,
      previewUrl: model.previewUrl,
      isDownloadable: model.isDownloadable,
      statusBadge: StatusBadgeEntity(
        text: model.statusBadge.text,
        color: model.statusBadge.color,
        background: model.statusBadge.background,
      ),
    );
  }

  Exception _handleException(dynamic e) {
    if (e is DocumentApiException) {
      return Exception('API Error (${e.statusCode}): ${e.message}');
    }
    return Exception('Repository Error: ${e.toString()}');
  }
}