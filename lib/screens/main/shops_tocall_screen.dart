import '../../provider/allProvider.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';

class ShopsToCallScreen extends StatefulWidget {
  const ShopsToCallScreen({Key? key}) : super(key: key);

  @override
  _ShopsToCallScreenState createState() => _ShopsToCallScreenState();
}

class _ShopsToCallScreenState extends State<ShopsToCallScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> shopList =
        Provider.of<TransactionProvider>(context).shopsToCall();
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          //margin: EdgeInsets.only(top: 90),
          decoration: boxDecorationWithRoundedCorners(
              borderRadius:
                  const BorderRadius.only(topRight: Radius.circular(32))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        'Shops to Call',
                        style: boldTextStyle(size: 18),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: Colors.lightBlue.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Icon(
                        Icons.phone_forwarded_rounded,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                //Divider(thickness: 1),
                const SizedBox(height: 30),
                if (shopList.isEmpty)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text('No Shops to call!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.lightBlue,
                        )),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: ListView.separated(
                      itemCount: shopList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        DateTime currentTime = DateTime.now().subtract(
                            Duration(days: shopList[index]['last order']));
                        String curTime = DateFormat.yMMMd().format(currentTime);
                        return Container(
                          height: 105,
                          margin: const EdgeInsets.all(3),
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecorationRoundedWithShadow(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  //SizedBox(width: 50),
                                  Text(
                                    shopList[index]['name'],
                                    style: boldTextStyle(size: 15),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      String? phNo = Provider.of<AllProvider>(
                                              context,
                                              listen: false)
                                          .getShopPhNo(shopList[index]['name']);

                                      String url = 'tel:' + phNo.toString();
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: const Icon(
                                      Icons.phone,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Last Order   : ',
                                    style: primaryTextStyle(size: 14),
                                  ),
                                  Text(
                                      shopList[index]['last order'] == 1
                                          ? 'Yesterday'
                                          : '${shopList[index]['last order'].toString()} days ago',
                                      style: primaryTextStyle(
                                          height: 1.3,
                                          size: 14,
                                          color: Colors.lightBlue)),
                                  if (shopList[index]['last order'] != 1)
                                    Text(' (${curTime})',
                                        style: primaryTextStyle(
                                            height: 1.3,
                                            size: 14,
                                            color: Colors.lightBlue)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Order Habit : ',
                                    style: primaryTextStyle(size: 14),
                                  ),
                                  Text(
                                    shopList[index]['order habit'] == 1
                                        ? 'EveryDay'
                                        : 'Every ${shopList[index]['order habit'].toString()} days',
                                    style: primaryTextStyle(
                                        height: 1.3,
                                        size: 14,
                                        color: Colors.lightBlue),
                                  ),
                                ],
                              ),
                              //SizedBox(height: 3),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
