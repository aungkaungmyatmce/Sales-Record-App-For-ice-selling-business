class Product {
  final String? name;
  final int? price;

  Product({this.name, this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> jsonData = json;
    return Product(name: jsonData['name'], price: jsonData['price']);
  }

  Map<String, dynamic> toJson(Product product) {
    return <String, dynamic>{
      'name': product.name,
      'price': product.price,
    };
  }
}
