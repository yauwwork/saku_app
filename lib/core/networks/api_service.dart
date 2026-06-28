import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/endpoint.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';

class ApiService {
  ApiService._();

  static final http.Client client = http.Client();

  static Future<List<UserModel>> getUsers() async {
    final uri = Uri.parse(Endpoint.users);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<UserModel>.from(
        (data as List).map((item) => UserModel.fromJson(item)),
      );
    }

    throw Exception('Failed to load users');
  }

  static Future<UserModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(Endpoint.users);
    final avatar =
        'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/${DateTime.now().millisecondsSinceEpoch % 70}.jpg';
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'Password': password,
        'avatar': avatar,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }

    throw Exception('Failed to register user');
  }

  static Future<UserModel?> loginUser(
    String email,
    String password,
  ) async {
    final users = await getUsers();
    try {
      return users.firstWhere(
        (user) {
          final loginKey = user.email.isNotEmpty ? user.email : user.name;
          return loginKey.toLowerCase() == email.toLowerCase() &&
              user.password == password;
        },
      );
    } catch (_) {
      return null;
    }
  }

  static Future<List<TransactionModel>> getTransactionsByUser(
      String userId) async {
    final uri = Uri.parse(Endpoint.transactions).replace(queryParameters: {
      'userId': userId,
    });
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<TransactionModel>.from(
        (data as List).map((item) => TransactionModel.fromJson(item)),
      );
    }

    throw Exception('Failed to load transactions');
  }

  static Future<TransactionModel> createTransaction({
    required TransactionModel transaction,
  }) async {
    final uri = Uri.parse(Endpoint.transactions);
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TransactionModel.fromJson(data);
    }

    throw Exception('Failed to save transaction');
  }
}
