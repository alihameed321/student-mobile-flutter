class RequestDocument {
  final int? id;
  final int requestId;
  final String documentName;
  final String? documentPath;
  final DateTime uploadedAt;
  final int? fileSize;
  final String? mimeType;

  const RequestDocument({
    this.id,
    required this.requestId,
    required this.documentName,
    this.documentPath,
    required this.uploadedAt,
    this.fileSize,
    this.mimeType,
  });

  // Helper getters
  String get fileExtension {
    if (documentName.contains('.')) {
      return documentName.split('.').last.toLowerCase();
    }
    return '';
  }

  String get formattedFileSize {
    if (fileSize == null) return 'Unknown size';
    
    if (fileSize! < 1024) {
      return '${fileSize!} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(fileExtension);
  bool get isDocument => ['doc', 'docx', 'txt', 'rtf'].contains(fileExtension);

  String get documentTypeIcon {
    if (isPdf) return '📄';
    if (isImage) return '🖼️';
    if (isDocument) return '📝';
    return '📎';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RequestDocument &&
        other.id == id &&
        other.requestId == requestId &&
        other.documentName == documentName;
  }

  @override
  int get hashCode {
    return Object.hash(id, requestId, documentName);
  }

  @override
  String toString() {
    return 'RequestDocument(id: $id, requestId: $requestId, documentName: $documentName)';
  }
}