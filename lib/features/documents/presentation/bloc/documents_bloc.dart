import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/entities/document_filter.dart';
import '../../domain/entities/document_statistics.dart';
import '../../domain/entities/document_status.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/document_sharing_info.dart';
import '../../domain/repositories/document_repository.dart';
import '../../domain/usecases/get_documents_usecase.dart';
import '../../domain/usecases/get_document_metadata_usecase.dart';


// Events
abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentsEvent {
  final DocumentFilter? filter;
  final int page;
  final bool refresh;

  const LoadDocuments({
    this.filter,
    this.page = 1,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [filter, page, refresh];
}

class LoadMoreDocuments extends DocumentsEvent {
  const LoadMoreDocuments();
}

class SearchDocuments extends DocumentsEvent {
  final String query;
  final DocumentFilter? filter;

  const SearchDocuments({
    required this.query,
    this.filter,
  });

  @override
  List<Object?> get props => [query, filter];
}

class LoadDocumentTypes extends DocumentsEvent {
  const LoadDocumentTypes();
}

class LoadDocumentStatistics extends DocumentsEvent {
  const LoadDocumentStatistics();
}

class LoadDocumentStatus extends DocumentsEvent {
  final int documentId;

  const LoadDocumentStatus(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class ApplyFilter extends DocumentsEvent {
  final DocumentFilter filter;

  const ApplyFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ClearFilter extends DocumentsEvent {
  const ClearFilter();
}

class DownloadDocument extends DocumentsEvent {
  final int documentId;

  const DownloadDocument(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class RefreshDocuments extends DocumentsEvent {
  const RefreshDocuments();
}

class LoadDocumentById extends DocumentsEvent {
  final int documentId;

  const LoadDocumentById(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class GetDocumentSharingInfo extends DocumentsEvent {
  final int documentId;

  const GetDocumentSharingInfo(this.documentId);

  @override
  List<Object?> get props => [documentId];
}

class FilterDocuments extends DocumentsEvent {
  final DocumentFilter filter;

  const FilterDocuments(this.filter);

  @override
  List<Object?> get props => [filter];
}

// States
abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsLoaded extends DocumentsState {
  final List<DocumentEntity> documents;
  final int totalCount;
  final bool hasReachedMax;
  final DocumentFilter? appliedFilter;
  final bool isLoadingMore;
  final List<DocumentType> documentTypes;
  final DocumentFilter selectedFilters;
  final DocumentStatistics? statistics;

  const DocumentsLoaded({
    required this.documents,
    required this.totalCount,
    required this.hasReachedMax,
    this.appliedFilter,
    this.isLoadingMore = false,
    this.documentTypes = const [],
    this.selectedFilters = const DocumentFilter(),
    this.statistics,
  });

  DocumentsLoaded copyWith({
    List<DocumentEntity>? documents,
    int? totalCount,
    bool? hasReachedMax,
    DocumentFilter? appliedFilter,
    bool? isLoadingMore,
    List<DocumentType>? documentTypes,
    DocumentFilter? selectedFilters,
    DocumentStatistics? statistics,
  }) {
    return DocumentsLoaded(
      documents: documents ?? this.documents,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      appliedFilter: appliedFilter ?? this.appliedFilter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      documentTypes: documentTypes ?? this.documentTypes,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      statistics: statistics ?? this.statistics,
    );
  }

  @override
  List<Object?> get props => [
    documents,
    totalCount,
    hasReachedMax,
    appliedFilter,
    isLoadingMore,
    documentTypes,
    selectedFilters,
    statistics,
  ];
}

class DocumentsError extends DocumentsState {
  final String message;

  const DocumentsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DocumentTypesLoaded extends DocumentsState {
  final List<DocumentType> types;

  const DocumentTypesLoaded(this.types);

  @override
  List<Object?> get props => [types];
}

class DocumentStatisticsLoaded extends DocumentsState {
  final DocumentStatistics statistics;

  const DocumentStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class DocumentStatusLoaded extends DocumentsState {
  final List<DocumentStatusEntity> statusList;

  const DocumentStatusLoaded(this.statusList);

  @override
  List<Object?> get props => [statusList];
}

class DocumentDownloading extends DocumentsState {
  final int documentId;
  final double? progress;

  const DocumentDownloading(this.documentId, {this.progress});

  @override
  List<Object?> get props => [documentId, progress];
}

class DocumentDownloaded extends DocumentsState {
  final int documentId;
  final String filePath;

  const DocumentDownloaded(this.documentId, this.filePath);

  @override
  List<Object?> get props => [documentId, filePath];
}

class DocumentByIdLoaded extends DocumentsState {
  final DocumentEntity document;

  const DocumentByIdLoaded(this.document);

  @override
  List<Object?> get props => [document];
}

class DocumentSharingInfoLoaded extends DocumentsState {
  final DocumentSharingInfo sharingInfo;

  const DocumentSharingInfoLoaded(this.sharingInfo);

  @override
  List<Object?> get props => [sharingInfo];
}

// BLoC
class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final GetDocumentsUseCase getDocumentsUseCase;
  final GetDocumentByIdUseCase getDocumentByIdUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final SearchDocumentsUseCase searchDocumentsUseCase;
  final GetDocumentTypesUseCase getDocumentTypesUseCase;
  final GetDocumentStatisticsUseCase getDocumentStatisticsUseCase;
  final GetDocumentStatusUseCase getDocumentStatusUseCase;

  static const int _pageSize = 20;
  int _currentPage = 1;
  DocumentFilter? _currentFilter;
  String? _currentSearchQuery;

  final GetDocumentSharingInfoUseCase getDocumentSharingInfoUseCase;

  DocumentsBloc({
    required this.getDocumentsUseCase,
    required this.getDocumentByIdUseCase,
    required this.downloadDocumentUseCase,
    required this.searchDocumentsUseCase,
    required this.getDocumentTypesUseCase,
    required this.getDocumentStatisticsUseCase,
    required this.getDocumentStatusUseCase,
    required this.getDocumentSharingInfoUseCase,
  }) : super(const DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<LoadMoreDocuments>(_onLoadMoreDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<LoadDocumentTypes>(_onLoadDocumentTypes);
    on<LoadDocumentStatistics>(_onLoadDocumentStatistics);
    on<LoadDocumentStatus>(_onLoadDocumentStatus);
    on<ApplyFilter>(_onApplyFilter);
    on<ClearFilter>(_onClearFilter);
    on<DownloadDocument>(_onDownloadDocument);
    on<RefreshDocuments>(_onRefreshDocuments);
    on<LoadDocumentById>(_onLoadDocumentById);
    on<GetDocumentSharingInfo>(_onGetDocumentSharingInfo);
    on<FilterDocuments>(_onFilterDocuments);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      print('DEBUG: LoadDocuments event - refresh: ${event.refresh}, page: ${event.page}, filter: ${event.filter}');
      
      if (event.refresh || state is! DocumentsLoaded) {
        emit(const DocumentsLoading());
      }

      _currentPage = event.page;
      _currentFilter = event.filter;
      _currentSearchQuery = null;

      print('DEBUG: Calling getDocumentsUseCase with filter: ${event.filter}');
      final response = await getDocumentsUseCase(
        filter: event.filter,
        page: event.page,
        pageSize: _pageSize,
      );

      print('DEBUG: API Response - documents count: ${response.documents.length}, totalCount: ${response.totalCount}');
      for (int i = 0; i < response.documents.length; i++) {
        final doc = response.documents[i];
        print('DEBUG: Document $i - ID: ${doc.id}, Title: ${doc.title}, Type: ${doc.documentType}');
      }

      // Preserve existing documentTypes and statistics from current state
      final currentState = state;
      List<DocumentType> documentTypes = [];
      DocumentStatistics? statistics;
      
      if (currentState is DocumentsLoaded) {
        documentTypes = currentState.documentTypes;
        statistics = currentState.statistics;
      }

      print('DEBUG: Emitting DocumentsLoaded state with ${response.documents.length} documents');
      emit(DocumentsLoaded(
        documents: response.documents,
        totalCount: response.totalCount,
        hasReachedMax: response.documents.length < _pageSize,
        appliedFilter: event.filter,
        documentTypes: documentTypes,
        statistics: statistics,
      ));
    } catch (e) {
      print('DEBUG: Error in _onLoadDocuments: $e');
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreDocuments(
    LoadMoreDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DocumentsLoaded || currentState.hasReachedMax) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = _currentPage + 1;
      
      DocumentListResponse response;
      if (_currentSearchQuery != null) {
        response = await searchDocumentsUseCase(
          query: _currentSearchQuery!,
          filter: _currentFilter,
          page: nextPage,
          pageSize: _pageSize,
        );
      } else {
        response = await getDocumentsUseCase(
          filter: _currentFilter,
          page: nextPage,
          pageSize: _pageSize,
        );
      }

      _currentPage = nextPage;
      final allDocuments = [...currentState.documents, ...response.documents];

      emit(currentState.copyWith(
        documents: allDocuments,
        totalCount: response.totalCount,
        hasReachedMax: response.documents.length < _pageSize,
        appliedFilter: _currentFilter,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      emit(const DocumentsLoading());

      _currentPage = 1;
      _currentFilter = event.filter;
      _currentSearchQuery = event.query;

      final response = await searchDocumentsUseCase(
        query: event.query,
        filter: event.filter,
        page: 1,
        pageSize: _pageSize,
      );

      // Preserve existing documentTypes and statistics from current state
      final currentState = state;
      List<DocumentType> documentTypes = [];
      DocumentStatistics? statistics;
      
      if (currentState is DocumentsLoaded) {
        documentTypes = currentState.documentTypes;
        statistics = currentState.statistics;
      }

      emit(DocumentsLoaded(
        documents: response.documents,
        totalCount: response.totalCount,
        hasReachedMax: response.documents.length < _pageSize,
        appliedFilter: event.filter,
        documentTypes: documentTypes,
        statistics: statistics,
      ));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadDocumentTypes(
    LoadDocumentTypes event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final types = await getDocumentTypesUseCase();
      
      final currentState = state;
      if (currentState is DocumentsLoaded) {
        emit(currentState.copyWith(documentTypes: types));
      } else {
        emit(DocumentTypesLoaded(types));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadDocumentStatistics(
    LoadDocumentStatistics event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final statistics = await getDocumentStatisticsUseCase();
      
      final currentState = state;
      if (currentState is DocumentsLoaded) {
        emit(currentState.copyWith(statistics: statistics));
      } else {
        emit(DocumentStatisticsLoaded(statistics));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onLoadDocumentStatus(
    LoadDocumentStatus event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final status = await getDocumentStatusUseCase(event.documentId);
      emit(DocumentStatusLoaded([status]));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onApplyFilter(
    ApplyFilter event,
    Emitter<DocumentsState> emit,
  ) async {
    add(LoadDocuments(filter: event.filter, refresh: true));
  }

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<DocumentsState> emit,
  ) async {
    add(const LoadDocuments(refresh: true));
  }

  Future<void> _onDownloadDocument(
    DownloadDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      emit(DocumentDownloading(event.documentId));
      
      final bytes = await downloadDocumentUseCase(event.documentId);
      
      // Here you would typically save the file to device storage
      // For now, we'll just emit success with a placeholder path
      final filePath = '/downloads/document_${event.documentId}.pdf';
      
      emit(DocumentDownloaded(event.documentId, filePath));
    } catch (e) {
      emit(DocumentsError('Failed to download document: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshDocuments(
    RefreshDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    if (_currentSearchQuery != null) {
      add(SearchDocuments(
        query: _currentSearchQuery!,
        filter: _currentFilter,
      ));
    } else {
      add(LoadDocuments(
        filter: _currentFilter,
        refresh: true,
      ));
    }
  }

  Future<void> _onLoadDocumentById(
    LoadDocumentById event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final document = await getDocumentByIdUseCase(event.documentId);
      emit(DocumentByIdLoaded(document));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onGetDocumentSharingInfo(
    GetDocumentSharingInfo event,
    Emitter<DocumentsState> emit,
  ) async {
    try {
      final sharingInfo = await getDocumentSharingInfoUseCase(event.documentId);
      emit(DocumentSharingInfoLoaded(sharingInfo));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onFilterDocuments(
    FilterDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    final currentState = state;
    if (currentState is DocumentsLoaded) {
      emit(currentState.copyWith(selectedFilters: event.filter));
      add(LoadDocuments(filter: event.filter, refresh: true));
    } else {
      add(LoadDocuments(filter: event.filter, refresh: true));
    }
  }
}