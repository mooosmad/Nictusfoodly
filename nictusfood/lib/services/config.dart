// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:nictusfood/models/cartmodel.dart';
import "package:geocoding/geocoding.dart" as geo;

class Config {
  static String rootUrl = "https://tchepexpress.com";
  static String key = "ck_629d70b2491f1ef60e1b4f5186d558717a18fe3f";
  static String secret = "cs_2bdb4e6ba8c7e2f48cd8d3a6e61692621dbc7108";
  static String url = "$rootUrl/wp-json/wc/v3/";
  static String customerUrl = "customers";
  static String tokenUrl = "$rootUrl/wp-json/jwt-auth/v1/token";

  String parserHTMLTAG(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String output = input.replaceAll(exp, ' ');
    return output;
  }

  bool isExistscart(RxList<CartModel> cart, CartModel cartItem) {
    return cart.contains(cartItem);
  }

  Future<String> getNameOfStreet(double lat, double long) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(lat, long);

    var myStreet = placemarks[0].street!;
    return myStreet;
  }

  Future<String> getNameOfQuartier(double lat, double long) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(lat, long);

    var quartier = "${placemarks[0].locality!},${placemarks[0].subLocality!}";
    return quartier;
  }
}
