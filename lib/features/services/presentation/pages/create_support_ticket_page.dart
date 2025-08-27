import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/support_ticket/support_ticket_bloc.dart';
import '../bloc/support_ticket/support_ticket_event.dart';
import '../bloc/support_ticket/support_ticket_state.dart';

class CreateSupportTicketPage extends StatefulWidget {
  const CreateSupportTicketPage({super.key});

  @override
  State<CreateSupportTicketPage> createState() => _CreateSupportTicketPageState();
}

class _CreateSupportTicketPageState extends State<CreateSupportTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = 'general';
  String _selectedPriority = 'medium';
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {
      'value': 'technical',
      'label': 'الدعم التقني',
      'description': 'مشاكل في الأنظمة والتطبيقات والتكنولوجيا',
      'icon': Icons.computer,
    },
    {
      'value': 'academic',
      'label': 'الخدمات الأكاديمية',
      'description': 'تسجيل المقررات والدرجات والسجلات الأكاديمية',
      'icon': Icons.school,
    },
    {
      'value': 'financial',
      'label': 'الخدمات المالية',
      'description': 'الرسوم الدراسية والمساعدات المالية والفواتير',
      'icon': Icons.account_balance_wallet,
    },
    {
      'value': 'general',
      'label': 'استفسار عام',
      'description': 'أسئلة أخرى أو دعم عام',
      'icon': Icons.help_outline,
    },
  ];

  final List<Map<String, dynamic>> _priorities = [
    {
      'value': 'low',
      'label': 'منخفض',
      'description': 'أسئلة عامة، مشاكل غير عاجلة',
      'color': Colors.green,
      'icon': Icons.keyboard_arrow_down,
    },
    {
      'value': 'medium',
      'label': 'متوسط',
      'description': 'طلبات دعم عادية',
      'color': Colors.orange,
      'icon': Icons.remove,
    },
    {
      'value': 'high',
      'label': 'عالي',
      'description': 'مشاكل مهمة تؤثر على دراستك',
      'color': Colors.red,
      'icon': Icons.keyboard_arrow_up,
    },
    {
      'value': 'urgent',
      'label': 'عاجل',
      'description': 'مشاكل حرجة تتطلب اهتماماً فورياً',
      'color': Colors.red.shade700,
      'icon': Icons.priority_high,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء تذكرة دعم'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<SupportTicketBloc, SupportTicketState>(
        listener: (context, state) {
          if (state is SupportTicketError) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is SupportTicketCreated) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء تذكرة الدعم بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('الفئة'),
                  const SizedBox(height: 8),
                  _buildCategorySelection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الأولوية'),
                  const SizedBox(height: 8),
                  _buildPrioritySelection(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الموضوع'),
                  const SizedBox(height: 8),
                  _buildSubjectField(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الوصف'),
                  const SizedBox(height: 8),
                  _buildDescriptionField(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          );
        },
      ),
    ),
    ); 
     }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      children: _categories.map((category) {
        final isSelected = _selectedCategory == category['value'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => setState(() => _selectedCategory = category['value']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    category['icon'],
                    color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['label'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.blue.shade600 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.blue.shade600,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelection() {
    return Column(
      children: _priorities.map((priority) {
        final isSelected = _selectedPriority == priority['value'];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? priority['color'] : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () => setState(() => _selectedPriority = priority['value']),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    priority['icon'],
                    color: isSelected ? priority['color'] : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          priority['label'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? priority['color'] : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priority['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: priority['color'],
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectField() {
    return TextFormField(
      controller: _subjectController,
      decoration: InputDecoration(
        hintText: 'أدخل موضوع مختصر لتذكرتك',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: const Icon(Icons.subject),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال الموضوع';
        }
        if (value.trim().length < 5) {
          return 'يجب أن يكون الموضوع 5 أحرف على الأقل';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: 'اوصف مشكلتك بالتفصيل. قم بتضمين أي معلومات ذات صلة قد تساعدنا في مساعدتك بشكل أفضل.',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى تقديم وصف';
        }
        if (value.trim().length < 20) {
          return 'يجب أن يكون الوصف 20 حرفاً على الأقل';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitTicket,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'جاري إنشاء التذكرة...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'إنشاء تذكرة دعم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _submitTicket() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    context.read<SupportTicketBloc>().add(
      CreateSupportTicketEvent(
        subject: _subjectController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}