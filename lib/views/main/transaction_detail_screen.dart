import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// ICON
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: transaction.displayColor.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                transaction.displayIcon,
                color: transaction.displayColor,
                size: 45,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              transaction.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "${transaction.type.toLowerCase() == 'income' ? '+' : '-'} \$${transaction.amount}",
              style: TextStyle(
                fontSize: 30,
                color: transaction.type.toLowerCase() == "income"
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "Completed",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildItem(
                    "Notes",
                    transaction.title,
                    Icons.note_alt_outlined,
                  ),

                  const Divider(height: 30),

                  _buildItem(
                    "Category",
                    transaction.category,
                    Icons.category_outlined,
                  ),

                  const Divider(height: 30),

                  _buildItem(
                    "Date",
                    transaction.formattedDate,
                    Icons.calendar_today_outlined,
                  ),

                  const Divider(height: 30),

                  _buildItem("Type", transaction.type, Icons.swap_vert),
                  
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1652CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Transaction",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("Delete Transaction"),
                        content: const Text(
                          "Are you sure you want to delete this transaction?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xff1652CC)),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
