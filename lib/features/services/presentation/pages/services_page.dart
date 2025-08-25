import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../widgets/services_header.dart';

import '../widgets/services_grid.dart';

import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/service_request/service_request_bloc.dart';
import '../widgets/dashboard_stats_widget.dart';
import '../widgets/recent_activities_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) =>
              di.sl<DashboardBloc>()..add(const LoadDashboardStats()),
        ),
        BlocProvider<ServiceRequestBloc>(
          create: (context) => di.sl<ServiceRequestBloc>(),
        ),
      ],
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<DashboardBloc>()
                    .add(const RefreshDashboardStats());
                context
                    .read<ServiceRequestBloc>()
                    .add(const RefreshServiceRequests());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header
                    ServicesHeader(
                      searchController: _searchController,
                      onSearchChanged: _onSearchChanged,
                      onClearSearch: _clearSearch,
                    ),

                    const SizedBox(height: 20),

                    // Dashboard Stats
                    if (state is DashboardLoaded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DashboardStatsWidget(
                            dashboardStats: state.dashboardStats),
                      )
                    else if (state is DashboardLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state is DashboardError)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          color: Colors.red[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.error, color: Colors.red[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Failed to load dashboard: ${state.message}',
                                    style: TextStyle(color: Colors.red[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Recent Activities
                    if (state is DashboardLoaded &&
                        state.dashboardStats.hasRecentActivity)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: RecentActivitiesWidget(
                            dashboardStats: state.dashboardStats),
                      ),

                    const SizedBox(height: 20),

                    // Services Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ServicesGrid(searchQuery: _searchQuery),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }))),
    );
  }
}
