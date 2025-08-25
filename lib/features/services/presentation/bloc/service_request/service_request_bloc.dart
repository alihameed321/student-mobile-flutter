import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/service_request.dart';
import '../../../domain/usecases/get_service_requests.dart';

part 'service_request_event.dart';
part 'service_request_state.dart';

class ServiceRequestBloc extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  final GetServiceRequests getServiceRequests;
  final GetServiceRequestDetail getServiceRequestDetail;
  final CreateServiceRequest createServiceRequest;
  final CancelServiceRequest cancelServiceRequest;
  final GetServiceRequestTypes getServiceRequestTypes;

  ServiceRequestBloc({
    required this.getServiceRequests,
    required this.getServiceRequestDetail,
    required this.createServiceRequest,
    required this.cancelServiceRequest,
    required this.getServiceRequestTypes,
  }) : super(ServiceRequestInitial()) {
    on<LoadServiceRequests>(_onLoadServiceRequests);
    on<LoadServiceRequestDetail>(_onLoadServiceRequestDetail);
    on<CreateServiceRequestEvent>(_onCreateServiceRequest);
    on<CancelServiceRequestEvent>(_onCancelServiceRequest);
    on<LoadServiceRequestTypes>(_onLoadServiceRequestTypes);
    on<RefreshServiceRequests>(_onRefreshServiceRequests);
  }

  Future<void> _onLoadServiceRequests(
    LoadServiceRequests event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      if (state is! ServiceRequestLoaded || event.isRefresh) {
        emit(ServiceRequestLoading());
      }

      final serviceRequests = await getServiceRequests(
        status: event.status,
        requestType: event.requestType,
        search: event.search,
        page: event.page,
      );

      emit(ServiceRequestLoaded(serviceRequests));
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }

  Future<void> _onLoadServiceRequestDetail(
    LoadServiceRequestDetail event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      emit(ServiceRequestDetailLoading());
      final serviceRequest = await getServiceRequestDetail(event.id);
      emit(ServiceRequestDetailLoaded(serviceRequest));
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }

  Future<void> _onCreateServiceRequest(
    CreateServiceRequestEvent event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      emit(ServiceRequestCreating());
      final serviceRequest = await createServiceRequest(
        requestType: event.requestType,
        description: event.description,
        priority: event.priority,
      );
      emit(ServiceRequestCreated(serviceRequest));
      
      // Refresh the list
      add(const RefreshServiceRequests());
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }

  Future<void> _onCancelServiceRequest(
    CancelServiceRequestEvent event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      final serviceRequest = await cancelServiceRequest(event.id);
      emit(ServiceRequestCanceled(serviceRequest));
      
      // Refresh the list
      add(const RefreshServiceRequests());
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }

  Future<void> _onLoadServiceRequestTypes(
    LoadServiceRequestTypes event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      final types = await getServiceRequestTypes();
      emit(ServiceRequestTypesLoaded(types));
    } catch (e) {
      emit(ServiceRequestError(e.toString()));
    }
  }

  Future<void> _onRefreshServiceRequests(
    RefreshServiceRequests event,
    Emitter<ServiceRequestState> emit,
  ) async {
    add(const LoadServiceRequests(isRefresh: true));
  }
}