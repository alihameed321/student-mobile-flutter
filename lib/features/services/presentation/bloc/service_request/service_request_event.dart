part of 'service_request_bloc.dart';

abstract class ServiceRequestEvent extends Equatable {
  const ServiceRequestEvent();

  @override
  List<Object?> get props => [];
}

class LoadServiceRequests extends ServiceRequestEvent {
  final String? status;
  final String? requestType;
  final String? search;
  final int? page;
  final bool isRefresh;

  const LoadServiceRequests({
    this.status,
    this.requestType,
    this.search,
    this.page,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [status, requestType, search, page, isRefresh];
}

class LoadServiceRequestDetail extends ServiceRequestEvent {
  final int id;

  const LoadServiceRequestDetail(this.id);

  @override
  List<Object> get props => [id];
}

class CreateServiceRequestEvent extends ServiceRequestEvent {
  final String requestType;
  final String description;
  final String? priority;

  const CreateServiceRequestEvent({
    required this.requestType,
    required this.description,
    this.priority,
  });

  @override
  List<Object?> get props => [requestType, description, priority];
}

class CancelServiceRequestEvent extends ServiceRequestEvent {
  final int id;

  const CancelServiceRequestEvent(this.id);

  @override
  List<Object> get props => [id];
}

class LoadServiceRequestTypes extends ServiceRequestEvent {
  const LoadServiceRequestTypes();
}

class RefreshServiceRequests extends ServiceRequestEvent {
  const RefreshServiceRequests();
}