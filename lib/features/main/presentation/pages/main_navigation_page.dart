import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation_bloc.dart';
import '../bloc/navigation_event.dart';
import '../bloc/navigation_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../financial/presentation/pages/financial_page.dart';
import '../../../services/presentation/pages/services_page.dart';
import '../../../documents/presentation/pages/documents_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../widgets/custom_bottom_navigation.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: const MainNavigationView(),
    );
  }
}

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  final List<Widget> _pages = const [
    ProfilePage(),
    FinancialPage(),
    ServicesPage(),
    DocumentsPage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: CustomBottomNavigation(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(
                NavigationTabChanged(index),
              );
            },
          ),
        );
      },
    );
  }
}