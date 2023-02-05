import '../../model/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/decoration.dart';
import '../constants/style.dart';
import '../provider/allProvider.dart';

class ProductEditScreen extends StatefulWidget {
  final Product? product;
  const ProductEditScreen({Key? key, this.product}) : super(key: key);

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _form = GlobalKey<FormState>();
  final _dropdownState = GlobalKey<FormFieldState>();
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    if (widget.product != null) {
      _productNameController.text = widget.product!.name!;
      _priceController.text = widget.product!.price.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
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
    Product pro = Product(
      name: _productNameController.text,
      price: int.parse(_priceController.text),
    );

    await Provider.of<AllProvider>(context, listen: false)
        .addOrEditProduct(oldProduct: widget.product, newProduct: pro);

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
                      'Add New Product',
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
                              controller: _productNameController,
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
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price',
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
