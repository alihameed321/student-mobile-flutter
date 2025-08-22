import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Personal Information Section
        _buildMenuCard(
          context,
          title: 'Personal Information',
          items: [
            _MenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal details',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.contact_phone_outlined,
              title: 'Contact Information',
              subtitle: 'Phone, email, address',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.family_restroom_outlined,
              title: 'Emergency Contacts',
              subtitle: 'Manage emergency contacts',
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Academic Section
        _buildMenuCard(
          context,
          title: 'Academic',
          items: [
            _MenuItem(
              icon: Icons.schedule_outlined,
              title: 'Class Schedule',
              subtitle: 'View your current schedule',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.assignment_outlined,
              title: 'Grades & Transcripts',
              subtitle: 'Academic performance',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.school_outlined,
              title: 'Course Registration',
              subtitle: 'Register for courses',
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Settings Section
        _buildMenuCard(
          context,
          title: 'Settings',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notification Settings',
              subtitle: 'Manage your notifications',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Password, privacy settings',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and support',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.logout_outlined,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
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
                fontWeight: FontWeight.bold,
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
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
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
                'Sign Out',
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
                      fontWeight: FontWeight.w500,
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