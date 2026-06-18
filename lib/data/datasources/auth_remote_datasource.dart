import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/models/user_model.dart';

class AuthRemoteDatasource {
  final http.Client client;

  AuthRemoteDatasource(this.client);

  Future<UserModel> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 400) {
      throw Exception('Usuário ou senha inválidos');
    }
    if (response.statusCode != 200) {
      throw Exception('Erro no servidor: ${response.statusCode}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return UserModel.fromJson(json as Map<String, dynamic>);
  }
}
