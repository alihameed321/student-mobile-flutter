import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/api_constants.dart';

class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture and Basic Info
                  _buildProfileSection(context, user),
                  const SizedBox(height: 24),

                  // Personal Information
                  _buildSectionCard(
                    'Personal Information',
                    Icons.person_outline,
                    [
                      _buildInfoRow('Full Name', user.fullName),
                      _buildInfoRow('University ID', user.studentId ?? 'N/A'),
                      _buildInfoRow('Email', user.email),
                      _buildInfoRow(
                          'Phone Number',
                          user.phone?.isNotEmpty == true
                              ? user.phone!
                              : 'Not provided'),
                      _buildInfoRow(
                          'Date Joined',
                          user.dateJoined?.toString().split(' ')[0] ??
                              'Not provided'),
                      _buildInfoRow('User Type',
                          user.userType?.toUpperCase() ?? 'Not specified'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Academic Information
                  _buildSectionCard(
                    'Academic Information',
                    Icons.school_outlined,
                    [
                      _buildInfoRow('Major', user.major ?? 'Not specified'),
                      _buildInfoRow('Academic Level',
                          user.academicLevel ?? 'Not specified'),
                      _buildInfoRow('University ID',
                          user.universityId ?? 'Not specified'),
                      _buildInfoRow('Student Status',
                          user.isActive ? 'Active' : 'Inactive'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Account Information
                  _buildSectionCard(
                    'Account Information',
                    Icons.account_circle_outlined,
                    [
                      _buildInfoRow('Account Status',
                          user.isActive ? 'Active' : 'Inactive'),
                      _buildInfoRow(
                          'Staff Member', user.isStaff ? 'Yes' : 'No'),
                      _buildInfoRow(
                          'Date Joined',
                          user.dateJoined?.toString().split(' ')[0] ??
                              'Not available'),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Please log in to view student details'),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundImage: user.profilePicture != null
                  ? NetworkImage(
                      '${ApiConstants.baseUrl}${user.profilePicture!}')
                  : null,
              backgroundColor: Colors.grey[200],
              child: user.profilePicture == null
                  ? Text(
                      '${user.firstName[0]}${user.lastName[0]}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 16),

          // Basic Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.major ?? 'No Major Specified',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${user.studentId ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
