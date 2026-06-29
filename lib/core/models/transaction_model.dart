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

  String get localizedType => isIncome ? 'Pemasukan' : 'Pengeluaran';

  String get localizedCategory {
    switch (category.toLowerCase()) {
      case 'salary':
      case 'gaji':
        return 'Gaji';
      case 'food':
      case 'food & drink':
      case 'makanan':
        return 'Makanan';
      case 'shopping':
      case 'belanja':
        return 'Belanja';
      case 'transportation':
      case 'transportasi':
        return 'Transportasi';
      case 'entertainment':
      case 'hiburan':
        return 'Hiburan';
      case 'health':
      case 'kesehatan':
        return 'Kesehatan';
      case 'gift':
      case 'hadiah':
        return 'Hadiah';
      case 'investment':
      case 'investasi':
        return 'Investasi';
      default:
        return category;
    }
  }

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
      case 'makanan':
        return Icons.restaurant;
      case 'transportation':
      case 'transportasi':
        return Icons.directions_car;
      case 'shopping':
      case 'belanja':
        return Icons.shopping_bag;
      case 'entertainment':
      case 'hiburan':
        return Icons.movie;
      case 'health':
      case 'kesehatan':
        return Icons.health_and_safety;
      case 'investment':
      case 'investasi':
        return Icons.monetization_on;
      case 'salary':
      case 'gaji':
        return Icons.account_balance_wallet;
      case 'gift':
      case 'hadiah':
        return Icons.card_giftcard;
      default:
        return isIncome ? Icons.arrow_downward : Icons.arrow_upward;
    }
  }

  Color get displayColor {
    switch (category.toLowerCase()) {
      case 'food':
      case 'food & drink':
      case 'makanan':
        return Colors.orange;
      case 'transportation':
      case 'transportasi':
        return Colors.blue;
      case 'shopping':
      case 'belanja':
        return Colors.green;
      case 'entertainment':
      case 'hiburan':
        return Colors.red;
      case 'health':
      case 'kesehatan':
        return Colors.purple;
      case 'investment':
      case 'investasi':
        return Colors.teal;
      case 'salary':
      case 'gaji':
        return Colors.blue;
      case 'gift':
      case 'hadiah':
        return Colors.pink;
      default:
        return isIncome ? Colors.green : Colors.red;
    }
  }
}
