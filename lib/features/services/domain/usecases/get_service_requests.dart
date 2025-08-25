import '../entities/service_request.dart';
import '../repositories/student_portal_repository.dart';

class GetServiceRequests {
  final StudentPortalRepository repository;

  GetServiceRequests(this.repository);

  Future<List<ServiceRequest>> call({
    String? status,
    String? requestType,
    String? search,
    int? page,
  }) async {
    return await repository.getServiceRequests(
      status: status,
      requestType: requestType,
      search: search,
      page: page,
    );
  }
}

class GetServiceRequestDetail {
  final StudentPortalRepository repository;

  GetServiceRequestDetail(this.repository);

  Future<ServiceRequest> call(int id) async {
    return await repository.getServiceRequestDetail(id);
  }
}

class CreateServiceRequest {
  final StudentPortalRepository repository;

  CreateServiceRequest(this.repository);

  Future<ServiceRequest> call({
    required String requestType,
    required String description,
    String? priority,
  }) async {
    if (requestType.trim().isEmpty) {
      throw Exception('Request type cannot be empty');
    }
    if (description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }
    if (description.length < 10) {
      throw Exception('Description must be at least 10 characters long');
    }
    if (description.length > 1000) {
      throw Exception('Description cannot exceed 1000 characters');
    }

    return await repository.createServiceRequest(
      requestType: requestType.trim(),
      description: description.trim(),
      priority: priority?.trim(),
    );
  }
}

class CancelServiceRequest {
  final StudentPortalRepository repository;

  CancelServiceRequest(this.repository);

  Future<ServiceRequest> call(int id) async {
    return await repository.cancelServiceRequest(id);
  }
}

class GetServiceRequestTypes {
  final StudentPortalRepository repository;

  GetServiceRequestTypes(this.repository);

  Future<List<String>> call() async {
    return await repository.getServiceRequestTypes();
  }
}