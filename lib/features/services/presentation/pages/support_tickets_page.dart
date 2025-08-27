import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/support_ticket.dart';
import '../bloc/support_ticket/support_ticket_bloc.dart';
import '../bloc/support_ticket/support_ticket_event.dart';
import '../bloc/support_ticket/support_ticket_state.dart';
import 'support_ticket_detail_page.dart';
import 'create_support_ticket_page.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedPriority;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    context.read<SupportTicketBloc>().add(
      LoadSupportTickets(
        category: _selectedCategory,
        status: _selectedStatus,
        priority: _selectedPriority,
        search: _searchController.text.isEmpty ? null : _searchController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('تذاكر الدعم'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: BlocConsumer<SupportTicketBloc, SupportTicketState>(
              listener: (context, state) {
                if (state is SupportTicketError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                          'خطأ في تحميل التذاكر',
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
                          onPressed: _loadTickets,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SupportTicketLoaded) {
                  if (state.tickets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.support_agent,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لم يتم العثور على تذاكر دعم',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أنشئ أول تذكرة دعم للحصول على المساعدة',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadTickets(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = state.tickets[index];
                        return _buildTicketCard(ticket);
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSupportTicketPage(),
            ),
          ).then((_) => _loadTickets());
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'البحث في التذاكر...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadTickets();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onSubmitted: (_) => _loadTickets(),
      ),
    );
  }

  Widget _buildFilterChips() {
    final hasFilters = _selectedCategory != null ||
        _selectedStatus != null ||
        _selectedPriority != null;

    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedCategory != null)
            _buildFilterChip(
              'الفئة: ${_getCategoryDisplayName(_selectedCategory!)}',
              () {
                setState(() => _selectedCategory = null);
                _loadTickets();
              },
            ),
          if (_selectedStatus != null)
            _buildFilterChip(
              'الحالة: ${_getStatusDisplayName(_selectedStatus!)}',
              () {
                setState(() => _selectedStatus = null);
                _loadTickets();
              },
            ),
          if (_selectedPriority != null)
            _buildFilterChip(
              'الأولوية: ${_getPriorityDisplayName(_selectedPriority!)}',
              () {
                setState(() => _selectedPriority = null);
                _loadTickets();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        onDeleted: onDeleted,
        backgroundColor: Colors.blue.shade50,
        deleteIconColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportTicketDetailPage(ticketId: ticket.id),
            ),
          ).then((_) => _loadTickets());
        },
        borderRadius: BorderRadius.circular(12),
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
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ticket.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ticket.statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      ticket.statusDisplayText,
                      style: TextStyle(
                        color: ticket.statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    ticket.priorityIcon,
                    color: ticket.priorityColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ticket.priorityDisplayText,
                    style: TextStyle(
                      color: ticket.priorityColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.category,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ticket.categoryDisplayName,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (ticket.responses != null && ticket.responses!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey.shade500,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${ticket.responses!.length} ${ticket.responses!.length == 1 ? 'رد' : 'ردود'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية التذاكر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الفئة'),
            DropdownButton<String?>(
              value: _selectedCategory,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('جميع الفئات')),
                ...['technical', 'academic', 'financial', 'general']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(_getCategoryDisplayName(category)),
                        )),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: 16),
            const Text('الحالة'),
            DropdownButton<String?>(
              value: _selectedStatus,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('جميع الحالات')),
                ...['open', 'in_progress', 'resolved', 'closed']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusDisplayName(status)),
                        )),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 16),
            const Text('الأولوية'),
            DropdownButton<String?>(
              value: _selectedPriority,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: null, child: Text('جميع الأولويات')),
                ...['low', 'medium', 'high', 'urgent']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(_getPriorityDisplayName(priority)),
                        )),
              ],
              onChanged: (value) => setState(() => _selectedPriority = value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _selectedStatus = null;
                _selectedPriority = null;
              });
              Navigator.pop(context);
              _loadTickets();
            },
            child: const Text('مسح الكل'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadTickets();
            },
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'technical':
        return 'الدعم التقني';
      case 'academic':
        return 'الخدمات الأكاديمية';
      case 'financial':
        return 'الخدمات المالية';
      case 'general':
        return 'استفسار عام';
      default:
        return category;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'open':
        return 'مفتوح';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'resolved':
        return 'محلول';
      case 'closed':
        return 'مغلق';
      default:
        return status;
    }
  }

  String _getPriorityDisplayName(String priority) {
    switch (priority) {
      case 'low':
        return 'منخفض';
      case 'medium':
        return 'متوسط';
      case 'high':
        return 'عالي';
      case 'urgent':
        return 'عاجل';
      default:
        return priority;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      }
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}