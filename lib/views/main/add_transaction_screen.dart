import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';
import 'package:saku_app/core/networks/api_service.dart';
import 'package:saku_app/core/session/user_session.dart';
import 'package:saku_app/views/main/main_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isIncome = true;
  bool isLoading = false;

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = "Salary";

  final categories = [
    "Salary",
    "Food",
    "Shopping",
    "Transportation",
    "Entertainment",
    "Health",
    "Gift",
    "Investment",
  ];

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = isIncome ? const Color(0xff2563EB) : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xffEEF3FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Transaction",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 22,
          ),
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor.withOpacity(.15), const Color(0xffEEF3FA)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),

            child: Form(
              key: _formKey,

              child: Container(
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: primaryColor.withOpacity(.12),
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 38,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: Text(
                        isIncome ? "Income" : "Expense",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.all(5),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isIncome = true;
                                });
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),

                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                decoration: BoxDecoration(
                                  color: isIncome
                                      ? primaryColor
                                      : Colors.transparent,

                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: Text(
                                  "Income",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isIncome
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isIncome = false;
                                });
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),

                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),

                                decoration: BoxDecoration(
                                  color: !isIncome
                                      ? Colors.red
                                      : Colors.transparent,

                                  borderRadius: BorderRadius.circular(14),
                                ),

                                child: Text(
                                  "Expense",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !isIncome
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.payments_rounded,
                          color: primaryColor,
                        ),

                        prefixText: "Rp ",

                        hintText: "0",

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Amount is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,

                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.category_rounded,
                          color: primaryColor,
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),

                      items: categories.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),

                      onChanged: (v) {
                        setState(() {
                          selectedCategory = v!;
                        });
                      },
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      borderRadius: BorderRadius.circular(18),

                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(18),
                        ),

                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: primaryColor,
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Text(
                                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Notes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: noteController,
                      maxLines: 4,

                      decoration: InputDecoration(
                        hintText: "Write description...",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 70),
                          child: Icon(
                            Icons.edit_note_rounded,
                            color: primaryColor,
                          ),
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton.icon(
                        icon: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                              ),

                        label: Text(
                          isLoading
                              ? "Saving..."
                              : (isIncome ? "Save Income" : "Save Expense"),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(.35),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                if (UserSession.currentUser == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "User tidak ditemukan. Silakan login ulang.",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final parsedAmount = int.tryParse(
                                  amountController.text.trim(),
                                );

                                if (parsedAmount == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Masukkan jumlah yang valid",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                final transaction = TransactionModel(
                                  id: '',
                                  userId: UserSession.currentUser!.id,

                                  title: noteController.text.trim().isEmpty
                                      ? selectedCategory
                                      : noteController.text.trim(),

                                  amount: parsedAmount,

                                  type: isIncome ? 'income' : 'expense',

                                  category: selectedCategory,

                                  date:
                                      selectedDate.millisecondsSinceEpoch ~/
                                      1000,
                                );

                                try {
                                  await ApiService.createTransaction(
                                    transaction: transaction,
                                  );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      content: Text(
                                        isIncome
                                            ? "Income Added Successfully 🎉"
                                            : "Expense Added Successfully 🎉",
                                      ),
                                    ),
                                  );

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainScreen(),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      content: Text(
                                        "Gagal menyimpan transaksi\n${e.toString()}",
                                      ),
                                    ),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: Text(
                        isIncome
                            ? "Track your income and grow your savings 💰"
                            : "Control your spending wisely 💳",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
