import 'package:nictusfood/models/product.dart';

class Order {
  int? idOrder;
  String? keyOrder;
  String? currency; // devise
  String? priceTotal;
  String? status;
  List<Product>? products;

  Order(
      {this.status,
      this.idOrder,
      this.currency,
      this.keyOrder,
      this.priceTotal,
      this.products});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      idOrder: json["id"],
      keyOrder: json["order_key"],
      currency: json["currency"],
      priceTotal: json["total"],
      status: json["status"],
      products: json["line_items"]
          .map((element) {
            return Product.fromJson(element);
          })
          .toList()
          .cast<Product>(),
    );
  }
}
