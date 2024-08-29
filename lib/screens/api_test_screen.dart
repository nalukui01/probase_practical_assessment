import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APITestScreen extends StatefulWidget {
  const APITestScreen({super.key});

  @override
  APITestScreenState createState() => APITestScreenState();
}

class APITestScreenState extends State<APITestScreen> {
  String _response = '';
  final String baseUrl = 'http://155.138.220.54:6000';

  Future<void> _testRegister() async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      body: json.encode({'username': 'testuser', 'password': 'testpassword'}),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _response =
          'Register Status Code: ${response.statusCode}\nBody: ${response.body}';
    });
  }

  Future<void> _testLogin() async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      body: json.encode({'username': 'testuser', 'password': 'testpassword'}),
      headers: {'Content-Type': 'application/json'},
    );

    setState(() {
      _response =
          'Login Status Code: ${response.statusCode}\nBody: ${response.body}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _testRegister,
              child: const Text('Test Register API'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testLogin,
              child: const Text('Test Login API'),
            ),
            const SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
