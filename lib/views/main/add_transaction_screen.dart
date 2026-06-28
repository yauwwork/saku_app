import 'package:flutter/material.dart';
import 'package:saku_app/core/models/transaction_model.dart';
import 'package:saku_app/core/networks/api_service.dart';
import 'package:saku_app/core/session/user_session.dart';
import 'package:saku_app/views/main/main_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {

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

    return Scaffold(

      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new,
        //     color: Colors.black,
        //   ),
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        // ),
        title: const Text(
          "Add Transaction",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(22),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              Container(

                padding: const EdgeInsets.all(5),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: Row(

                  children: [

                    Expanded(
                      child: GestureDetector(

                        onTap: (){
                          setState(() {
                            isIncome=true;
                          });
                        },

                        child: Container(

                          padding: const EdgeInsets.symmetric(
                            vertical:16,
                          ),

                          decoration: BoxDecoration(

                            color: isIncome
                                ? const Color(0xff2563EB)
                                : Colors.transparent,

                            borderRadius:
                                BorderRadius.circular(14),

                          ),

                          child: Text(

                            "Income",

                            textAlign: TextAlign.center,

                            style: TextStyle(

                              color: isIncome
                                  ? Colors.white
                                  : Colors.black,

                              fontWeight:
                                  FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(

                        onTap: (){
                          setState(() {
                            isIncome=false;
                          });
                        },

                        child: Container(

                          padding: const EdgeInsets.symmetric(
                            vertical:16,
                          ),

                          decoration: BoxDecoration(

                            color: !isIncome
                                ? Colors.red
                                : Colors.transparent,

                            borderRadius:
                                BorderRadius.circular(14),

                          ),

                          child: Text(

                            "Expense",

                            textAlign: TextAlign.center,

                            style: TextStyle(

                              color: !isIncome
                                  ? Colors.white
                                  : Colors.black,

                              fontWeight:
                                  FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height:30),

              TextFormField(

                controller: amountController,

                keyboardType:
                    TextInputType.number,

                style: const TextStyle(
                  fontSize:28,
                  fontWeight: FontWeight.bold,
                ),

                decoration: InputDecoration(

                  prefixText: "\$ ",

                  hintText: "0.00",

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),

                ),

                validator: (value){

                  if(value==null||value.isEmpty){
                    return "Amount is required";
                  }

                  return null;

                },

              ),

              const SizedBox(height:24),

              DropdownButtonFormField<String>(

                value: selectedCategory,

                decoration: InputDecoration(

                  labelText: "Category",

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(18),

                  ),

                ),

                items: categories.map((e){

                  return DropdownMenuItem(

                    value:e,

                    child: Text(e),

                  );

                }).toList(),

                onChanged: (v){

                  setState(() {

                    selectedCategory=v!;

                  });

                },

              ),

              const SizedBox(height:24),

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color(0xff2563EB),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Notes",
                  hintText: "Write description...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isIncome
                        ? const Color(0xff2563EB)
                        : Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
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
                                content: Text('User tidak ditemukan. Silakan login ulang.'),
                              ),
                            );
                            return;
                          }

                          final parsedAmount = int.tryParse(amountController.text.trim());
                          if (parsedAmount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Masukkan jumlah yang valid'),
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
                            date: selectedDate.millisecondsSinceEpoch ~/ 1000,
                          );

                          try {
                            await ApiService.createTransaction(transaction: transaction);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    isIncome ? Colors.green : Colors.red,
                                content: Text(
                                  isIncome
                                      ? "Income Added Successfully"
                                      : "Expense Added Successfully",
                                ),
                              ),
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal menyimpan transaksi: ${e.toString()}'),
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
                  child: Text(
                    isIncome
                        ? "Save Income"
                        : "Save Expense",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}