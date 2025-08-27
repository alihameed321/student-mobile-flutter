import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/service_request/service_request_bloc.dart';

class ServiceRequestFormPage extends StatefulWidget {
  final String? serviceType;

  const ServiceRequestFormPage({
    super.key,
    this.serviceType,
  });

  @override
  State<ServiceRequestFormPage> createState() => _ServiceRequestFormPageState();
}

class _ServiceRequestFormPageState extends State<ServiceRequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedRequestType;
  String? _selectedPriority;
  List<String> _requestTypes = [];
  final List<String> _priorityOptions = ['low', 'medium', 'high'];
  bool _hasLoadedTypes = false;

  // Mapping for display labels
  final Map<String, String> _requestTypeLabels = {
    'enrollment_certificate': 'شهادة قيد',
    'schedule_modification': 'تعديل الجدول',
    'semester_postponement': 'تأجيل الفصل الدراسي',
    'transcript': 'كشف درجات رسمي',
    'graduation_certificate': 'شهادة تخرج',
    'other': 'أخرى',
  };

  @override
  void initState() {
    super.initState();
    _selectedRequestType = widget.serviceType;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load service request types when dependencies are ready
    if (!_hasLoadedTypes) {
      _hasLoadedTypes = true;
      context.read<ServiceRequestBloc>().add(LoadServiceRequestTypes());
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب خدمة جديد'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء طلب الخدمة بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is ServiceRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ServiceRequestTypesLoaded) {
            setState(() {
              _requestTypes = state.types;
              if (_selectedRequestType != null &&
                  !_requestTypes.contains(_selectedRequestType)) {
                _selectedRequestType = null;
              }
            });
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
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.assignment_add,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'تقديم طلب خدمة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'املأ النموذج أدناه لتقديم طلب الخدمة',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Service Type Section
                  _buildFormSection(
                    title: 'نوع الخدمة',
                    required: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedRequestType,
                        decoration: InputDecoration(
                          hintText: 'اختر نوع الخدمة',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.blue[600]!, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.red[400]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.category_outlined,
                              color: Colors.blue[600],
                              size: 20,
                            ),
                          ),
                        ),
                        items: _requestTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              _requestTypeLabels[type] ?? type,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRequestType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار نوع الخدمة';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title Section
                  _buildFormSection(
                    title: 'العنوان',
                    required: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'أدخل عنوان الطلب',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.blue[600]!, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.red[400]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.title_outlined,
                              color: Colors.green[600],
                              size: 20,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال العنوان';
                          }
                          if (value.trim().length < 3) {
                            return 'يجب أن يكون العنوان 3 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Section
                  _buildFormSection(
                    title: 'الوصف',
                    required: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'اوصف طلب الخدمة بالتفصيل...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.blue[600]!, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.red[400]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.description_outlined,
                              color: Colors.purple[600],
                              size: 20,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى تقديم وصف';
                          }
                          if (value.trim().length < 20) {
                            return 'يجب أن يكون الوصف 20 حرف على الأقل';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Priority Section
                  _buildFormSection(
                    title: 'الأولوية',
                    required: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        decoration: InputDecoration(
                          hintText: 'اختر مستوى الأولوية',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.blue[600]!, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.red[400]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.priority_high_outlined,
                              color: Colors.red[600],
                              size: 20,
                            ),
                          ),
                        ),
                        items: _priorityOptions.map((priority) {
                          Color priorityColor = priority == 'high'
                              ? Colors.red[600]!
                              : priority == 'medium'
                                  ? Colors.orange[600]!
                                  : Colors.green[600]!;
                          return DropdownMenuItem(
                            value: priority,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: priorityColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  priority == 'high' ? 'عالية' : priority == 'medium' ? 'متوسطة' : 'منخفضة',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: priorityColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى اختيار مستوى الأولوية';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is ServiceRequestCreating
                          ? null
                          : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: state is ServiceRequestCreating
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'جاري الإرسال...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'إرسال الطلب',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required Widget child,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
                letterSpacing: -0.2,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.red[600],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      context.read<ServiceRequestBloc>().add(
            CreateServiceRequestEvent(
              requestType: _selectedRequestType!,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              priority: _selectedPriority,
            ),
          );
    }
  }
}
