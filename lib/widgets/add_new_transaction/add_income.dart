import '../../model/product.dart';
import '../../model/transaction.dart';
import '../../provider/allProvider.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../model/shop.dart';

class AddIncome extends StatefulWidget {
  final DateTime date;

  const AddIncome({Key? key, required this.date}) : super(key: key);

  @override
  _AddIncomeState createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();

  final List<TextEditingController> _customerNameController = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];
  final List<TextEditingController> _amountController = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];
  final List<TextEditingController> _priceController = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];
  final List<TextEditingController> _productController = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];
  final List<TextEditingController> _totalController = [
    for (int i = 0; i < 10; i++) TextEditingController()
  ];

  int setNum = 1;
  bool _isLoading = false;
  @override
  void dispose() {
    for (int i = 0; i < _customerNameController.length; i++) {
      _customerNameController[i].dispose();
    }
    for (int i = 0; i < _amountController.length; i++) {
      _amountController[i].dispose();
    }
    for (int i = 0; i < _priceController.length; i++) {
      _priceController[i].dispose();
    }
    for (int i = 0; i < _productController.length; i++) {
      _productController[i].dispose();
    }
    for (int i = 0; i < _totalController.length; i++) {
      _totalController[i].dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    List<Transaction> tranList = [];
    for (int i = 0; i < setNum; i++) {
      if (_totalController[i].text.isNotEmpty) {
        tranList.add(Transaction(
          customerName: _customerNameController[i].text,
          number: int.parse(_amountController[i].text),
          price: int.parse(_priceController[i].text),
          productName: _productController[i].text,
          totalPrice: int.parse(_totalController[i].text),
          sellingDate: widget.date,
          category: 'income',
        ));
      }
    }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                //shrinkWrap: true,
                children: [
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      AddIncomeWidget(
                        num: 1,
                        shopNameController: _customerNameController[0],
                        amountController: _amountController[0],
                        priceController: _priceController[0],
                        productController: _productController[0],
                        totalController: _totalController[0],
                      ),
                      if (setNum >= 2)
                        AddIncomeWidget(
                          num: 2,
                          shopNameController: _customerNameController[1],
                          amountController: _amountController[1],
                          priceController: _priceController[1],
                          productController: _productController[1],
                          totalController: _totalController[1],
                        ),
                      if (setNum >= 3)
                        AddIncomeWidget(
                          num: 3,
                          shopNameController: _customerNameController[2],
                          amountController: _amountController[2],
                          priceController: _priceController[2],
                          productController: _productController[2],
                          totalController: _totalController[2],
                        ),
                      if (setNum >= 4)
                        AddIncomeWidget(
                          num: 4,
                          shopNameController: _customerNameController[3],
                          amountController: _amountController[3],
                          priceController: _priceController[3],
                          productController: _productController[3],
                          totalController: _totalController[3],
                        ),
                      if (setNum >= 5)
                        AddIncomeWidget(
                          num: 5,
                          shopNameController: _customerNameController[4],
                          amountController: _amountController[4],
                          priceController: _priceController[4],
                          productController: _productController[4],
                          totalController: _totalController[4],
                        ),
                      if (setNum >= 6)
                        AddIncomeWidget(
                          num: 6,
                          shopNameController: _customerNameController[5],
                          amountController: _amountController[5],
                          priceController: _priceController[5],
                          productController: _productController[5],
                          totalController: _totalController[5],
                        ),
                      if (setNum >= 7)
                        AddIncomeWidget(
                          num: 7,
                          shopNameController: _customerNameController[6],
                          amountController: _amountController[6],
                          priceController: _priceController[6],
                          productController: _productController[6],
                          totalController: _totalController[6],
                        ),
                      if (setNum >= 8)
                        AddIncomeWidget(
                          num: 8,
                          shopNameController: _customerNameController[7],
                          amountController: _amountController[7],
                          priceController: _priceController[7],
                          productController: _productController[7],
                          totalController: _totalController[7],
                        ),
                      if (setNum >= 9)
                        AddIncomeWidget(
                          num: 9,
                          shopNameController: _customerNameController[8],
                          amountController: _amountController[8],
                          priceController: _priceController[8],
                          productController: _productController[8],
                          totalController: _totalController[8],
                        ),
                      if (setNum >= 10)
                        AddIncomeWidget(
                          num: 10,
                          shopNameController: _customerNameController[9],
                          amountController: _amountController[9],
                          priceController: _priceController[9],
                          productController: _productController[9],
                          totalController: _totalController[9],
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (setNum != 10)
                        IconButton(
                            onPressed: () {
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                              setState(() {
                                setNum += 1;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: primaryColor,
                            )),
                      if (setNum > 1)
                        IconButton(
                            onPressed: () {
                              for (int i = setNum - 1; i < 10; i++) {
                                _customerNameController[i].clear();
                                _amountController[i].clear();
                                _priceController[i].clear();
                                _productController[i].clear();
                              }
                              setState(() {
                                setNum -= 1;
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: primaryColor,
                            )),
                    ],
                  ),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
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
                ),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).accentColor),
            elevation: MaterialStateProperty.all(0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class AddIncomeWidget extends StatefulWidget {
  final int num;
  final TextEditingController shopNameController;
  final TextEditingController amountController;
  final TextEditingController priceController;
  final TextEditingController productController;
  final TextEditingController totalController;

  const AddIncomeWidget({
    Key? key,
    required this.num,
    required this.shopNameController,
    required this.amountController,
    required this.priceController,
    required this.productController,
    required this.totalController,
  }) : super(key: key);

  @override
  _AddIncomeWidgetState createState() => _AddIncomeWidgetState();
}

class _AddIncomeWidgetState extends State<AddIncomeWidget> {
  final _amountFocusNode = FocusNode();
  String? _productName;

  @override
  Widget build(BuildContext context) {
    List<Shop> shopList = Provider.of<AllProvider>(context).allShop;
    List<String?> shopNames = shopList.map((shop) => shop.name).toList();
    shopNames = Provider.of<TransactionProvider>(context, listen: false)
        .sortShopNames(shopNames);
    List<Product> productList = Provider.of<AllProvider>(context).allProduct;
    List<String?> names = productList.map((product) => product.name).toList();
    List<String> productNames = names.cast<String>();
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(top: 10, bottom: 14, left: 7, right: 7),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${widget.num.toString()}.', style: boldTextStyle()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name', style: boldTextStyle(size: 14)),
                  Stack(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: TextField(
                          controller: widget.shopNameController,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          top: 4,
                          child: PopupMenuButton(
                            icon: const Icon(
                              Icons.expand_more,
                            ),
                            itemBuilder: (context) => shopNames
                                .map((text) => PopupMenuItem(
                                      child: Text(text!),
                                      value: text,
                                    ))
                                .toList(),
                            onSelected: (String text) {
                              widget.shopNameController.text = text;
                              Shop shop = shopList
                                  .firstWhere((shop) => shop.name == text);
                              _productName = productNames.firstWhere(
                                  (prod) => prod == shop.buyingProduct);
                              widget.productController.text =
                                  _productName.toString();
                              Product prod = productList.firstWhere(
                                  (prod) => prod.name == _productName);
                              widget.priceController.text =
                                  prod.price.toString();
                              FocusScope.of(context)
                                  .requestFocus(_amountFocusNode);
                            },
                          )),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product', style: boldTextStyle(size: 14)),
                  SizedBox(
                    width: 120,
                    height: 50,
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      items: productNames.map((String name) {
                        return DropdownMenuItem(
                            value: name,
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13.5, height: 1),
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        widget.productController.text = newValue.toString();
                        Product prod = productList
                            .firstWhere((prod) => prod.name == newValue);
                        widget.priceController.text = prod.price.toString();
                        if (widget.priceController.text.isNotEmpty &&
                            widget.amountController.text.isNotEmpty) {
                          widget.totalController.text =
                              (int.parse(widget.priceController.text) *
                                      int.parse(widget.amountController.text))
                                  .toString();
                        }
                        FocusScope.of(context).requestFocus(_amountFocusNode);
                      },
                      value: _productName,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: boldTextStyle(size: 14)),
                    SizedBox(
                      height: 30,
                      width: 65,
                      child: TextField(
                        focusNode: _amountFocusNode,
                        controller: widget.amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(),
                        onChanged: (value) {
                          if (widget.priceController.text.isNotEmpty &&
                              value.isNotEmpty) {
                            widget.totalController.text =
                                (int.parse(widget.priceController.text) *
                                        int.parse(value))
                                    .toString();
                          } else {
                            widget.totalController.text = '';
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price', style: boldTextStyle(size: 14)),
                    SizedBox(
                      height: 30,
                      width: 65,
                      child: TextField(
                          controller: widget.priceController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          decoration: const InputDecoration(),
                          onChanged: (value) {
                            if (widget.priceController.text.isNotEmpty &&
                                value.isNotEmpty) {
                              widget.totalController.text =
                                  (int.parse(widget.amountController.text) *
                                          int.parse(value))
                                      .toString();
                            } else {
                              widget.totalController.text = '';
                            }
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total', style: boldTextStyle(size: 14)),
                    SizedBox(
                      height: 30,
                      width: 65,
                      child: TextField(
                        controller: widget.totalController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(),
                      ),
                    ),
                  ],
                ),
              ),
              //const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

// SizedBox(
// width: 150,
// height: 50,
// child: DropdownButtonFormField(
// isExpanded: true,
// items: shopNames.map((String name) {
// return DropdownMenuItem(
// value: name,
// child: Text(
// name,
// overflow: TextOverflow.ellipsis,
// style: const TextStyle(
// fontSize: 13.5,
// ),
// ));
// }).toList(),
// onChanged: (newValue) {
// setState(() {
// _shopName = newValue.toString();
// widget.shopNameController.text = _shopName.toString();
// Shop shop = shopList
//     .firstWhere((shop) => shop.name == newValue);
// _productName = productNames
//     .firstWhere((prod) => prod == shop.buyingProduct);
// widget.shopNameController.text = _shopName.toString();
// widget.productController.text =
// _productName.toString();
// Product prod = productList
//     .firstWhere((prod) => prod.name == _productName);
// widget.priceController.text = prod.price.toString();
// FocusScope.of(context).requestFocus(_amountFocusNode);
// });
// },
// value: _shopName,
// ),
// )
