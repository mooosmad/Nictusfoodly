import 'package:get/get.dart';
import 'package:nictusfood/models/cartmodel.dart';

class MyCartController extends GetxController {
  var cart = List<CartModel>.empty(growable: true).obs;

  sumCart() {
    return cart
        .map((element) => double.parse(element.price!))
        .reduce((value, element) => value + element);
  } // le prix de tous les elements du pannier

  int getPrice() {
    var price = 0;
    cart.forEach((element) {
      price += int.parse(element.price!) * element.quantity!.value;
    });
    print(price);
    return price;
  }

  decrement(CartModel cartItem) {
    var toupdate =
        cart.firstWhere((element) => element.productId == cartItem.productId);
    toupdate.quantity = toupdate.quantity! - 1;
    update();
  }

  increment(CartModel cartItem) {
    var toupdate =
        cart.firstWhere((element) => element.productId == cartItem.productId);
    toupdate.quantity = toupdate.quantity! + 1;
    update();
  }

  remove(CartModel cartItem) {
    var toupdate =
        cart.firstWhere((element) => element.productId == cartItem.productId);
    cart.remove(toupdate);
    update();
  }
}
