import '../entities/support_ticket.dart';
import '../repositories/student_portal_repository.dart';

class GetSupportTickets {
  final StudentPortalRepository repository;

  GetSupportTickets(this.repository);

  Future<List<SupportTicket>> call({
    String? category,
    String? status,
    String? priority,
    String? search,
    int? page,
  }) async {
    return await repository.getSupportTickets(
      category: category,
      status: status,
      priority: priority,
      search: search,
      page: page,
    );
  }
}

class GetSupportTicketDetail {
  final StudentPortalRepository repository;

  GetSupportTicketDetail(this.repository);

  Future<SupportTicket> call(int id) async {
    return await repository.getSupportTicketDetail(id);
  }
}

class CreateSupportTicket {
  final StudentPortalRepository repository;

  CreateSupportTicket(this.repository);

  Future<SupportTicket> call({
    required String subject,
    required String description,
    required String category,
    required String priority,
  }) async {
    // Validation
    if (subject.trim().isEmpty) {
      throw Exception('Subject cannot be empty');
    }
    if (subject.length < 5) {
      throw Exception('Subject must be at least 5 characters long');
    }
    if (subject.length > 200) {
      throw Exception('Subject cannot exceed 200 characters');
    }
    if (description.trim().isEmpty) {
      throw Exception('Description cannot be empty');
    }
    if (description.length < 10) {
      throw Exception('Description must be at least 10 characters long');
    }
    if (description.length > 2000) {
      throw Exception('Description cannot exceed 2000 characters');
    }
    if (category.trim().isEmpty) {
      throw Exception('Category must be selected');
    }
    if (priority.trim().isEmpty) {
      throw Exception('Priority must be selected');
    }

    return await repository.createSupportTicket(
      subject: subject.trim(),
      description: description.trim(),
      category: category.trim(),
      priority: priority.trim(),
    );
  }
}

class AddTicketResponse {
  final StudentPortalRepository repository;

  AddTicketResponse(this.repository);

  Future<SupportTicket> call(int ticketId, String message) async {
    if (message.trim().isEmpty) {
      throw Exception('Response message cannot be empty');
    }
    if (message.length < 5) {
      throw Exception('Response message must be at least 5 characters long');
    }
    if (message.length > 1000) {
      throw Exception('Response message cannot exceed 1000 characters');
    }

    return await repository.addTicketResponse(ticketId, message.trim());
  }
}

class GetTicketCategories {
  final StudentPortalRepository repository;

  GetTicketCategories(this.repository);

  Future<List<String>> call() async {
    return await repository.getTicketCategories();
  }
}