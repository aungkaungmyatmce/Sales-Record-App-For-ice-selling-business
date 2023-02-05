import 'package:provider/provider.dart';

import '../../constants/decoration.dart';
import 'package:flutter/material.dart';

import '../../model/transaction.dart';
import '../../provider/transaction_provider.dart';

class AddExpense extends StatefulWidget {
  final DateTime date;
  const AddExpense({Key? key, required this.date}) : super(key: key);

  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _form = GlobalKey<FormState>();
  final _expenseNameController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  final _expenseNoteController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _noteFocusNode = FocusNode();
  bool _isLoading = false;
  List<String> sugNames = [];
  List<String> categoryNames = [];

  @override
  void dispose() {
    _expenseNameController.dispose();
    _expenseAmountController.dispose();
    _expenseNoteController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    List<Transaction> tranList = [];
    tranList.add(Transaction(
      customerName: _expenseNameController.text,
      number: 1,
      price: null,
      productName: _expenseNoteController.text.isNotEmpty
          ? _expenseNoteController.text
          : null,
      totalPrice: int.parse(_expenseAmountController.text),
      sellingDate: widget.date,
      category: 'expense',
    ));

    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    });

    if (tranList.isNotEmpty) {
      await Provider.of<TransactionProvider>(context, listen: false)
          .addIncome(tranList, widget.date);
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            //padding: EdgeInsets.only(top: 10, bottom: 14, left: 7, right: 7),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _expenseNameController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: 'Name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    focusNode: _amountFocusNode,
                    controller: _expenseAmountController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 14),
                      labelText: 'Amount',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: _expenseNoteController,
                    focusNode: _noteFocusNode,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(fontSize: 14),
                      labelText: 'Note',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: _onSave,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ))
        ],
      ),
    );
  }
}
