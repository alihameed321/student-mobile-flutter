import 'package:equatable/equatable.dart';

abstract class SupportTicketEvent extends Equatable {
  const SupportTicketEvent();

  @override
  List<Object?> get props => [];
}

class LoadSupportTickets extends SupportTicketEvent {
  final String? category;
  final String? status;
  final String? priority;
  final String? search;
  final int? page;

  const LoadSupportTickets({
    this.category,
    this.status,
    this.priority,
    this.search,
    this.page,
  });

  @override
  List<Object?> get props => [category, status, priority, search, page];
}

class LoadSupportTicketDetail extends SupportTicketEvent {
  final int ticketId;

  const LoadSupportTicketDetail(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

class CreateSupportTicketEvent extends SupportTicketEvent {
  final String subject;
  final String description;
  final String category;
  final String priority;

  const CreateSupportTicketEvent({
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
  });

  @override
  List<Object?> get props => [subject, description, category, priority];
}

class AddSupportTicketResponse extends SupportTicketEvent {
  final int ticketId;
  final String message;

  const AddSupportTicketResponse({
    required this.ticketId,
    required this.message,
  });

  @override
  List<Object?> get props => [ticketId, message];
}