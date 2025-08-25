import 'package:equatable/equatable.dart';
import '../../../domain/entities/support_ticket.dart';

abstract class SupportTicketState extends Equatable {
  const SupportTicketState();

  @override
  List<Object?> get props => [];
}

class SupportTicketInitial extends SupportTicketState {}

class SupportTicketLoading extends SupportTicketState {}

class SupportTicketLoaded extends SupportTicketState {
  final List<SupportTicket> tickets;

  const SupportTicketLoaded(this.tickets);

  @override
  List<Object?> get props => [tickets];
}

class SupportTicketDetailLoaded extends SupportTicketState {
  final SupportTicket ticket;

  const SupportTicketDetailLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportTicketCreated extends SupportTicketState {
  final SupportTicket ticket;

  const SupportTicketCreated(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportTicketError extends SupportTicketState {
  final String message;

  const SupportTicketError(this.message);

  @override
  List<Object?> get props => [message];
}

class SupportTicketResponseAdded extends SupportTicketState {
  final SupportTicket ticket;

  const SupportTicketResponseAdded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}