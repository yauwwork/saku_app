import 'package:flutter/material.dart';
import 'package:saku_app/views/main/add_transaction_screen.dart';
import 'package:saku_app/views/main/profil_screen.dart';
import 'package:saku_app/views/main/statistic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<TransactionModel> transactions = [
    TransactionModel(
      title: "Spotify Premium",
      category: "Entertainment",
      amount: -59000,
      icon: Icons.music_note,
      color: Colors.green,
      date: "Today",
    ),
    TransactionModel(
      title: "Salary",
      category: "Income",
      amount: 8500000,
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      date: "Yesterday",
    ),
    TransactionModel(
      title: "Starbucks",
      category: "Food",
      amount: -78000,
      icon: Icons.local_cafe,
      color: Colors.orange,
      date: "Yesterday",
    ),
    TransactionModel(
      title: "Netflix",
      category: "Subscription",
      amount: -169000,
      icon: Icons.movie,
      color: Colors.red,
      date: "Apr 20",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2563EB),
        elevation: 5,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              ///================ HEADER =================
              Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: const DecorationImage(
                        image: NetworkImage("https://i.pravatar.cc/150"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Good Morning 👋",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Muhamad Wahyu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.notifications_none, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              ///============= BALANCE CARD =============
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xff3B82F6), Color(0xff2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: const [
                        Text(
                          "Total Balance",
                          style: TextStyle(color: Colors.white70, fontSize: 17),
                        ),

                        Spacer(),

                        Icon(Icons.more_horiz, color: Colors.white),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "\$12,450.75",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: _balanceItem(
                            icon: Icons.arrow_downward,
                            title: "Income",
                            amount: "\$8,500",
                            iconColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _balanceItem(
                            icon: Icons.arrow_upward,
                            title: "Expense",
                            amount: "\$2,430",
                            iconColor: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(
                    //         padding: const EdgeInsets.all(15),

                    //         decoration: BoxDecoration(
                    //           color: Colors.white24,
                    //           borderRadius: BorderRadius.circular(18),
                    //         ),

                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               height: 45,
                    //               width: 45,
                    //               decoration: const BoxDecoration(
                    //                 color: Colors.white,
                    //                 shape: BoxShape.circle,
                    //               ),
                    //               child: const Icon(
                    //                 Icons.arrow_downward,
                    //                 color: Colors.green,
                    //               ),
                    //             ),

                    //             const SizedBox(width: 12),

                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: const [
                    //                 Text(
                    //                   "Income",
                    //                   style: TextStyle(color: Colors.white70),
                    //                 ),

                    //                 SizedBox(height: 4),

                    //                 Text(
                    //                   "\$8,500",
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 18,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),

                    //     const SizedBox(width: 16),

                    //     Expanded(
                    //       child: Container(
                    //         padding: const EdgeInsets.all(15),

                    //         decoration: BoxDecoration(
                    //           color: Colors.white24,
                    //           borderRadius: BorderRadius.circular(18),
                    //         ),

                    //         child: Row(
                    //           children: [
                    //             Container(
                    //               height: 45,
                    //               width: 45,
                    //               decoration: const BoxDecoration(
                    //                 color: Colors.white,
                    //                 shape: BoxShape.circle,
                    //               ),
                    //               child: const Icon(
                    //                 Icons.arrow_upward,
                    //                 color: Colors.red,
                    //               ),
                    //             ),

                    //             const SizedBox(width: 12),

                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,

                    //               children: const [
                    //                 Text(
                    //                   "Expense",
                    //                   style: TextStyle(color: Colors.white70),
                    //                 ),

                    //                 SizedBox(height: 4),

                    //                 Text(
                    //                   "\$2,430",
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontSize: 18,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              ///================ QUICK ACTION =================
              Row(
                children: [
                  Expanded(
                    child: _actionCard(
                      icon: Icons.arrow_downward,
                      title: "Income",
                      subtitle: "Add Income",
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _actionCard(
                      icon: Icons.arrow_upward,
                      title: "Expense",
                      subtitle: "Add Expense",
                      color: Colors.red,
                    ),
                  ),
                  // const SizedBox(width: 14),
                  // Expanded(
                  //   child: _actionCard(
                  //     icon: Icons.swap_horiz,
                  //     title: "Transfer",
                  //     subtitle: "Transfer",
                  //     color: Colors.orange,
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: 30),

              ///================ RECENT TRANSACTION =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        color: Color(0xff2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ListView.separated(
                itemCount: transactions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = transactions[index];

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
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item.icon, color: item.color, size: 28),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.amount > 0
                                  ? "+ \$${item.amount}"
                                  : "- \$${item.amount.abs()}",
                              style: TextStyle(
                                color: item.amount > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.date,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceItem({
    required IconData icon,
    required String title,
    required String amount,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),

            const SizedBox(height: 5),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionModel {
  final String title;
  final String category;
  final int amount;
  final IconData icon;
  final Color color;
  final String date;

  TransactionModel({
    required this.title,
    required this.category,
    required this.amount,
    required this.icon,
    required this.color,
    required this.date,
  });
}
