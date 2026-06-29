import 'dart:math';

import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';
import 'package:saku_app/core/networks/api_service.dart';
import 'package:saku_app/core/session/user_session.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoading = true;
  List<TransactionModel> transactions = [];

  String selectedMonth = "This Month";

  final List<String> months = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (UserSession.currentUser == null) {
      setState(() {
        isLoading = false;
        transactions = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.getTransactionsByUser(UserSession.currentUser!.id);
      setState(() {
        transactions = data;
      });
    } catch (_) {
      setState(() {
        transactions = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<TransactionModel> get filteredTransactions {
    return transactions.where(_matchesScope).toList();
  }

  bool _matchesScope(TransactionModel item) {
    final date = item.dateTime;
    final now = DateTime.now();

    switch (selectedMonth) {
      case 'Today':
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      case 'This Week':
        final weekStart = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return !date.isBefore(weekStart) && !date.isAfter(weekEnd);
      case 'This Month':
        return date.year == now.year && date.month == now.month;
      case 'This Year':
        return date.year == now.year;
      default:
        return true;
    }
  }

  int get totalIncome {
    return filteredTransactions.fold(0, (sum, item) {
      return sum + (item.isIncome ? item.amount : 0);
    });
  }

  int get totalExpense {
    return filteredTransactions.fold(0, (sum, item) {
      return sum + (item.isIncome ? 0 : item.amount);
    });
  }

  int get totalBalance => totalIncome - totalExpense;

  List<double> get incomeTrendValues {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));
      return filteredTransactions
          .where((item) =>
              item.isIncome &&
              item.dateTime.year == day.year &&
              item.dateTime.month == day.month &&
              item.dateTime.day == day.day)
          .fold<double>(0, (sum, item) => sum + item.amount.toDouble());
    });
  }

  List<double> get expenseTrendValues {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));
      return filteredTransactions
          .where((item) =>
              !item.isIncome &&
              item.dateTime.year == day.year &&
              item.dateTime.month == day.month &&
              item.dateTime.day == day.day)
          .fold<double>(0, (sum, item) => sum + item.amount.toDouble());
    });
  }

  List<String> get trendLabels {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1];
    });
  }

  List<CategoryStat> get topCategories {
    final expenses = <String, int>{};
    for (final transaction in filteredTransactions) {
      if (transaction.isIncome) continue;
      expenses[transaction.category] =
          (expenses[transaction.category] ?? 0) + transaction.amount;
    }

    final total = expenses.values.fold<int>(0, (sum, value) => sum + value);
    final sorted = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(4).map((entry) {
      return CategoryStat(
        title: entry.key,
        amount: entry.value,
        percent: total == 0 ? 0 : entry.value / total,
      );
    }).toList();
  }

  String _formatCurrency(int value) {
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  Widget _buildPeriodSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: months.map((label) {
        final isSelected = selectedMonth == label;
        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              selectedMonth = label;
            });
          },
          selectedColor: const Color(0xff2563EB),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = UserSession.currentUser;
    final topIncome = incomeTrendValues.reduce((a, b) => max(a, b));
    final topExpense = expenseTrendValues.reduce((a, b) => max(a, b));
    final graphMax = max(topIncome, topExpense).clamp(1, double.infinity);

    return Scaffold(
      backgroundColor: const Color(0xffeef2f8),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTransactions,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.name ?? 'User'}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Here is your financial overview',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.pie_chart_outline,
                        color: const Color(0xff2563EB),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _buildPeriodSelector(),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xff2563EB),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCurrency(totalBalance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              icon: Icons.arrow_downward,
                              iconColor: Colors.greenAccent,
                              label: 'Income',
                              amount: _formatCurrency(totalIncome),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildSummaryCard(
                              icon: Icons.arrow_upward,
                              iconColor: Colors.redAccent,
                              label: 'Expense',
                              amount: _formatCurrency(totalExpense),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTrendChartSection(
                  title: 'Income Trend',
                  subtitle: 'Latest 7-day income',
                  values: incomeTrendValues,
                  labels: trendLabels,
                  accentColor: const Color(0xff16a34a),
                ),
                const SizedBox(height: 24),
                _buildTrendChartSection(
                  title: 'Expense Trend',
                  subtitle: 'Latest 7-day spending',
                  values: expenseTrendValues,
                  labels: trendLabels,
                  accentColor: const Color(0xffdc2626),
                ),
                const SizedBox(height: 24),
                _sectionHeader('Top Spending', 'Biggest expense categories'),
                const SizedBox(height: 14),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (topCategories.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      'No expense categories available for this period.',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  )
                else ...topCategories.map((category) {
                  final color = _categoryColor(category.title);
                  final icon = _categoryIcon(category.title);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _categoryTile(
                      icon: icon,
                      color: color,
                      title: category.title,
                      amount: _formatCurrency(category.amount),
                      percent: category.percent,
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChartSection({
    required String title,
    required String subtitle,
    required List<double> values,
    required List<String> labels,
    required Color accentColor,
  }) {
    final total = values.fold<double>(0, (sum, value) => sum + value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title, subtitle, icon: Icons.show_chart),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatCurrency(total.toInt()),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      labels.isNotEmpty ? labels.last : '',
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 220,
                child: TrendBarChart(
                  values: values,
                  labels: labels,
                  accentColor: accentColor,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: labels
                    .map(
                      (label) => Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, String subtitle, {IconData icon = Icons.bar_chart}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Icon(
          icon,
          color: const Color(0xff2563EB),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryTile({
    required IconData icon,
    required Color color,
    required String title,
    required String amount,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(percent * 100).toStringAsFixed(0)}% of total',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
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
        return Icons.pie_chart;
    }
  }

  Color _categoryColor(String category) {
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
        return Colors.grey;
    }
  }
}

class CategoryStat {
  final String title;
  final int amount;
  final double percent;

  CategoryStat({
    required this.title,
    required this.amount,
    required this.percent,
  });
}

class TrendBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color accentColor;

  const TrendBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = values.isEmpty ? 0.0 : values.reduce(max);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(values.length, (index) {
            final heightFactor = maxValue == 0 ? 0.0 : values[index] / maxValue;
            return Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    values[index] == 0 ? '-' : values[index].toInt().toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: constraints.maxHeight * 0.62 * heightFactor + 10,
                    width: 18,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
