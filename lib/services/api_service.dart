import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? token;

  ApiService(this.baseUrl);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body);
  }

  Future<List<dynamic>> getProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/products'), headers: _headers);
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: _headers,
      body: jsonEncode(product),
    );
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> product) async {
    final res = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers,
      body: jsonEncode(product),
    );
    if (res.statusCode != 200) throw Exception(res.body);
    return jsonDecode(res.body);
  }

  Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/products/$id'), headers: _headers);
    if (res.statusCode != 200) throw Exception(res.body);
  }
}
