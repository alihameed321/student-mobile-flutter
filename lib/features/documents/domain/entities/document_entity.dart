class StatusBadgeEntity {
  final String text;
  final String color;
  final String background;

  const StatusBadgeEntity({
    required this.text,
    required this.color,
    required this.background,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatusBadgeEntity &&
        other.text == text &&
        other.color == color &&
        other.background == background;
  }

  @override
  int get hashCode => Object.hash(text, color, background);

  @override
  String toString() {
    return 'StatusBadgeEntity(text: $text, color: $color, background: $background)';
  }
}

class DocumentEntity {
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
  final StatusBadgeEntity statusBadge;

  const DocumentEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DocumentEntity(id: $id, title: $title, documentType: $documentType, isOfficial: $isOfficial)';
  }
}