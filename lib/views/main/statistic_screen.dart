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

  List<double> get trendValues {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - index));
      return filteredTransactions
          .where((item) =>
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
    return '\$${value.toString()}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              ///================ HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Statistics",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: months.map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value!;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 28),

              ///================ SUMMARY CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff3B82F6),
                      Color(0xff2563EB),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _formatCurrency(totalBalance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.greenAccent,
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Income",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatCurrency(totalIncome),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Expense",
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _formatCurrency(totalExpense),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ///================ EXPENSE TREND =================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Expense Trend",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                height: 240,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredTransactions.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Belum ada data transaksi untuk periode ini',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : CustomPaint(
                                  painter: LineChartPainter(trendValues),
                                  child: Container(),
                                ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: trendLabels
                          .map(
                            (label) => Text(
                              label,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              ///================ CATEGORIES =================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Top Spending",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (topCategories.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    'Tidak ada kategori pengeluaran untuk periode ini',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              else ...topCategories.map((category) {
                final icon = _categoryIcon(category.title);
                final color = _categoryColor(category.title);
                return Column(
                  children: [
                    _categoryTile(
                      icon: icon,
                      color: color,
                      title: category.title,
                      amount: _formatCurrency(category.amount),
                      percent: category.percent,
                    ),
                    const SizedBox(height: 18),
                  ],
                );
              }).toList(),

              const SizedBox(height: 90),
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
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

class LineChartPainter extends CustomPainter {
  final List<double> values;

  LineChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (double y = 0; y <= size.height; y += size.height / 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    if (values.isEmpty) {
      return;
    }

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final range = (maxValue - minValue).abs();
    final linePaint = Paint()
      ..color = const Color(0xff2563EB)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final dx = size.width * (i / (values.length - 1));
      final safeValue = values[i] - minValue;
      final dy = size.height -
          (range == 0 ? size.height / 2 : (safeValue / range) * size.height);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xff2563EB);
    for (var i = 0; i < values.length; i++) {
      final dx = size.width * (i / (values.length - 1));
      final safeValue = values[i] - minValue;
      final dy = size.height -
          (range == 0 ? size.height / 2 : (safeValue / range) * size.height);
      canvas.drawCircle(Offset(dx, dy), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
