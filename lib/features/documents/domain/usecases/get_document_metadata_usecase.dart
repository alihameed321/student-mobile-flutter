import '../entities/document_type.dart';
import '../entities/document_statistics.dart';
import '../entities/document_status.dart';
import '../entities/document_sharing_info.dart';
import '../repositories/document_repository.dart';
import 'get_documents_usecase.dart';

class GetDocumentTypesUseCase {
  final DocumentRepository repository;

  const GetDocumentTypesUseCase(this.repository);

  Future<List<DocumentType>> call() async {
    try {
      return await repository.getDocumentTypes();
    } catch (e) {
      throw DocumentException('Failed to fetch document types: ${e.toString()}');
    }
  }
}

class GetDocumentStatisticsUseCase {
  final DocumentRepository repository;

  const GetDocumentStatisticsUseCase(this.repository);

  Future<DocumentStatistics> call() async {
    try {
      return await repository.getDocumentStatistics();
    } catch (e) {
      throw DocumentException('Failed to fetch document statistics: ${e.toString()}');
    }
  }
}

class GetDocumentStatusUseCase {
  final DocumentRepository repository;

  const GetDocumentStatusUseCase(this.repository);

  Future<DocumentStatusEntity> call(int id) async {
    try {
      return await repository.getDocumentStatus(id);
    } catch (e) {
      throw DocumentException('Failed to fetch document status: ${e.toString()}');
    }
  }
}

class GetDocumentSharingInfoUseCase {
  final DocumentRepository repository;

  const GetDocumentSharingInfoUseCase(this.repository);

  Future<DocumentSharingInfo> call(int documentId) async {
    try {
      return await repository.getDocumentSharingInfo(documentId);
    } catch (e) {
      throw DocumentException('Failed to fetch document sharing info: ${e.toString()}');
    }
  }
}

class CreateSharingLinkUseCase {
  final DocumentRepository repository;

  const CreateSharingLinkUseCase(this.repository);

  Future<DocumentSharingLink> call({
    required int documentId,
    int? expiryHours,
    bool allowDownload = true,
    int? maxDownloads,
    bool requiresAuth = false,
  }) async {
    try {
      return await repository.createSharingLink(
        documentId: documentId,
        expiryHours: expiryHours,
        allowDownload: allowDownload,
        maxDownloads: maxDownloads,
        requiresAuth: requiresAuth,
      );
    } catch (e) {
      throw DocumentException('Failed to create sharing link: ${e.toString()}');
    }
  }
}

class RevokeSharingAccessUseCase {
  final DocumentRepository repository;

  const RevokeSharingAccessUseCase(this.repository);

  Future<void> call(int documentId) async {
    try {
      await repository.revokeSharingAccess(documentId);
    } catch (e) {
      throw DocumentException('Failed to revoke sharing access: ${e.toString()}');
    }
  }
}