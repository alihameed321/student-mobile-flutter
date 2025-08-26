class DocumentStatusEntity {
  final int documentId;
  final String title;
  final String documentType;
  final DocumentStatus status;
  final DocumentFileInfo fileInfo;
  final DateTime lastUpdated;

  const DocumentStatusEntity({
    required this.documentId,
    required this.title,
    required this.documentType,
    required this.status,
    required this.fileInfo,
    required this.lastUpdated,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentStatusEntity &&
        other.documentId == documentId &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(documentId, status);

  @override
  String toString() {
    return 'DocumentStatusEntity(documentId: $documentId, title: $title, status: $status)';
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

  bool get isReady => status == 'ready' && isAvailable;
  bool get isPending => status == 'pending' || isProcessing;
  bool get hasError => status == 'error';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentStatus &&
        other.status == status &&
        other.isAvailable == isAvailable &&
        other.isProcessing == isProcessing;
  }

  @override
  int get hashCode => Object.hash(status, isAvailable, isProcessing);

  @override
  String toString() {
    return 'DocumentStatus(status: $status, statusDisplay: $statusDisplay, isAvailable: $isAvailable)';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentFileInfo &&
        other.exists == exists &&
        other.size == size &&
        other.checksum == checksum;
  }

  @override
  int get hashCode => Object.hash(exists, size, checksum);

  @override
  String toString() {
    return 'DocumentFileInfo(exists: $exists, size: $size, mimeType: $mimeType)';
  }
}