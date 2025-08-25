import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/support_ticket_usecases.dart';
import 'support_ticket_event.dart';
import 'support_ticket_state.dart';

class SupportTicketBloc extends Bloc<SupportTicketEvent, SupportTicketState> {
  final GetSupportTickets _getSupportTickets;
  final GetSupportTicketDetail _getSupportTicketDetail;
  final CreateSupportTicket _createSupportTicket;
  final AddTicketResponse _addTicketResponse;

  SupportTicketBloc({
    required GetSupportTickets getSupportTickets,
    required GetSupportTicketDetail getSupportTicketDetail,
    required CreateSupportTicket createSupportTicket,
    required AddTicketResponse addTicketResponse,
  })  : _getSupportTickets = getSupportTickets,
        _getSupportTicketDetail = getSupportTicketDetail,
        _createSupportTicket = createSupportTicket,
        _addTicketResponse = addTicketResponse,
        super(SupportTicketInitial()) {
    on<LoadSupportTickets>(_onLoadSupportTickets);
    on<LoadSupportTicketDetail>(_onLoadSupportTicketDetail);
    on<CreateSupportTicketEvent>(_onCreateSupportTicket);
    on<AddSupportTicketResponse>(_onAddSupportTicketResponse);
  }

  Future<void> _onLoadSupportTickets(
    LoadSupportTickets event,
    Emitter<SupportTicketState> emit,
  ) async {
    emit(SupportTicketLoading());
    try {
      final tickets = await _getSupportTickets(
        category: event.category,
        status: event.status,
        priority: event.priority,
        search: event.search,
        page: event.page,
      );
      emit(SupportTicketLoaded(tickets));
    } catch (e) {
      emit(SupportTicketError(e.toString()));
    }
  }

  Future<void> _onLoadSupportTicketDetail(
    LoadSupportTicketDetail event,
    Emitter<SupportTicketState> emit,
  ) async {
    emit(SupportTicketLoading());
    try {
      final ticket = await _getSupportTicketDetail(event.ticketId);
      emit(SupportTicketDetailLoaded(ticket));
    } catch (e) {
      emit(SupportTicketError(e.toString()));
    }
  }

  Future<void> _onCreateSupportTicket(
    CreateSupportTicketEvent event,
    Emitter<SupportTicketState> emit,
  ) async {
    emit(SupportTicketLoading());
    try {
      final ticket = await _createSupportTicket(
        subject: event.subject,
        description: event.description,
        category: event.category,
        priority: event.priority,
      );
      emit(SupportTicketCreated(ticket));
    } catch (e) {
      emit(SupportTicketError(e.toString()));
    }
  }

  Future<void> _onAddSupportTicketResponse(
    AddSupportTicketResponse event,
    Emitter<SupportTicketState> emit,
  ) async {
    try {
      final updatedTicket = await _addTicketResponse(
        event.ticketId,
        event.message,
      );
      emit(SupportTicketResponseAdded(updatedTicket));
    } catch (e) {
      emit(SupportTicketError(e.toString()));
    }
  }
}