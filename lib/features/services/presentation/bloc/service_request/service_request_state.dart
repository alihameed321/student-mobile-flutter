part of 'service_request_bloc.dart';

abstract class ServiceRequestState extends Equatable {
  const ServiceRequestState();

  @override
  List<Object> get props => [];
}

class ServiceRequestInitial extends ServiceRequestState {}

class ServiceRequestLoading extends ServiceRequestState {}

class ServiceRequestLoaded extends ServiceRequestState {
  final List<ServiceRequest> serviceRequests;

  const ServiceRequestLoaded(this.serviceRequests);

  @override
  List<Object> get props => [serviceRequests];
}

class ServiceRequestDetailLoading extends ServiceRequestState {}

class ServiceRequestDetailLoaded extends ServiceRequestState {
  final ServiceRequest serviceRequest;

  const ServiceRequestDetailLoaded(this.serviceRequest);

  @override
  List<Object> get props => [serviceRequest];
}

class ServiceRequestCreating extends ServiceRequestState {}

class ServiceRequestCreated extends ServiceRequestState {
  final ServiceRequest serviceRequest;

  const ServiceRequestCreated(this.serviceRequest);

  @override
  List<Object> get props => [serviceRequest];
}

class ServiceRequestCanceled extends ServiceRequestState {
  final ServiceRequest serviceRequest;

  const ServiceRequestCanceled(this.serviceRequest);

  @override
  List<Object> get props => [serviceRequest];
}

class ServiceRequestTypesLoaded extends ServiceRequestState {
  final List<String> types;

  const ServiceRequestTypesLoaded(this.types);

  @override
  List<Object> get props => [types];
}

class ServiceRequestError extends ServiceRequestState {
  final String message;

  const ServiceRequestError(this.message);

  @override
  List<Object> get props => [message];
}