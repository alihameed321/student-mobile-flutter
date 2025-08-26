class StatusBadge {
  final String text;
  final String color;
  final String background;

  const StatusBadge({
    required this.text,
    required this.color,
    required this.background,
  });

  factory StatusBadge.fromJson(Map<String, dynamic> json) {
    return StatusBadge(
      text: json['text'] as String,
      color: json['color'] as String,
      background: json['background'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'color': color,
      'background': background,
    };
  }
}

class DocumentModel {
  final int id;
  final String title;
  final String documentType;
  final String documentTypeDisplay;
  final DateTime issuedDate;
  final String issuedDateFormatted;
  final bool isOfficial;
  final int downloadCount;
  final int fileSize;
  final String fileSizeFormatted;
  final String? fileExtension;
  final String downloadUrl;
  final String previewUrl;
  final bool isDownloadable;
  final StatusBadge statusBadge;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.documentType,
    required this.documentTypeDisplay,
    required this.issuedDate,
    required this.issuedDateFormatted,
    required this.isOfficial,
    required this.downloadCount,
    required this.fileSize,
    required this.fileSizeFormatted,
    this.fileExtension,
    required this.downloadUrl,
    required this.previewUrl,
    required this.isDownloadable,
    required this.statusBadge,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      documentType: json['document_type'] as String,
      documentTypeDisplay: json['document_type_display'] as String,
      issuedDate: DateTime.parse(json['issued_date'] as String),
      issuedDateFormatted: json['issued_date_formatted'] as String,
      isOfficial: json['is_official'] as bool,
      downloadCount: json['download_count'] as int,
      fileSize: json['file_size'] as int,
      fileSizeFormatted: json['file_size_formatted'] as String,
      fileExtension: json['file_extension'] as String?,
      downloadUrl: json['download_url'] as String,
      previewUrl: json['preview_url'] as String,
      isDownloadable: json['is_downloadable'] as bool,
      statusBadge: StatusBadge.fromJson(json['status_badge'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'document_type': documentType,
      'document_type_display': documentTypeDisplay,
      'issued_date': issuedDate.toIso8601String(),
      'issued_date_formatted': issuedDateFormatted,
      'is_official': isOfficial,
      'download_count': downloadCount,
      'file_size': fileSize,
      'file_size_formatted': fileSizeFormatted,
      'file_extension': fileExtension,
      'download_url': downloadUrl,
      'preview_url': previewUrl,
      'is_downloadable': isDownloadable,
      'status_badge': statusBadge.toJson(),
    };
  }

  DocumentModel copyWith({
    int? id,
    String? title,
    String? documentType,
    String? documentTypeDisplay,
    DateTime? issuedDate,
    String? issuedDateFormatted,
    bool? isOfficial,
    int? downloadCount,
    int? fileSize,
    String? fileSizeFormatted,
    String? fileExtension,
    String? downloadUrl,
    String? previewUrl,
    bool? isDownloadable,
    StatusBadge? statusBadge,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      documentType: documentType ?? this.documentType,
      documentTypeDisplay: documentTypeDisplay ?? this.documentTypeDisplay,
      issuedDate: issuedDate ?? this.issuedDate,
      issuedDateFormatted: issuedDateFormatted ?? this.issuedDateFormatted,
      isOfficial: isOfficial ?? this.isOfficial,
      downloadCount: downloadCount ?? this.downloadCount,
      fileSize: fileSize ?? this.fileSize,
      fileSizeFormatted: fileSizeFormatted ?? this.fileSizeFormatted,
      fileExtension: fileExtension ?? this.fileExtension,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      isDownloadable: isDownloadable ?? this.isDownloadable,
      statusBadge: statusBadge ?? this.statusBadge,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DocumentModel(id: $id, title: $title, documentType: $documentType, isOfficial: $isOfficial)';
  }
}

class DocumentTypeModel {
  final String value;
  final String display;
  final String? description;
  final bool isActive;

  const DocumentTypeModel({
    required this.value,
    required this.display,
    this.description,
    required this.isActive,
  });

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    return DocumentTypeModel(
      value: json['value'] as String,
      display: json['display'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'display': display,
      'description': description,
      'is_active': isActive,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentTypeModel && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

class DocumentStatisticsModel {
  final int totalDocuments;
  final int officialDocuments;
  final int totalDownloads;
  final List<DocumentModel> recentDocuments;
  final List<DocumentTypeCount> documentsByType;
  final List<DocumentModel> mostDownloaded;

  const DocumentStatisticsModel({
    required this.totalDocuments,
    required this.officialDocuments,
    required this.totalDownloads,
    required this.recentDocuments,
    required this.documentsByType,
    required this.mostDownloaded,
  });

  factory DocumentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DocumentStatisticsModel(
      totalDocuments: json['total_documents'] as int,
      officialDocuments: json['official_documents'] as int,
      totalDownloads: json['total_downloads'] as int,
      recentDocuments: (json['recent_documents'] as List)
          .map((doc) => DocumentModel.fromJson(doc as Map<String, dynamic>))
          .toList(),
      documentsByType: (json['documents_by_type'] as List)
          .map((item) => DocumentTypeCount.fromJson(item as Map<String, dynamic>))
          .toList(),
      mostDownloaded: (json['most_downloaded'] as List)
          .map((doc) => DocumentModel.fromJson(doc as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DocumentTypeCount {
  final String type;
  final String typeDisplay;
  final int count;

  const DocumentTypeCount({
    required this.type,
    required this.typeDisplay,
    required this.count,
  });

  factory DocumentTypeCount.fromJson(Map<String, dynamic> json) {
    return DocumentTypeCount(
      type: json['type'] as String,
      typeDisplay: json['type_display'] as String,
      count: json['count'] as int,
    );
  }
}

class DocumentStatusModel {
  final int documentId;
  final String title;
  final String documentType;
  final DateTime issuedDate;
  final bool isOfficial;
  final int downloadCount;
  final DocumentStatus status;
  final DocumentFileInfo fileInfo;
  final DateTime lastUpdated;

  const DocumentStatusModel({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.issuedDate,
    required this.isOfficial,
    required this.downloadCount,
    required this.status,
    required this.fileInfo,
    required this.lastUpdated,
  });

  factory DocumentStatusModel.fromJson(Map<String, dynamic> json) {
    return DocumentStatusModel(
      documentId: json['document_id'] as int,
      title: json['title'] as String,
      documentType: json['document_type'] as String,
      issuedDate: DateTime.parse(json['issued_date'] as String),
      isOfficial: json['is_official'] as bool,
      downloadCount: json['download_count'] as int,
      status: DocumentStatus.fromJson(json['status'] as Map<String, dynamic>),
      fileInfo: DocumentFileInfo.fromJson(json['file_info'] as Map<String, dynamic>),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}

class DocumentStatus {
  final String status;
  final String statusDisplay;
  final bool isAvailable;
  final bool isProcessing;
  final String? message;
  final double? progress;

  const DocumentStatus({
    required this.status,
    required this.statusDisplay,
    required this.isAvailable,
    required this.isProcessing,
    this.message,
    this.progress,
  });

  factory DocumentStatus.fromJson(Map<String, dynamic> json) {
    return DocumentStatus(
      status: json['status'] as String,
      statusDisplay: json['status_display'] as String,
      isAvailable: json['is_available'] as bool,
      isProcessing: json['is_processing'] as bool,
      message: json['message'] as String?,
      progress: (json['progress'] as num?)?.toDouble(),
    );
  }
}

class DocumentFileInfo {
  final bool exists;
  final int? size;
  final String? sizeFormatted;
  final String? mimeType;
  final DateTime? lastModified;
  final String? checksum;

  const DocumentFileInfo({
    required this.exists,
    this.size,
    this.sizeFormatted,
    this.mimeType,
    this.lastModified,
    this.checksum,
  });

  factory DocumentFileInfo.fromJson(Map<String, dynamic> json) {
    return DocumentFileInfo(
      exists: json['exists'] ?? false,
      size: json['size'],
      sizeFormatted: json['size_formatted'],
      mimeType: json['mime_type'],
      lastModified: json['last_modified'] != null
          ? DateTime.parse(json['last_modified'])
          : null,
      checksum: json['checksum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exists': exists,
      'size': size,
      'size_formatted': sizeFormatted,
      'mime_type': mimeType,
      'last_modified': lastModified?.toIso8601String(),
      'checksum': checksum,
    };
  }
}

class DocumentListResponseModel {
  final List<DocumentModel> results;
  final int count;
  final String? next;
  final String? previous;

  const DocumentListResponseModel({
    required this.results,
    required this.count,
    this.next,
    this.previous,
  });

  factory DocumentListResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested results structure from API
    final resultsData = json['results'];
    List<dynamic> documentsList;
    
    if (resultsData is Map<String, dynamic> && resultsData.containsKey('data')) {
      // API returns: {"results": {"success": true, "data": [...]}}
      documentsList = resultsData['data'] as List;
    } else if (resultsData is List) {
      // Direct array format: {"results": [...]}
      documentsList = resultsData;
    } else {
      documentsList = [];
    }
    
    return DocumentListResponseModel(
      results: documentsList
          .map((item) => DocumentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((doc) => doc.toJson()).toList(),
      'count': count,
      'next': next,
      'previous': previous,
    };
  }
}

class DocumentSharingInfoModel {
  final int documentId;
  final String title;
  final String documentType;
  final bool isOfficial;
  final DateTime issuedDate;
  final SharingCapabilitiesModel sharingCapabilities;

  const DocumentSharingInfoModel({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.isOfficial,
    required this.issuedDate,
    required this.sharingCapabilities,
  });

  factory DocumentSharingInfoModel.fromJson(Map<String, dynamic> json) {
    return DocumentSharingInfoModel(
      documentId: json['document_id'],
      title: json['title'],
      documentType: json['document_type'],
      isOfficial: json['is_official'] ?? false,
      issuedDate: DateTime.parse(json['issued_date']),
      sharingCapabilities: SharingCapabilitiesModel.fromJson(json['sharing_capabilities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'title': title,
      'document_type': documentType,
      'is_official': isOfficial,
      'issued_date': issuedDate.toIso8601String(),
      'sharing_capabilities': sharingCapabilities.toJson(),
    };
  }
}

class SharingCapabilitiesModel {
  final bool canShare;
  final bool canGenerateLink;
  final bool supportsAccessControl;
  final String reason;

  const SharingCapabilitiesModel({
    required this.canShare,
    required this.canGenerateLink,
    required this.supportsAccessControl,
    required this.reason,
  });

  factory SharingCapabilitiesModel.fromJson(Map<String, dynamic> json) {
    return SharingCapabilitiesModel(
      canShare: json['can_share'] ?? false,
      canGenerateLink: json['can_generate_link'] ?? false,
      supportsAccessControl: json['supports_access_control'] ?? false,
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_share': canShare,
      'can_generate_link': canGenerateLink,
      'supports_access_control': supportsAccessControl,
      'reason': reason,
    };
  }
}

class DocumentSharingLinkModel {
  final int documentId;
  final String sharingToken;
  final String sharingUrl;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final AccessSettingsModel accessSettings;

  const DocumentSharingLinkModel({
    required this.documentId,
    required this.sharingToken,
    required this.sharingUrl,
    required this.createdAt,
    this.expiresAt,
    required this.accessSettings,
  });

  factory DocumentSharingLinkModel.fromJson(Map<String, dynamic> json) {
    return DocumentSharingLinkModel(
      documentId: json['document_id'],
      sharingToken: json['sharing_token'],
      sharingUrl: json['sharing_url'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      accessSettings: AccessSettingsModel.fromJson(json['access_settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'sharing_token': sharingToken,
      'sharing_url': sharingUrl,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'access_settings': accessSettings.toJson(),
    };
  }
}

class AccessSettingsModel {
  final bool downloadEnabled;
  final bool viewEnabled;
  final int? maxDownloads;
  final bool requiresAuth;

  const AccessSettingsModel({
    required this.downloadEnabled,
    required this.viewEnabled,
    this.maxDownloads,
    required this.requiresAuth,
  });

  factory AccessSettingsModel.fromJson(Map<String, dynamic> json) {
    return AccessSettingsModel(
      downloadEnabled: json['download_enabled'] ?? true,
      viewEnabled: json['view_enabled'] ?? true,
      maxDownloads: json['max_downloads'],
      requiresAuth: json['requires_auth'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'download_enabled': downloadEnabled,
      'view_enabled': viewEnabled,
      'max_downloads': maxDownloads,
      'requires_auth': requiresAuth,
    };
  }
}