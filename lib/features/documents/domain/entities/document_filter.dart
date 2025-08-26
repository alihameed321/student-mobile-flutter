class DocumentFilter {
  final String? documentType;
  final bool? isOfficial;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? minDownloads;
  final int? maxDownloads;
  final String? sortBy;
  final String? sortOrder;
  final String? search;

  const DocumentFilter({
    this.documentType,
    this.isOfficial,
    this.startDate,
    this.endDate,
    this.minDownloads,
    this.maxDownloads,
    this.sortBy,
    this.sortOrder,
    this.search,
  });

  DocumentFilter copyWith({
    String? documentType,
    bool? isOfficial,
    DateTime? startDate,
    DateTime? endDate,
    int? minDownloads,
    int? maxDownloads,
    String? sortBy,
    String? sortOrder,
    String? search,
  }) {
    return DocumentFilter(
      documentType: documentType ?? this.documentType,
      isOfficial: isOfficial ?? this.isOfficial,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minDownloads: minDownloads ?? this.minDownloads,
      maxDownloads: maxDownloads ?? this.maxDownloads,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      search: search ?? this.search,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    
    if (documentType != null) params['document_type'] = documentType;
    if (isOfficial != null) params['is_official'] = isOfficial.toString();
    if (startDate != null) params['start_date'] = startDate!.toIso8601String().split('T')[0];
    if (endDate != null) params['end_date'] = endDate!.toIso8601String().split('T')[0];
    if (minDownloads != null) params['min_downloads'] = minDownloads.toString();
    if (maxDownloads != null) params['max_downloads'] = maxDownloads.toString();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    if (search != null && search!.isNotEmpty) params['search'] = search;
    
    return params;
  }

  bool get hasActiveFilters {
    return documentType != null ||
        isOfficial != null ||
        startDate != null ||
        endDate != null ||
        minDownloads != null ||
        maxDownloads != null ||
        (search != null && search!.isNotEmpty);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentFilter &&
        other.documentType == documentType &&
        other.isOfficial == isOfficial &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.minDownloads == minDownloads &&
        other.maxDownloads == maxDownloads &&
        other.sortBy == sortBy &&
        other.sortOrder == sortOrder &&
        other.search == search;
  }

  @override
  int get hashCode {
    return Object.hash(
      documentType,
      isOfficial,
      startDate,
      endDate,
      minDownloads,
      maxDownloads,
      sortBy,
      sortOrder,
      search,
    );
  }

  @override
  String toString() {
    return 'DocumentFilter(documentType: $documentType, isOfficial: $isOfficial, search: $search)';
  }
}