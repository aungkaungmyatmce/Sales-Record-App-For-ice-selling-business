import '../model/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../model/product.dart';

class AllProvider with ChangeNotifier {
  CollectionReference allCollection =
      FirebaseFirestore.instance.collection('all');

  List<Shop> _allShopList = [];

  List<Shop> get allShop => [..._allShopList];

  List<Product> _allProductList = [];

  List<Product> get allProduct => [..._allProductList];

  List<String> allProductNames() {
    List<String?> names = _allProductList.map((prod) => prod.name).toList();
    List<String> namesRet = names.cast<String>();
    return namesRet;
  }

  Future<void> addOrEditShop({Shop? oldShop, required Shop newShop}) async {
    if (oldShop != null) {
      _allShopList.removeWhere((shop) => shop == oldShop);
    }
    _allShopList.add(newShop);
    await allCollection.doc('shopList').update({
      'shopList': _allShopList.map((sh) => Shop().toJson(sh)).toList(),
    });
    notifyListeners();
  }

  Future<void> deleteShop({required Shop shop}) async {
    _allShopList.removeWhere((sh) => sh == shop);
    await allCollection.doc('shopList').update({
      'shopList': _allShopList.map((sh) => Shop().toJson(sh)).toList(),
    });
    notifyListeners();
  }

  Future<void> addOrEditProduct(
      {Product? oldProduct, required Product newProduct}) async {
    if (oldProduct != null) {
      _allProductList.removeWhere((pro) => pro == oldProduct);
    }
    _allProductList.add(newProduct);
    await allCollection.doc('productList').update({
      'productList': _allProductList.map((sh) => Product().toJson(sh)).toList(),
    });
    notifyListeners();
  }

  Future<void> deleteProduct({required Product prod}) async {
    _allProductList.removeWhere((pr) => pr == prod);
    await allCollection.doc('productList').update({
      'productList': _allProductList.map((sh) => Product().toJson(sh)).toList(),
    });
    notifyListeners();
  }

  void addAllOfAll(QuerySnapshot snapshots) {
    final shopList = snapshots.docs.firstWhere((doc) => doc.id == 'shopList');
    if (shopList != null) {
      Map<String, dynamic> shopLi = shopList.data() as Map<String, dynamic>;
      final shopLists =
          shopLi['shopList'].map((shop) => Shop.fromJson(shop)).toList();
      _allShopList = shopLists.cast<Shop>();
    }

    final productList =
        snapshots.docs.firstWhere((doc) => doc.id == 'productList');
    if (productList != null) {
      Map<String, dynamic> productLi =
          productList.data() as Map<String, dynamic>;
      final productLists = productLi['productList']
          .map((product) => Product.fromJson(product))
          .toList();
      _allProductList = productLists.cast<Product>();
    }
    notifyListeners();
  }

  String? getShopPhNo(String shopName) {
    Shop shop = _allShopList.firstWhere((shop) => shop.name == shopName);
    return shop.phNo;
  }
}
