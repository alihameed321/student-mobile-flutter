import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/service_request/service_request_bloc.dart';
import '../../domain/entities/service_request.dart';
import 'service_request_form_page.dart';
import '../../../../core/di/injection_container.dart';

// Helper function to convert color strings to Color objects
Color _getColorFromString(String colorString) {
  switch (colorString.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'orange':
      return Colors.orange;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

class ServiceRequestsPage extends StatefulWidget {
  const ServiceRequestsPage({super.key});

  @override
  State<ServiceRequestsPage> createState() => _ServiceRequestsPageState();
}

class _ServiceRequestsPageState extends State<ServiceRequestsPage> {
  String? _selectedStatus;
  String? _selectedType;
  final List<String> _statusFilters = [
    'All',
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled'
  ];

  @override
  Widget build(BuildContext context) {
    // Check if ServiceRequestBloc already exists in the context
    ServiceRequestBloc? existingBloc;
    try {
      existingBloc = BlocProvider.of<ServiceRequestBloc>(context, listen: false);
    } catch (e) {
      // No existing bloc found, will create a new one
      existingBloc = null;
    }

    if (existingBloc != null) {
      // Use existing bloc
      return Scaffold(
        appBar: AppBar(
          title: const Text('Service Requests'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: existingBloc!,
                  child: const ServiceRequestFormPage(),
                ),
              ),
            );
            if (result == true) {
              existingBloc!.add(RefreshServiceRequests());
            }
          },
          backgroundColor: Colors.blue.shade600,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
          listener: (context, state) {
            if (state is ServiceRequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return _buildContent(state);
          },
        ),
      );
    }

    // Create new bloc if none exists
    return BlocProvider(
      create: (context) => sl<ServiceRequestBloc>()
        ..add(LoadServiceRequests())
        ..add(LoadServiceRequestTypes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service Requests'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterDialog,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final serviceRequestBloc = context.read<ServiceRequestBloc>();
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: serviceRequestBloc,
                  child: const ServiceRequestFormPage(),
                ),
              ),
            );
            if (result == true) {
              serviceRequestBloc.add(RefreshServiceRequests());
            }
          },
          backgroundColor: Colors.blue.shade600,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocConsumer<ServiceRequestBloc, ServiceRequestState>(
          listener: (context, state) {
            if (state is ServiceRequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ServiceRequestCanceled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service request cancelled successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
              context.read<ServiceRequestBloc>().add(RefreshServiceRequests());
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ServiceRequestBloc>()
                    .add(RefreshServiceRequests());
              },
              child: Column(
                children: [
                  // Filter chips
                  if (_selectedStatus != null || _selectedType != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          if (_selectedStatus != null)
                            FilterChip(
                              label: Text('Status: $_selectedStatus'),
                              selected: true,
                              onSelected: (bool selected) {},
                              onDeleted: () {
                                setState(() {
                                  _selectedStatus = null;
                                });
                                _applyFilters();
                              },
                            ),
                          if (_selectedType != null)
                            FilterChip(
                              label: Text('Type: $_selectedType'),
                              selected: true,
                              onSelected: (bool selected) {},
                              onDeleted: () {
                                setState(() {
                                  _selectedType = null;
                                });
                                _applyFilters();
                              },
                            ),
                        ],
                      ),
                    ),

                  // Content
                  Expanded(
                    child: _buildContent(state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(ServiceRequestState state) {
    if (state is ServiceRequestLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ServiceRequestLoaded) {
      if (state.serviceRequests.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.serviceRequests.length,
        itemBuilder: (context, index) {
          final request = state.serviceRequests[index];
          return _buildServiceRequestCard(request);
        },
      );
    }

    if (state is ServiceRequestError) {
      return _buildErrorState(state.message);
    }

    return _buildEmptyState();
  }

  Widget _buildServiceRequestCard(ServiceRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showRequestDetail(request),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.requestType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Request #${request.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getColorFromString(request.statusColor)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status,
                      style: TextStyle(
                        color: _getColorFromString(request.statusColor),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                request.description.length > 100
                    ? '${request.description.substring(0, 100)}...'
                    : request.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm')
                        .format(request.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (request.isPending)
                    TextButton(
                      onPressed: () => _cancelRequest(request),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Service Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t submitted any service requests yet',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final serviceRequestBloc = context.read<ServiceRequestBloc>();
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: serviceRequestBloc,
                    child: const ServiceRequestFormPage(),
                  ),
                ),
              );
              if (result == true) {
                serviceRequestBloc.add(RefreshServiceRequests());
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ServiceRequestBloc>().add(LoadServiceRequests());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Requests'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select status',
              ),
              items: _statusFilters.map((status) {
                return DropdownMenuItem(
                  value: status == 'All' ? null : status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                _selectedType = null;
              });
              Navigator.of(context).pop();
              _applyFilters();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<ServiceRequestBloc>().add(
          LoadServiceRequests(
            status: _selectedStatus,
            requestType: _selectedType,
          ),
        );
  }

  void _showRequestDetail(ServiceRequest request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        request.requestType,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getColorFromString(request.statusColor)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          color: _getColorFromString(request.statusColor),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Details
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Request ID', '#${request.id}'),
                        _buildDetailRow(
                            'Created',
                            DateFormat('MMM dd, yyyy • HH:mm')
                                .format(request.createdAt)),
                        if (request.updatedAt != request.createdAt)
                          _buildDetailRow(
                              'Updated',
                              request.updatedAt != null
                                  ? DateFormat('MMM dd, yyyy • HH:mm')
                                      .format(request.updatedAt!)
                                  : 'Not updated'),
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          request.description,
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                if (request.isPending)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _cancelRequest(request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancel Request'),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _cancelRequest(ServiceRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: Text(
          'Are you sure you want to cancel this ${request.requestType.toLowerCase()} request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ServiceRequestBloc>().add(
                    CancelServiceRequestEvent(request.id),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
