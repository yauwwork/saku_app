import 'package:flutter/material.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String title;
  final int amount;
  final String type;
  final String category;
  final int date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'];
    final dateValue = json['date'];
    final num amountNum = amountValue is String
        ? num.tryParse(amountValue) ?? 0
        : (amountValue ?? 0);
    final num dateNum = dateValue is String
        ? num.tryParse(dateValue) ?? 0
        : (dateValue ?? 0);

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: amountNum.toInt(),
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      date: dateNum.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
    };
  }

  bool get isIncome => type.toLowerCase() == 'income';

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: false);

  String get formattedDate {
    final dt = dateTime;
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  IconData get displayIcon {
    switch (category.toLowerCase()) {
      case 'food':
      case 'food & drink':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'health':
        return Icons.health_and_safety;
      case 'investment':
        return Icons.monetization_on;
      case 'salary':
        return Icons.account_balance_wallet;
      default:
        return isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    }
  }

  Color get displayColor {
    switch (category.toLowerCase()) {
      case 'food':
      case 'food & drink':
        return Colors.orange;
      case 'transportation':
        return Colors.blue;
      case 'shopping':
        return Colors.green;
      case 'entertainment':
        return Colors.red;
      case 'health':
        return Colors.purple;
      case 'investment':
        return Colors.teal;
      case 'salary':
        return Colors.blue;
      default:
        return isIncome ? Colors.green : Colors.red;
    }
  }
}
