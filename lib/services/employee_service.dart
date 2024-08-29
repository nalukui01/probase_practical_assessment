import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/employee.dart';
import 'auth_service.dart';

class EmployeeService extends ChangeNotifier {
  List<Employee>? _employees;
  final String baseUrl = 'http://155.138.220.54:6000/employees';
  final AuthService _authService;

  EmployeeService(this._authService);

  List<Employee>? get employees => _employees;

  Future<void> fetchEmployees() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer ${_authService.token}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _employees =
          (data['data'] as List).map((e) => Employee.fromJson(e)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(employee.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_authService.token}',
      },
    );
    if (response.statusCode == 201) {
      await fetchEmployees();
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${employee.id}'),
      body: json.encode(employee.toJson()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_authService.token}',
      },
    );
    if (response.statusCode == 200) {
      await fetchEmployees();
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer ${_authService.token}'},
    );
    if (response.statusCode == 200) {
      await fetchEmployees();
    } else {
      throw Exception('Failed to delete employee');
    }
  }
}
