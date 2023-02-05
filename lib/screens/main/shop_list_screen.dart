import '../../model/shop.dart';
import '../../provider/transaction_provider.dart';
import '../../screens/shop_edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/allProvider.dart';

class ShopListScreen extends StatefulWidget {
  const ShopListScreen({Key? key}) : super(key: key);

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  bool _isLoading = false;
  Future<void> _showDialog(Shop shop) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Confirm delete"),
            content: const Text("Are you sure ?"),
            actions: <Widget>[
              TextButton(
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator())
                    : const Text("Yes"),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<AllProvider>(context, listen: false)
                      .deleteShop(shop: shop);
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Shop> shopList = Provider.of<AllProvider>(context).allShop;
    List<Map> shopMapList = Provider.of<TransactionProvider>(context)
        .sortShopNamesWithAmt(shopList);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '  Shops',
            style: boldTextStyle(size: 16, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopEditScreen(),
                      ));
                },
                icon: const Icon(Icons.add, color: Colors.white)),
            const SizedBox(width: 10),
          ],
        ),
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(50))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 3),
                        itemCount: shopMapList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 2),
                            decoration: boxDecorationRoundedWithShadow(2),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              leading: SizedBox(
                                width: 120,
                                child: Text(
                                    '${index + 1}. ${shopMapList[index]['name']!}',
                                    // overflow: TextOverflow.visible,
                                    style: boldTextStyle(
                                        color: primaryColor,
                                        size: 14,
                                        height: 1.5)),
                              ),
                              title: Text(
                                '${shopMapList[index]['buyingProduct']}',
                                style: boldTextStyle(size: 13),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount  : ${shopMapList[index]['num'].toString()}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color: Colors.green,
                                          size: 17,
                                        ),
                                        Text(
                                          ' ${shopMapList[index]['phNo']}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 55,
                                height: 40,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopEditScreen(
                                                      shop: shopMapList[index]
                                                          ['shop']),
                                            ));
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () async {
                                        await _showDialog(
                                            shopMapList[index]['shop']);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    //const SizedBox(height: 60),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: () {
                //           // Navigator.push(
                //           //     context,
                //           //     MaterialPageRoute(
                //           //         builder: (context) => SetEditScreen()));
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(12.0),
                //           child: Text(
                //             'AddNewShop',
                //             style: primaryTextStyle(
                //                 size: 14, height: 1, color: Colors.white),
                //           ),
                //         ),
                //         style: ElevatedButton.styleFrom(
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
