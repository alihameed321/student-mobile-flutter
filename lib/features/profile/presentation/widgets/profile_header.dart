import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/api_constants.dart';
import '../pages/student_details_page.dart';
import '../../../../core/constants/typography.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return Row(
            children: [
              // Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: user.profilePicture != null 
                      ? NetworkImage('${ApiConstants.baseUrl}${user.profilePicture!}') 
                      : null,
                  backgroundColor: Colors.grey,
                  child: user.profilePicture == null 
                      ? Text(
                          '${user.firstName[0]}${user.lastName[0]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: AppTypography.bold,
                          ),
                        )
                      : null,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.major ?? 'لم يتم تحديد التخصص',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'الرقم الجامعي: ${user.universityId ?? user.studentId ?? 'غير متوفر'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // View Details Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                    onPressed: () {
                      final authBloc = context.read<AuthBloc>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: authBloc,
                            child: const StudentDetailsPage(),
                          ),
                        ),
                      );
                    },
                  icon: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        }
        
        // Show login prompt for non-authenticated states
        return Row(
          children: [
            // Profile Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Login Prompt
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'يرجى تسجيل الدخول',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'للوصول إلى ملفك الشخصي',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Login Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {
                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}