// ignore_for_file: must_be_immutable

import 'package:get/get.dart';
import 'package:nictusfood/models/product.dart';

class CartModel extends Product {
  RxInt? quantity = 0.obs;
  CartModel(
      {images,
      price,
      productDesc,
      productId,
      productName,
      regularPrice,
      status,
      required this.quantity})
      : super(
          images: images,
          price: price,
          productDesc: productDesc,
          productId: productId,
          productName: productName,
          regularPrice: regularPrice,
          status: status,
        );

  factory CartModel.fromjson(Map<String, dynamic> map) {
    final product = Product.fromJson(map);
    RxInt quantite = 0.obs;

    return CartModel(
      images: product.images,
      price: product.price,
      productDesc: product.productDesc,
      productId: product.productId,
      productName: product.productName,
      regularPrice: product.regularPrice,
      status: product.status,
      quantity: quantite,
    );
  }

  // toJson() {
  //   return {};
  // }
}
