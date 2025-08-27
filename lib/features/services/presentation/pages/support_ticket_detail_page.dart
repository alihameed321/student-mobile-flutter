import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/support_ticket.dart';
import '../bloc/support_ticket/support_ticket_bloc.dart';
import '../bloc/support_ticket/support_ticket_event.dart';
import '../bloc/support_ticket/support_ticket_state.dart';
import '../../../../core/constants/typography.dart';


class SupportTicketDetailPage extends StatefulWidget {
  final int ticketId;

  const SupportTicketDetailPage({
    super.key,
    required this.ticketId,
  });

  @override
  State<SupportTicketDetailPage> createState() => _SupportTicketDetailPageState();
}

class _SupportTicketDetailPageState extends State<SupportTicketDetailPage> {
  final TextEditingController _responseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSubmittingResponse = false;

  @override
  void initState() {
    super.initState();
    context.read<SupportTicketBloc>().add(
      LoadSupportTicketDetail(widget.ticketId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التذكرة'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<SupportTicketBloc, SupportTicketState>(
        listener: (context, state) {
          if (state is SupportTicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is SupportTicketResponseAdded) {
            _responseController.clear();
            setState(() => _isSubmittingResponse = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة الرد بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            // Scroll to bottom to show new response
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
        builder: (context, state) {
          if (state is SupportTicketLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SupportTicketError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل التذكرة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SupportTicketBloc>().add(
                        LoadSupportTicketDetail(widget.ticketId),
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is SupportTicketDetailLoaded) {
            final ticket = state.ticket;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTicketHeader(ticket),
                        const SizedBox(height: 24),
                        _buildTicketDescription(ticket),
                        const SizedBox(height: 24),
                        _buildTicketInfo(ticket),
                        if (ticket.responses != null && ticket.responses!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildResponsesSection(ticket.responses!),
                        ],
                      ],
                    ),
                  ),
                ),
                if (!ticket.isClosed) _buildResponseInput(ticket),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTicketHeader(SupportTicket ticket) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ticket.categoryIcon,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ticket.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ticket.statusColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ticket.isOpen ? Icons.circle : Icons.check_circle,
                        color: ticket.statusColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ticket.statusDisplayText,
                        style: TextStyle(
                          color: ticket.statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ticket.priorityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: ticket.priorityColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        ticket.priorityIcon,
                        color: ticket.priorityColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ticket.priorityDisplayText,
                        style: TextStyle(
                          color: ticket.priorityColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (ticket.ticketNumber != null) ...[
              const SizedBox(height: 8),
              Text(
                'Ticket #${ticket.ticketNumber}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDescription(SupportTicket ticket) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الوصف',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(SupportTicket ticket) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات التذكرة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('الفئة', ticket.categoryDisplayName),
            _buildInfoRow('الأولوية', ticket.priorityDisplayText),
            _buildInfoRow('الحالة', ticket.statusDisplayText),
            _buildInfoRow('تاريخ الإنشاء', _formatDateTime(ticket.createdAt)),
            _buildInfoRow('آخر تحديث', _formatDateTime(ticket.updatedAt)),
            if (ticket.assignedTo != null)
              _buildInfoRow('مُسند إلى', ticket.assignedTo!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesSection(List<TicketResponse> responses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الرسائل',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...responses.map((response) => _buildResponseCard(response)),
      ],
    );
  }

  Widget _buildResponseCard(TicketResponse response) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: response.isFromStaff
              ? Colors.blue.shade200
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: response.isFromStaff
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
                  child: Icon(
                    response.isFromStaff ? Icons.support_agent : Icons.person,
                    size: 16,
                    color: response.isFromStaff
                        ? Colors.blue.shade600
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        response.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (response.authorPosition != null)
                        Text(
                          response.authorPosition!,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  _formatDateTime(response.createdAt),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              response.message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            if (response.isInternal)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.shade200,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 12,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ملاحظة داخلية',
                      style: AppTypography.labelSmallStyle.copyWith(
                        color: Colors.orange.shade600,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseInput(SupportTicket ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إضافة رد',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _responseController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'اكتب ردك...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () => _responseController.clear(),
                child: const Text('مسح'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSubmittingResponse || _responseController.text.trim().isEmpty
                    ? null
                    : () => _submitResponse(ticket),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmittingResponse
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('إرسال الرد'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitResponse(SupportTicket ticket) {
    if (_responseController.text.trim().isEmpty) return;

    setState(() => _isSubmittingResponse = true);

    context.read<SupportTicketBloc>().add(
      AddSupportTicketResponse(
        ticketId: ticket.id,
        message: _responseController.text.trim(),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'الآن';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'أمس في ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _responseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}