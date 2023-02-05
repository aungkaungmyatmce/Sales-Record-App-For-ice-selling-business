import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String? tranId;
  final String? productName;
  final String? customerName;
  final DateTime? sellingDate;
  final int? number;
  final int? price;
  final String? category;
  final int? totalPrice;

  Transaction(
      {this.tranId,
      this.productName,
      this.category,
      this.customerName,
      this.sellingDate,
      this.number,
      this.price,
      this.totalPrice});

  factory Transaction.fromJson(QueryDocumentSnapshot json) {
    Map<String, dynamic> jsonData = json.data() as Map<String, dynamic>;
    return Transaction(
      tranId: json.id,
      productName: jsonData['product_name'],
      category: jsonData['category'],
      customerName: jsonData['customer_name'],
      sellingDate: DateTime.parse(jsonData['selling_date'].toDate().toString()),
      number: jsonData['number'],
      price: jsonData['price'],
      totalPrice: jsonData['total_price'],
    );
  }

  Map<String, dynamic> toJson(Transaction tran) {
    return <String, dynamic>{
      'product_name': tran.productName,
      'category': tran.category,
      'customer_name': tran.customerName,
      'selling_date': tran.sellingDate,
      'number': tran.number,
      'price': tran.price,
      'total_price': tran.totalPrice,
    };
  }
}
