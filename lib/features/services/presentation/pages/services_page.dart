import 'package:flutter/material.dart';
import '../widgets/services_header.dart';
import '../widgets/featured_services.dart';
import '../widgets/services_grid.dart';
import '../widgets/quick_access.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh services data
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header
                const ServicesHeader(),
                
                const SizedBox(height: 20),
                
                // Quick Access
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: QuickAccess(),
                ),
                
                const SizedBox(height: 20),
                
                // Featured Services
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FeaturedServices(),
                ),
                
                const SizedBox(height: 20),
                
                // Services Grid
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ServicesGrid(),
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