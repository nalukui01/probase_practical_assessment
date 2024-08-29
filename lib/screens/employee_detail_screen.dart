import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/employee_service.dart';
import '../models/employee.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  EmployeeDetailScreenState createState() => EmployeeDetailScreenState();
}

class EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late Employee _employee;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final employeeService =
          Provider.of<EmployeeService>(context, listen: false);
      try {
        if (_employee.id == null) {
          await employeeService.createEmployee(_employee);
        } else {
          await employeeService.updateEmployee(_employee);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee saved successfully')),
          );
          Navigator.of(context).pop(); // Navigate back to the list screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save employee: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_employee.id == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _employee.firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value!.isEmpty ? 'First name is required' : null,
                onSaved: (value) => _employee.firstName = value!,
              ),
              TextFormField(
                initialValue: _employee.lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Last name is required' : null,
                onSaved: (value) => _employee.lastName = value!,
              ),
              TextFormField(
                initialValue: _employee.email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
                onSaved: (value) => _employee.email = value!,
              ),
              TextFormField(
                initialValue: _employee.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _employee.phone = value ?? '',
              ),
              TextFormField(
                initialValue: _employee.countryCode,
                decoration: const InputDecoration(labelText: 'Country Code'),
                onSaved: (value) => _employee.countryCode = value ?? '',
              ),
              TextFormField(
                initialValue: _employee.salary.toString(),
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Salary is required' : null,
                onSaved: (value) => _employee.salary = double.parse(value!),
              ),
              DropdownButtonFormField<String>(
                value: _employee.gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _employee.gender = value!),
              ),
              TextFormField(
                initialValue: _employee.department,
                decoration: const InputDecoration(labelText: 'Department'),
                onSaved: (value) => _employee.department = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
