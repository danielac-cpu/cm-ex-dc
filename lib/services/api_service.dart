import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _host = "143.198.118.203";
  static const int _port = 8100;

  static const String _user = "test";
  static const String _pass = "test2023";

  String get _basicAuth =>
      'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';

  Map<String, String> get _headers => {
    'Authorization': _basicAuth,
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    'Accept-Encoding': 'identity',
    'Connection': 'close',
    'User-Agent': 'cm-ex-app/1.0',
  };

  Uri _uri(String path) =>
      Uri(scheme: 'http', host: _host, port: _port, path: path);

  Future<http.Response> get(String path) async {
    final uri = _uri(path);
    try {
      return await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('GET $uri failed: $e');
    }
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final uri = _uri(path);
    try {
      return await http
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception('POST $uri failed: $e');
    }
  }
}
