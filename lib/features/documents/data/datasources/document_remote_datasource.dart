import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/document_model.dart';

abstract class DocumentRemoteDataSource {
  Future<DocumentListResponseModel> getDocuments({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int pageSize = 20,
  });

  Future<DocumentModel> getDocumentById(int id);

  Future<Uint8List> downloadDocument(int id);

  Future<List<DocumentTypeModel>> getDocumentTypes();

  Future<DocumentStatisticsModel> getDocumentStatistics();

  Future<DocumentStatusModel> getDocumentStatus(int id);

  Future<DocumentListResponseModel> searchDocuments({
    required String query,
    Map<String, dynamic>? queryParams,
    int page = 1,
    int pageSize = 20,
  });

  Future<DocumentSharingInfoModel> getDocumentSharingInfo(int documentId);

  Future<DocumentSharingLinkModel> createSharingLink({
    required int documentId,
    int? expiryHours,
    bool allowDownload = true,
    int? maxDownloads,
    bool requiresAuth = false,
  });

  Future<void> revokeSharingAccess(int documentId);
}

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final DioClient dioClient;

  const DocumentRemoteDataSourceImpl(this.dioClient);

  @override
  Future<DocumentListResponseModel> getDocuments({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
      ...?queryParams,
    };

    final response = await dioClient.get(
      ApiConstants.studentDocumentsEndpoint,
      queryParameters: params,
    );

    if (response.statusCode == 200) {
      return DocumentListResponseModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to fetch documents: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentModel> getDocumentById(int id) async {
    final response = await dioClient.get(
      '${ApiConstants.studentDocumentsEndpoint}$id/',
    );

    if (response.statusCode == 200) {
      return DocumentModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to fetch document: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<Uint8List> downloadDocument(int id) async {
    final response = await dioClient.get(
      ApiConstants.getStudentDocumentDownloadEndpoint(id),
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': 'application/octet-stream'},
      ),
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    } else {
      throw DocumentApiException(
        'Failed to download document: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<List<DocumentTypeModel>> getDocumentTypes() async {
    final response = await dioClient.get(
      ApiConstants.documentTypesEndpoint,
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((item) => DocumentTypeModel.fromJson(item)).toList();
    } else {
      throw DocumentApiException(
        'Failed to fetch document types: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentStatisticsModel> getDocumentStatistics() async {
    final response = await dioClient.get(
      ApiConstants.documentStatisticsEndpoint,
    );

    if (response.statusCode == 200) {
      return DocumentStatisticsModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to fetch document statistics: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentStatusModel> getDocumentStatus(int id) async {
    final response = await dioClient.get(
      ApiConstants.getDocumentStatusEndpoint(id),
    );

    if (response.statusCode == 200) {
      return DocumentStatusModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to fetch document status: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentListResponseModel> searchDocuments({
    required String query,
    Map<String, dynamic>? queryParams,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = {
      'q': query,
      'page': page.toString(),
      'page_size': pageSize.toString(),
      ...?queryParams,
    };

    final response = await dioClient.get(
      ApiConstants.documentSearchEndpoint,
      queryParameters: params,
    );

    if (response.statusCode == 200) {
      return DocumentListResponseModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to search documents: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentSharingInfoModel> getDocumentSharingInfo(int documentId) async {
    final response = await dioClient.get(
      '${ApiConstants.documentSharingEndpoint}?document_id=$documentId',
    );

    if (response.statusCode == 200) {
      return DocumentSharingInfoModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to fetch document sharing info: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<DocumentSharingLinkModel> createSharingLink({
    required int documentId,
    int? expiryHours,
    bool allowDownload = true,
    int? maxDownloads,
    bool requiresAuth = false,
  }) async {
    final body = {
      'document_id': documentId,
      'allow_download': allowDownload,
      'requires_auth': requiresAuth,
      if (expiryHours != null) 'expiry_hours': expiryHours,
      if (maxDownloads != null) 'max_downloads': maxDownloads,
    };

    final response = await dioClient.post(
      ApiConstants.documentSharingEndpoint,
      data: body,
    );

    if (response.statusCode == 201) {
      return DocumentSharingLinkModel.fromJson(response.data);
    } else {
      throw DocumentApiException(
        'Failed to create sharing link: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<void> revokeSharingAccess(int documentId) async {
    final response = await dioClient.delete(
      '${ApiConstants.documentSharingEndpoint}?document_id=$documentId',
    );

    if (response.statusCode != 204) {
      throw DocumentApiException(
        'Failed to revoke sharing access: ${response.statusCode}',
        response.statusCode ?? 0,
      );
    }
  }
}

class DocumentApiException implements Exception {
  final String message;
  final int statusCode;

  const DocumentApiException(this.message, this.statusCode);

  @override
  String toString() => 'DocumentApiException($statusCode): $message';
}