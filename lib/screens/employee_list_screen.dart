import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/employee_service.dart';
import '../models/employee.dart';
import 'employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  EmployeeListScreenState createState() => EmployeeListScreenState();
}

class EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeService>().fetchEmployees();
    });
  }

  Future<void> _refreshEmployees() async {
    await context.read<EmployeeService>().fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshEmployees,
          ),
        ],
      ),
      body: Consumer<EmployeeService>(
        builder: (context, employeeService, child) {
          if (employeeService.employees == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (employeeService.employees!.isEmpty) {
            return const Center(child: Text('No employees found'));
          }
          return ListView.builder(
            itemCount: employeeService.employees!.length,
            itemBuilder: (context, index) {
              final employee = employeeService.employees![index];
              return ListTile(
                title: Text('${employee.firstName} ${employee.lastName}'),
                subtitle: Text(employee.email),
                onTap: () => _navigateToEmployeeDetail(context, employee),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEmployeeDetail(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEmployeeDetail(
      BuildContext context, Employee? employee) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EmployeeDetailScreen(employee: employee ?? Employee()),
      ),
    );

    if (result == true) {
      // Employee was added or updated, refresh the list
      _refreshEmployees();
    }
  }
}
