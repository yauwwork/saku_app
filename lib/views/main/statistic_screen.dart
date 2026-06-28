import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedIndex = 1;

  String selectedMonth = "This Month";

  final List<String> months = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];

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
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Statistics",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(14),
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
                  borderRadius:
                      BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff3B82F6),
                      Color(0xff2563EB),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "\$12,450.75",
                      style: TextStyle(
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
                            padding:
                                const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(18),
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

                                const Text(
                                  "\$8,500",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
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
                            padding:
                                const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(18),
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

                                const Text(
                                  "\$2,430",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
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
                      child: CustomPaint(
                        painter: LineChartPainter(),
                        child: Container(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Mon"),
                        Text("Tue"),
                        Text("Wed"),
                        Text("Thu"),
                        Text("Fri"),
                        Text("Sat"),
                        Text("Sun"),
                      ],
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

              _categoryTile(
                icon: Icons.restaurant,
                color: Colors.orange,
                title: "Food & Drink",
                amount: "\$820",
                percent: .82,
              ),

              const SizedBox(height: 18),

              _categoryTile(
                icon: Icons.directions_car,
                color: Colors.blue,
                title: "Transportation",
                amount: "\$560",
                percent: .56,
              ),

              const SizedBox(height: 18),

              _categoryTile(
                icon: Icons.movie,
                color: Colors.red,
                title: "Entertainment",
                amount: "\$420",
                percent: .42,
              ),

              const SizedBox(height: 18),

              _categoryTile(
                icon: Icons.shopping_bag,
                color: Colors.green,
                title: "Shopping",
                amount: "\$310",
                percent: .31,
              ),

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

class LineChartPainter extends CustomPainter {
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

    final linePaint = Paint()
      ..color = const Color(0xff2563EB)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(0, size.height * .80);
    path.quadraticBezierTo(
        size.width * .15,
        size.height * .55,
        size.width * .28,
        size.height * .62);

    path.quadraticBezierTo(
        size.width * .42,
        size.height * .75,
        size.width * .52,
        size.height * .38);

    path.quadraticBezierTo(
        size.width * .70,
        size.height * .05,
        size.width * .82,
        size.height * .22);

    path.quadraticBezierTo(
        size.width * .92,
        size.height * .35,
        size.width,
        size.height * .12);

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()
      ..color = const Color(0xff2563EB);

    final dots = [
      Offset(0, size.height * .80),
      Offset(size.width * .28, size.height * .62),
      Offset(size.width * .52, size.height * .38),
      Offset(size.width * .82, size.height * .22),
      Offset(size.width, size.height * .12),
    ];

    for (final dot in dots) {
      canvas.drawCircle(dot, 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}