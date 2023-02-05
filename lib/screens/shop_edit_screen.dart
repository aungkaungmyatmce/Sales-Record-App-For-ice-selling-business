import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/decoration.dart';
import '../constants/style.dart';
import '../model/shop.dart';
import '../provider/allProvider.dart';

class ShopEditScreen extends StatefulWidget {
  final Shop? shop;
  const ShopEditScreen({Key? key, this.shop}) : super(key: key);

  @override
  _ShopEditScreenState createState() => _ShopEditScreenState();
}

class _ShopEditScreenState extends State<ShopEditScreen> {
  final _form = GlobalKey<FormState>();
  final _dropdownState = GlobalKey<FormFieldState>();
  final _shopNameController = TextEditingController();
  final _phNoController = TextEditingController();
  late List<String> productNames;
  late String _productName;
  bool _isLoading = false;

  @override
  void initState() {
    productNames =
        Provider.of<AllProvider>(context, listen: false).allProductNames();
    _productName = productNames.first;
    if (widget.shop != null) {
      _shopNameController.text = widget.shop!.name!;
      _phNoController.text = widget.shop!.phNo.toString();
      _productName = widget.shop!.buyingProduct!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _phNoController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState!.save();
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
    Shop sh = Shop(
        name: _shopNameController.text,
        buyingProduct: _productName,
        phNo: _phNoController.text,
        buyAmtThisMon: 0);

    await Provider.of<AllProvider>(context, listen: false)
        .addOrEditShop(oldShop: widget.shop, newShop: sh);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
          child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          decoration: boxDecorationWithRoundedCorners(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 18,
                        )),
                    Text(
                      'Add New Shop',
                      style: boldTextStyle(size: 16),
                    )
                  ],
                ),
                const Divider(thickness: 1),
                Form(
                  key: _form,
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            child: TextFormField(
                              //enabled: widget.setItem != null ? false : true,
                              controller: _shopNameController,
                              decoration:
                                  const InputDecoration(labelText: 'Shop Name'),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 60,
                            child: TextFormField(
                              controller: _phNoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Phone No',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter ph no';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 60,
                            child: DropdownButtonFormField(
                              key: _dropdownState,
                              isDense: false,
                              itemHeight: 50,
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 5.5, 0, 0),
                                  labelStyle: TextStyle(fontSize: 14),
                                  labelText: 'Buying Product'),
                              isExpanded: true,
                              items: productNames.map((String name) {
                                return DropdownMenuItem(
                                    value: name,
                                    child: Text(
                                      name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ));
                              }).toList(),
                              onChanged: (newValue) {
                                _productName = newValue.toString();
                              },
                              value: _productName,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                              onPressed: () async {
                                _onSave();
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    )
                                  : const Text('Save',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white)))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
