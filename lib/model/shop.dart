import 'package:cloud_firestore/cloud_firestore.dart';

class Shop {
  final String? name;
  final String? buyingProduct;
  final String? phNo;
  final int? buyAmtThisMon;

  Shop(
      { this.name,
       this.buyingProduct,
       this.phNo,
       this.buyAmtThisMon});

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
        name: json['name'],
        buyingProduct: json['buyingProduct'],
        phNo: json['phNo'],
        buyAmtThisMon: json['buyAmtThisMon']);
  }

  Map<String, dynamic> toJson(Shop shop) {
    return <String, dynamic>{
      'name': shop.name,
      'buyingProduct': shop.buyingProduct,
      'phNo': shop.phNo,
      'buyAmtThisMon': shop.buyAmtThisMon,
    };
  }
}
