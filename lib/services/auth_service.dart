import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  String? _token;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? get token => _token;

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://155.138.220.54:6000/login'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['data'];
      await _storage.write(key: 'auth_token', value: _token);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://155.138.220.54:6000/register'),
      body: json.encode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    notifyListeners();
  }

  Future<String?> getToken() async {
    return _storage.read(key: 'auth_token');
  }
}
