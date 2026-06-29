import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';
import 'package:saku_app/core/networks/api_service.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isIncome = true;
  bool isLoading = false;

  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = "Salary";

  final List<String> categories = [
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
  void initState() {
    super.initState();

    isIncome = widget.transaction.type == "income";

    amountController.text =
        widget.transaction.amount.toString();

    noteController.text =
        widget.transaction.title;

    selectedCategory =
        widget.transaction.category;

    selectedDate =
        DateTime.fromMillisecondsSinceEpoch(
      widget.transaction.date * 1000,
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        isIncome ? const Color(0xff2563EB) : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xffEEF3FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Transaction",
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
            colors: [
              primaryColor.withOpacity(.15),
              const Color(0xffEEF3FA),
            ],
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
                  borderRadius:
                      BorderRadius.circular(28),
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
                    Text(
                      'Transaction Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isIncome = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isIncome
                                    ? primaryColor
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isIncome
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isIncome = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: !isIncome
                                    ? Colors.red
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isIncome
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: noteController,
                      decoration: InputDecoration(
                        hintText: 'Enter title',
                        prefixIcon: const Icon(Icons.title),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: primaryColor,
                        ),
                        hintText: '0',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.category,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
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
                              Icons.calendar_today,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade700,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

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
                              ? 'Updating...'
                              : 'Update Transaction',
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

                                final parsedAmount = int.tryParse(
                                  amountController.text.trim(),
                                );

                                if (parsedAmount == null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Masukkan jumlah yang valid',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  isLoading = true;
                                });

                                try {
                                  final updatedTransaction =
                                      TransactionModel(
                                    id: widget.transaction.id,
                                    userId: widget.transaction.userId,
                                    title: noteController.text.trim(),
                                    amount: parsedAmount,
                                    type: isIncome ? 'income' : 'expense',
                                    category: selectedCategory,
                                    date:
                                        selectedDate.millisecondsSinceEpoch ~/
                                            1000,
                                  );

                                  await ApiService.updateTransaction(
                                    transaction: updatedTransaction,
                                  );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      content: const Text(
                                        'Transaction updated successfully 🎉',
                                      ),
                                    ),
                                  );

                                  Navigator.pop(context, true);
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      content: Text(e.toString()),
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
    "Update your transaction whenever needed ✨",
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
      color:
          primaryColor.withOpacity(.25),
      borderRadius:
          BorderRadius.circular(20),
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