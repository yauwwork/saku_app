import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final TransactionModel transaction;

  const DeleteTransactionDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == "income";

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Warning Icon
            Container(
              width: 86,
              height: 86,
              decoration: const BoxDecoration(
                color: Color(0xffffe3e3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xffc1121f),
                size: 46,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Hapus transaksi ini?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const Text(
              "Tindakan ini tidak dapat dibatalkan.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 19),
            ),

            const SizedBox(height: 28),

            /// Transaction Preview
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xffF6F8FC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xffD8E0EF)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xffDCEAFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward
                          : Icons.shopping_bag_outlined,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Text(
                    "${isIncome ? "+" : "-"}Rp ${transaction.amount}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isIncome ? Colors.green : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 58,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffC9D1E8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffC81414),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Hapus",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
