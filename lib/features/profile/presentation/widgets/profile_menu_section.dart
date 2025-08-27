import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/domain/usecases/download_id_card_usecase.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/constants/typography.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Personal Information Section
        _buildMenuCard(
          context,
          title: 'المعلومات الشخصية',
          items: [
            _MenuItem(
              icon: Icons.person_outline,
              title: 'تعديل الملف الشخصي',
          subtitle: 'تحديث بياناتك الشخصية',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.contact_phone_outlined,
              title: 'معلومات الاتصال',
          subtitle: 'الهاتف، البريد الإلكتروني، العنوان',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.family_restroom_outlined,
              title: 'جهات الاتصال الطارئة',
          subtitle: 'إدارة جهات الاتصال الطارئة',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.badge_outlined,
              title: 'تحميل الهوية الطلابية',
              subtitle: 'تحميل بطاقة الهوية الطلابية كملف PDF',
              onTap: () => _downloadStudentId(context),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Academic Section
        _buildMenuCard(
          context,
          title: 'الأكاديمية',
          items: [
            _MenuItem(
              icon: Icons.schedule_outlined,
              title: 'الجدول الدراسي',
          subtitle: 'عرض جدولك الحالي',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.assignment_outlined,
              title: 'الدرجات والكشوف',
          subtitle: 'الأداء الأكاديمي',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.school_outlined,
              title: 'تسجيل المقررات',
          subtitle: 'التسجيل في المقررات',
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Settings Section
        _buildMenuCard(
          context,
          title: 'الإعدادات',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'إعدادات الإشعارات',
          subtitle: 'إدارة إشعاراتك',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.security_outlined,
              title: 'الخصوصية والأمان',
          subtitle: 'كلمة المرور، إعدادات الخصوصية',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.help_outline,
              title: 'المساعدة والدعم',
          subtitle: 'احصل على المساعدة والدعم',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.logout_outlined,
              title: 'تسجيل الخروج',
          subtitle: 'تسجيل الخروج من حسابك',
              onTap: () => _showSignOutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: AppTypography.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    color: Colors.grey[200],
                    indent: 20,
                    endIndent: 20,
                  ),
                _buildMenuItem(context, item),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  void _downloadStudentId(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('جاري تحميل الهوية الطلابية...'),
              ],
            ),
          );
        },
      );

      // Get the download use case
      final downloadUseCase = di.sl<DownloadIdCardUseCase>();
      
      // Execute download
      final result = await downloadUseCase.call();
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      result.fold(
        (failure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('فشل في تحميل الهوية الطلابية: ${failure.message}'),
                  ),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
        (filePath) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'تم تحميل الهوية الطلابية بنجاح إلى مجلد التحميلات',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 4),
            ),
          );
        },
      );
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();
      
      // Show generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'حدث خطأ غير متوقع: $e',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showSignOutDialog(BuildContext context) {
    print('[ProfileMenuSection] _showSignOutDialog called');
    print('[ProfileMenuSection] Context: ${context.runtimeType}');
    
    // Debug: Check if AuthBloc is available in current context
    try {
      final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
      print('[ProfileMenuSection] AuthBloc found: ${authBloc.runtimeType}');
    } catch (e) {
      print('[ProfileMenuSection] AuthBloc NOT found in context: $e');
    }
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        print('[ProfileMenuSection] Dialog builder called');
        print('[ProfileMenuSection] Dialog context: ${dialogContext.runtimeType}');
        
        // Debug: Check if AuthBloc is available in dialog context
        try {
          final authBloc = BlocProvider.of<AuthBloc>(dialogContext, listen: false);
          print('[ProfileMenuSection] AuthBloc found in dialog: ${authBloc.runtimeType}');
        } catch (e) {
          print('[ProfileMenuSection] AuthBloc NOT found in dialog context: $e');
        }
        
        return AlertDialog(
          title: const Text('تسجيل الخروج'),
            content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                print('[ProfileMenuSection] Sign out button pressed');
                Navigator.of(dialogContext).pop();
                
                // Try to access AuthBloc from the original context instead of dialog context
                try {
                  print('[ProfileMenuSection] Attempting to access AuthBloc from original context');
                  BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequested());
                  print('[ProfileMenuSection] AuthLogoutRequested sent successfully');
                } catch (e) {
                  print('[ProfileMenuSection] Failed to access AuthBloc from original context: $e');
                  
                  // Try to access from dialog context as fallback
                  try {
                    print('[ProfileMenuSection] Attempting to access AuthBloc from dialog context');
                    BlocProvider.of<AuthBloc>(dialogContext).add(AuthLogoutRequested());
                    print('[ProfileMenuSection] AuthLogoutRequested sent from dialog context');
                  } catch (e2) {
                    print('[ProfileMenuSection] Failed to access AuthBloc from dialog context: $e2');
                  }
                }
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.isDestructive 
                    ? Colors.red.withOpacity(0.1)
                    : Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: item.isDestructive 
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: AppTypography.medium,
                      color: item.isDestructive 
                          ? Colors.red
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}