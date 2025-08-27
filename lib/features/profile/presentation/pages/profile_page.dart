import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_section.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/academic_progress_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ملفي الشخصي',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Settings action
                          },
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const ProfileHeader(),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Stats Cards
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ProfileStatsCard(),
              ),
              
              const SizedBox(height: 20),
              
              // Quick Actions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: QuickActionsCard(),
              ),
              
              const SizedBox(height: 20),
              
              // Academic Progress
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AcademicProgressCard(),
              ),
              
              const SizedBox(height: 20),
              
              // Menu Sections
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ProfileMenuSection(),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
    );
  }
}