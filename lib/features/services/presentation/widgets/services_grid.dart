import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/service_request_form_page.dart';
import '../bloc/service_request/service_request_bloc.dart';

class ServicesGrid extends StatelessWidget {
  final String searchQuery;
  
  const ServicesGrid({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context) {
    final services = _getServices();
    final filteredServices = _filterServices(services);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with improved styling
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      searchQuery.isEmpty 
                          ? 'خدمات الجامعة' 
                          : 'نتائج البحث',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (searchQuery.isNotEmpty)
                      Text(
                        'تم العثور على ${filteredServices.length} خدمة',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      )
                    else
                      Text(
                        'اختر من عروض الخدمات الشاملة لدينا',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (filteredServices.isEmpty && searchQuery.isNotEmpty)
          _buildNoResultsWidget()
        else
          _buildServicesGrid(context, filteredServices),
      ],
    );
  }
  
  List<Map<String, dynamic>> _getServices() {
    return [
      {
        'title': 'شهادة القيد',
        'subtitle': 'وثيقة التحقق الرسمية من القيد',
        'icon': Icons.school_rounded,
        'color': const Color(0xFF2196F3),
        'requestType': 'enrollment_certificate',
      },
      {
        'title': 'تعديل الجدول',
        'subtitle': 'تغييرات جدول المقررات والمواعيد',
        'icon': Icons.schedule_rounded,
        'color': const Color(0xFF4CAF50),
        'requestType': 'schedule_modification',
      },
      {
        'title': 'تأجيل الفصل الدراسي',
        'subtitle': 'طلب تأجيل التسجيل للفصل الدراسي',
        'icon': Icons.pause_circle_filled_rounded,
        'color': const Color(0xFFFF9800),
        'requestType': 'semester_postponement',
      },
      {
        'title': 'كشف الدرجات الرسمي',
        'subtitle': 'السجلات الأكاديمية وتقارير الدرجات',
        'icon': Icons.description_rounded,
        'color': const Color(0xFF9C27B0),
        'requestType': 'transcript',
      },
      {
        'title': 'شهادة التخرج',
        'subtitle': 'وثائق التخرج الرسمية',
        'icon': Icons.workspace_premium_rounded,
        'color': const Color(0xFFE91E63),
        'requestType': 'graduation_certificate',
      },
      {
        'title': 'خدمات أخرى',
        'subtitle': 'الاستفسارات العامة والطلبات المخصصة',
        'icon': Icons.support_agent_rounded,
        'color': const Color(0xFF00BCD4),
        'requestType': 'other',
      },
    ];
  }
  
  List<Map<String, dynamic>> _filterServices(List<Map<String, dynamic>> services) {
    if (searchQuery.isEmpty) return services;
    
    return services.where((service) {
      final title = service['title'].toString().toLowerCase();
      final subtitle = service['subtitle'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      
      return title.contains(query) || subtitle.contains(query);
    }).toList();
  }
  
  Widget _buildServicesGrid(BuildContext context, List<Map<String, dynamic>> services) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75, // Increased height to prevent overflow
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildProfessionalServiceCard(
          context,
          title: service['title'],
          subtitle: service['subtitle'],
          icon: service['icon'],
          color: service['color'],
          requestType: service['requestType'],
          index: index,
        );
      },
    );
  }

  Widget _buildNoResultsWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'لم يتم العثور على خدمات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مفتاحية مختلفة\nأو تصفح جميع الخدمات المتاحة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String requestType,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _navigateToServiceRequest(context, requestType),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey[50]!,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: color.withOpacity(0.12),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Header with gradient background
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withOpacity(0.1),
                              color.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              icon,
                              color: color,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      // Content section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text content
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                        height: 1.2,
                                        letterSpacing: -0.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      subtitle,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Action indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: color.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'طلب',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 10,
                                      color: color,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToServiceRequest(BuildContext context, String requestType) async {
    final serviceRequestBloc = context.read<ServiceRequestBloc>();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: serviceRequestBloc,
          child: ServiceRequestFormPage(
            serviceType: requestType,
          ),
        ),
      ),
    );
    
    // Always refresh service requests when returning from form
    // This ensures data is up-to-date regardless of whether a request was created
    serviceRequestBloc.add(RefreshServiceRequests());
  }
}