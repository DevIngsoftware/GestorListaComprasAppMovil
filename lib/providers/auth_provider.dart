import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? token;
  String? email;
  String? name;
  late ApiService api;

  AuthProvider() {
    api = ApiService('http://10.0.0.202:3005/api/v1'); // Cambia tu URL de API
    _loadToken();
  }

  bool get isAuthenticated => token != null && token!.isNotEmpty;

  Future<void> _loadToken() async {
    token = await _storage.read(key: 'token');
    if (token != null) {
      api.token = token;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final res = await api.login(email, password);
    token = res['accessToken'] ?? res['token'];
    if (token == null) throw Exception('Token no recibido');
    api.token = token;
    await _storage.write(key: 'token', value: token);
    this.email = res['user']?['email'] ?? email;
    name = res['user']?['name'];
    notifyListeners();
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    return await api.register(name, email, password);
  }

  Future<void> logout() async {
    token = null;
    await _storage.delete(key: 'token');
    api.token = null;
    notifyListeners();
  }
}
