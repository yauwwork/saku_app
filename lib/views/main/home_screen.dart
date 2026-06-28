import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';
import 'package:saku_app/core/networks/api_service.dart';
import 'package:saku_app/core/session/user_session.dart';
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

  List<TransactionModel> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (UserSession.currentUser == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

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
      setState(() {
        isLoading = false;
      });
    }
  }

  int get totalIncome {
    return transactions.fold<int>(0, (sum, item) {
      return sum + (item.type.toLowerCase() == 'income' ? item.amount : 0);
    });
  }

  int get totalExpense {
    return transactions.fold<int>(0, (sum, item) {
      return sum + (item.type.toLowerCase() == 'expense' ? item.amount : 0);
    });
  }

  int get totalBalance {
    return transactions.fold<int>(0, (sum, item) {
      return sum + (item.type.toLowerCase() == 'income' ? item.amount : -item.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff2563EB),
        elevation: 5,
        onPressed: () async {
          final result = await Navigator.push<bool?>(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          if (result == true) {
            _loadTransactions();
          }
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
                      image: DecorationImage(
                        image: NetworkImage(
                          UserSession.currentUser?.avatar ?? 'https://i.pravatar.cc/150',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Good Morning 👋",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          UserSession.currentUser?.name ?? 'Guest',
                          style: const TextStyle(
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

                    Text(
                      '\$${totalBalance.toString()}',
                      style: const TextStyle(
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
                            amount: "\$${totalIncome}",
                            iconColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _balanceItem(
                            icon: Icons.arrow_upward,
                            title: "Expense",
                            amount: "\$${totalExpense}",
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

              if (isLoading) ...[
                const SizedBox(height: 24),
                const Center(child: CircularProgressIndicator()),
              ] else if (transactions.isEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    'Tidak ada transaksi untuk saat ini',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ] else ...[
                ListView.separated(
                  itemCount: transactions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    final isIncome = item.type.toLowerCase() == 'income';

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
                            color: item.displayColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item.displayIcon, color: item.displayColor, size: 28),
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
                              isIncome
                                  ? "+ \$${item.amount}"
                                  : "- \$${item.amount}",
                              style: TextStyle(
                                color: isIncome ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.formattedDate,
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
            ],]
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

