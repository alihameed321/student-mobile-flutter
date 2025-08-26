import 'document_entity.dart';

class DocumentStatistics {
  final int totalDocuments;
  final int officialDocuments;
  final int totalDownloads;
  final List<DocumentEntity> recentDocuments;
  final List<DocumentTypeCount> documentsByType;
  final List<DocumentEntity> mostDownloaded;

  const DocumentStatistics({
    required this.totalDocuments,
    required this.officialDocuments,
    required this.totalDownloads,
    required this.recentDocuments,
    required this.documentsByType,
    required this.mostDownloaded,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentStatistics &&
        other.totalDocuments == totalDocuments &&
        other.officialDocuments == officialDocuments &&
        other.totalDownloads == totalDownloads;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalDocuments,
      officialDocuments,
      totalDownloads,
    );
  }

  @override
  String toString() {
    return 'DocumentStatistics(totalDocuments: $totalDocuments, officialDocuments: $officialDocuments, totalDownloads: $totalDownloads)';
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentTypeCount &&
        other.type == type &&
        other.count == count;
  }

  @override
  int get hashCode => Object.hash(type, count);

  @override
  String toString() {
    return 'DocumentTypeCount(type: $type, typeDisplay: $typeDisplay, count: $count)';
  }
}